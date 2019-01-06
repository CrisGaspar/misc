from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.contrib.auth import authenticate
from django.contrib.auth import login as django_login
from django.contrib.auth import logout as django_logout
from django.contrib.auth.decorators import login_required
from django.core import serializers
from collections import namedtuple
from django.utils.datastructures import MultiValueDictKeyError
from django.db.utils import IntegrityError

import datetime
import simplejson as json
import logging
import re

from bmaapp.models import EndUser, Municipality, MunicipalityData, MunicipalityGroup
from bmaapp.models import COLUMN_NAME_MUNICIPALITY, COLUMN_NAME_MULTI_RESIDENTIAL, COLUMN_NAME_TAX_RATIOS_MULTI_RESIDENTIAL
from bmaapp.models import COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA_WITH_YEAR_PREFIX, \
    COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA

# ---------------------------------------------------------------------------------------------------------------------
# TODO:
# 1. Add back CSFR in settings.py
# ---------------------------------------------------------------------------------------------------------------------

# Create your views here.
def index(request):
    return HttpResponse("Hello, world. You're at the BMA index.")


def login(request):
    try:
        user_id = request.GET['userid']
        password = request.GET['password']
        user = authenticate(username=user_id, password=password)
    except MultiValueDictKeyError as e:
        user = None

    if user is not None:
        django_login(request, user)
        return success_response({'is_superuser': user.is_superuser})

    return error_response(ERROR_USER_AUTHENTICATION_FAILED)


def logout(request):
    django_logout(request)
    return success_response()


def all_municipalities(request):
    if request.user is None or not request.user.is_authenticated:
        return error_response(ERROR_USER_NOT_AUTHENTICATED)

    if request.method == 'GET':
        try:
            municipalities_from_db = MunicipalityData.objects.values_list('name', flat=True)
            municipality_list = []
            for municipality in municipalities_from_db:
                municipality_list.append(municipality)
            municipality_list = list(sorted(set(municipality_list)))
            return success_response({'municipalities': municipality_list})
        except MunicipalityData.DoesNotExist:
            return success_response({'municipalities': []})

    return error_response(ERROR_UNSUPPORTED_HTTP_OPERATION)

def municipality_groups(request):
    if request.user is None or not request.user.is_authenticated:
        return error_response(ERROR_USER_NOT_AUTHENTICATED)

    if request.method == 'GET':
        try:
            groups_from_db = MunicipalityGroup.objects.all()
            groups_dict = {}
            for group_entry in groups_from_db:
                key = group_entry.group_name
                value = group_entry.municipality_name
                # get existing group entry or empty list if none
                municipality_list = groups_dict.setdefault(key, [])
                municipality_list.append(value)

             # sort each municipality list
            groups_list = []
            for group_name, municipality_list in groups_dict.items():
                municipality_list.sort
                groups_list.append({'group_name': group_name, 'municipality_list': municipality_list})
            return success_response({'groups': groups_list})
        except Municipality.DoesNotExist:
            return success_response({'groups': []})

    return error_response(ERROR_UNSUPPORTED_HTTP_OPERATION)


def municipalities(request):
    if request.user is None or not request.user.is_authenticated:
        return error_response(ERROR_USER_NOT_AUTHENTICATED)

    user_id = request.user.username

    if request.method == 'GET':
        if user_id:
            municipality_list = get_municipalities_for_user(user_id)
            return success_response({'municipalities': municipality_list})
        else:
            return error_response(ERROR_MISSING_USERID_VALUE)

    if request.method == 'POST':
        if user_id:
            try:
                json_object = json.loads(request.body)
                municipality_list = json_object['municipalities']
                store_municipalities_for_user(user_id, municipality_list)
                return success_response()
            except EndUser.DoesNotExist as e:
                logging.error("Userid {userid} does not exist")
                return error_response(ERROR_USERID_DOES_NOT_EXIST)
            except json.JSONDecodeError as e:
                return error_response(ERROR_JSON_DECODING_FAILED)
        else:
            return error_response(ERROR_MISSING_USERID_VALUE)

    return error_response(ERROR_UNSUPPORTED_HTTP_OPERATION)

def municipality_data(request):
    if request.user is None or not request.user.is_authenticated:
        return error_response(ERROR_USER_NOT_AUTHENTICATED)

    if request.method == 'POST':
        try:
            year = request.GET.get('year')
            if year is None:
                return error_response(ERROR_MISSING_YEAR_PARAMETER)
            year = int(year)

            json_object = json.loads(request.body)

            municipalities = json_object.get('municipalities')
            if municipalities is not None:
                # Need to return the data for given municipalities for given year
                return get_municipality_data(municipalities, year)

            # check if this a store-data request
            data_to_write = json_object.get('data')

            if data_to_write is None:
                return error_response(ERROR_BAD_REQUEST_DATA_ENDPOINT)

            # municipality data writes are allowed only for superusers
            if not request.user.is_superuser:
                return error_response(ERROR_USER_NOT_ALLOWED_OPERATION)

            data_by_municipality_and_year = {}

            for sheet_name, sheet_data in data_to_write.items():
                # each sheet can have different municipalities so reset
                municipalities = []

                if not sheet_name in EXPECTED_SHEET_NAMES:
                    logging.error("Unexpected sheet name: {}".format(sheet_name))
                    # ignore
                    continue
                for column_name, column_data in sheet_data.items():
                    if column_name == "Municipality":
                        municipalities = column_data
                    elif not municipalities:
                        # Municipalities has to be 1st column in sheet
                        return error_response(
                            "First column in sheet {} is {}. All sheets must have Municipalities as first column".format(
                                sheet_name, column_name))
                    else:
                        (property_name, year_to_use) = split_to_year_and_property_name(column_name, year, sheet_name)
                        for index, val in enumerate(column_data):
                            municipality = municipalities[index]
                            tuple_key = (municipality, year_to_use)
                            if tuple_key in data_by_municipality_and_year:
                                data_entry = data_by_municipality_and_year[tuple_key]
                            else:
                                data_entry = None
                            if data_entry is None:
                                if year_to_use <= year:
                                    # no entry present in dictionary, create new entry
                                    data_entry = {}
                                    data_entry["Municipality"] = municipality
                                    data_entry["Year"] = year_to_use
                                    data_by_municipality_and_year[tuple_key] = data_entry
                                else:
                                    return error_response(
                                        "Column {} in sheet {} is for future year {} while the data upload is for year {}".format(
                                            column_name, sheet_name, year_to_use, year))
                            data_entry[property_name] = clean(val)

            # Go through each received municipality data
            for (municipality, data_year), data in data_by_municipality_and_year.items():
                # First get the data stored in DB for that municipality and year (if any)
                dataset_for_year = MunicipalityData.objects.filter(year=data_year).filter(name=municipality)

                existing_db_data = MunicipalityData()
                new_db_data = MunicipalityData()
                data_dict = {}

                for data_entry in dataset_for_year:
                    # should be at most 1 entry
                    existing_db_data = data_entry

                existing_db_data.store(data_dict)

                # Add new data to existing data
                for key, value in data.items():
                    if value is not None:
                        data_dict[key] = value

                # Load the dictionary into municipality data object
                new_db_data.load(data_dict)

                try:
                    # store to db. overwrite existing entry
                    new_db_data.save()
                except Exception as e:
                    logging.error(
                        "Exception raised when saving the DB entry for {} {}".format(municipality, data_year))
                    logging.error(e, exc_info=True)
        except json.JSONDecodeError as e:
            return error_response(ERROR_JSON_DECODING_FAILED)
        except Exception as e:
            logging.error(e, exc_info=True)
            return error_response("Encountered exception {}".format(str(e)))
        return success_response()
    return error_response(ERROR_UNSUPPORTED_HTTP_OPERATION)


def municipality_data_by_years(request):
    if request.user is None or not request.user.is_authenticated:
        return error_response(ERROR_USER_NOT_AUTHENTICATED)

    if request.method == 'POST':
        try:
            json_object = json.loads(request.body)

            municipalities = json_object.get('municipalities')
            years = json_object.get('years')
            data_columns = json_object.get('columns')

            if municipalities is None:
                return error_response(ERROR_BAD_REQUEST_DATA_NO_MUNICIPALITIES)

            if years is None:
                return error_response(ERROR_BAD_REQUEST_DATA_NO_YEARS)

            if data_columns is None:
                return error_response(ERROR_BAD_REQUEST_DATA_NO_COLUMNS)

            # Need to return the data for given municipalities for given year
            return get_municipality_data_by_years(municipalities, years, data_columns)
        except json.JSONDecodeError as e:
            return error_response(ERROR_JSON_DECODING_FAILED)
        except Exception as e:
            logging.error(e, exc_info=True)
            return error_response("Encountered exception {}".format(str(e)))
        return success_response()
    return error_response(ERROR_UNSUPPORTED_HTTP_OPERATION)


#-----------------------------------------------------------------------------------------------------------------------
# Data methods
#-----------------------------------------------------------------------------------------------------------------------

def get_municipality_data(municipalities_list, year):
    dataset_for_year = MunicipalityData.objects.filter(year=year).filter(name__in=municipalities_list).order_by('name')

    # Store data as list of dictionaries: one per each entry
    data = []
    for data_entry in dataset_for_year:
        data_dict = {}
        data_entry.store(data_dict)
        data.append(data_dict)
    return success_response({'data': data})

def get_column_name_with_year(name, year):
    return str(year) + " " + name

def create_empty_municipal_data_entry(municipality, years, data_columns):
    municipality_entry = { COLUMN_NAME_MUNICIPALITY: municipality }
    for column_name in data_columns:
        for year in years:
            column_name_with_year = get_column_name_with_year(column_name, year)
            municipality_entry[column_name_with_year] = None
    return municipality_entry


def get_municipality_data_by_years(municipalities_list, years, data_columns):
    dataset = MunicipalityData.objects.filter(year__in=years).filter(name__in=municipalities_list).order_by('year', 'name')

    # Store data as list of dictionaries: one per each entry
    data = []
    data_dict_by_municipality = {}

    for data_entry in dataset:
        municipality = data_entry.name
        if municipality in data_dict_by_municipality:
            municipality_entry =  data_dict_by_municipality[municipality]
        else:
            # new entry
            municipality_entry = create_empty_municipal_data_entry(municipality, years, data_columns)
            data_dict_by_municipality[municipality] = municipality_entry

        year = data_entry.year

        for column_name in data_columns:
            column_name_with_year = get_column_name_with_year(column_name, year)
            municipality_entry[column_name_with_year] = data_entry.get_column_value(column_name)

    for name, data_dict in data_dict_by_municipality.items():
        data.append(data_dict)

    return success_response({'data': data})

# PRE condition: user logged in
def get_municipalities_for_user(userID):
    try:
        entries = EndUser.objects.filter(userid=userID)
    except EndUser.DoesNotExist:
        entries = None

    municipalities = []
    for entry in entries:
        municipalities.append(entry.municipality_name)
    return municipalities


# PRE condition: user logged in
def store_municipalities_for_user(user_id, municipality_list):
    # delete any previously stored municipalities
    EndUser.objects.filter(userid=user_id).delete()
    for name in municipality_list:
        user = EndUser(userid=user_id, municipality_name=name)
        user.save()
    return

#-----------------------------------------------------------------------------------------------------------------------
# Helper methods
#-----------------------------------------------------------------------------------------------------------------------

def clean(val):
    # convert "NA" to None
    if val == NA_VALUE:
        return None
    return val


def split_to_year_and_property_name(str, default_year, sheet_name):
    # remove leading and trailing whitespace. replace repeated whitespace with single whitespace
    str = re.sub(' +', ' ', str.strip())

    # if str starts with a valid year, return (year, rest_of_str) tuple
    # if it does not, return (default_year, str) tuple

    property_name = str
    year_to_use = default_year

    if len(str) >= 5:
        try:
            year = int(str[0:4])
            if MIN_YEAR <= year <= MAX_YEAR:
                if str[4] == '-':
                    year = int(str[5:9])
                    if MIN_YEAR <= year <= MAX_YEAR:
                        # skip the whitespace
                        property_name = str[10:]
                        year_to_use = year
                elif str[4] == ' ':
                    # skip the whitespace
                    property_name = str[5:]
                    year_to_use = year
        except ValueError as err:
            # str does not start with year
            pass

    if property_name == COLUMN_NAME_MULTI_RESIDENTIAL and sheet_name == 'Tax Ratios':
        # this column name is same in both Tax Ratios and Assessment Composition sheets
        # but we now know it's the tax ratio one
        property_name = COLUMN_NAME_TAX_RATIOS_MULTI_RESIDENTIAL
    elif property_name == COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA_WITH_YEAR_PREFIX and sheet_name == 'Building Permit Activity':
        property_name = COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA

    return (property_name, year_to_use)


def is_user_allowed(current_user, target_user):
    return (current_user.username == target_user) or current_user.is_superuser


def _create_json_response(dict):
    # dict contains (name, object) pairs to be sent in the JSON response
    return JsonResponse(dict)


def error_response(error_msg):
    dict = {'success': 'false', 'error_message': 'ERROR: ' + error_msg}
    return _create_json_response(dict)


def success_response(dict=None):
    if dict is None:
        dict = {}
    dict['success'] = 'true'
    dict['error_message'] = ''
    return _create_json_response(dict)


def _json_object_hook(d): return namedtuple('X', d.keys())(*d.values())


def json2obj(data): return json.loads(data, object_hook=_json_object_hook)



#-----------------------------------------------------------------------------------------------------------------------
# Constants
#-----------------------------------------------------------------------------------------------------------------------

NA_VALUE = "NA"

CURRENT_YEAR = datetime.datetime.now().year
MIN_YEAR = 1990
MAX_YEAR = CURRENT_YEAR

# ERRORS
ERROR_DB_MUNICIPALITY_DATA_INSERT_UNIQUE_CONSTRAINT_FAIL = 'UNIQUE constraint failed: bmaapp_municipalitydata.yearPlusName'
ERROR_USER_NOT_AUTHENTICATED = 'User not authenticated. Call login endpoint first'
ERROR_USER_NOT_ALLOWED_OPERATION = 'User is not allowed to perform this operation'
ERROR_MISSING_USERID_VALUE = 'Missing userid value'
ERROR_JSON_DECODING_FAILED = 'JSON decoding failed for request body'
ERROR_USERID_DOES_NOT_EXIST = 'Userid does not exist'
ERROR_UNSUPPORTED_HTTP_OPERATION = 'Endpoint supports only GET and POST'
ERROR_USER_AUTHENTICATION_FAILED = 'Invalid userid or invalid password'
ERROR_MISSING_YEAR_PARAMETER = 'Missing year parameter'
ERROR_BAD_REQUEST_DATA_ENDPOINT = 'Bad request to data endpoint. No municipalities nor data objects in JSON body'
ERROR_BAD_REQUEST_DATA_NO_MUNICIPALITIES = 'Bad request to data_subset_by_years endpoint. No municipalities in JSON body'
ERROR_BAD_REQUEST_DATA_NO_YEARS = 'Bad request to data_subset_by_years endpoint. No year list in JSON body'
ERROR_BAD_REQUEST_DATA_NO_COLUMNS = 'Bad request to data_subset_by_years endpoint. No data columns list in JSON body'


EXPECTED_SHEET_NAMES = [
    "Population", "Density and Land Area", "Assessment Information", "Assessment Composition",
    "Building Permit Activity",

    "Total Levy", "Upper Tier Levy", "Lower Tier Levy", "Tax Asset Consumption Ratio",
    "Financial Position per Capita", "Tax Dis Res as % OSR", "Tax Reserves as % of Taxation",
    "Tax Res per Capita", "Tax Debt Int % OSR", "Tax Debt Charges as % OSR", "Total Debt Out per Capita",
    "Tax Debt Out per Capita", "Debt to Reserve Ratio", "Tax Receivable as % Tax",
    "Rates Coverage Ratio", "Net Fin Liab Ratio",

    "Development Charges", "Building Permit Fees",

    "Tax Ratios", "Optional Class",

    "Total Tax Rates", "Municipal Tax Rates", "Education Tax Rates", "Residential", "Multi-Residential",
    "Commercial", "Industrial",

    "Water&Sewer Costs", "Water Asset Consumption", "Wastewater Asset Consumption", "Water Res as % OSR",
    "Wastewater Res as % OSR", "Water Res as % Acum Amort", "Wastewater Res as % Acum Amort", "Water Debt Int Cover",
    "Wastewater Debt Int Cover", "Water Net Fin Liab", "Wastewater Net Fin Liab",

    "Average Household Income", "Average Value of Dwelling", "Combined costs", "Taxes as a % of Income",

    "Net Expenditures per Capita"
]

import pandas as pd
filename = "2018_pop_groups.csv"

def create_groups(file):
    df = pd.read_csv(file, header = None)
    for index, row in df.iterrows():
        group_name = row[0]
        municipality_name = row[1]
        group = MunicipalityGroup()
        group.group_name = group_name
        group.muncipality_name = municipality_name
        group.save()

#create_groups(filename)