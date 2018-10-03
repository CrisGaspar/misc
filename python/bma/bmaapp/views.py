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

from bmaapp.models import EndUser, Municipality, MunicipalityData
from bmaapp.models import COLUMN_NAME_MULTI_RESIDENTIAL, COLUMN_NAME_TAX_RATIOS_MULTI_RESIDENTIAL
from bmaapp.models import COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA_WITH_YEAR_PREFIX, \
    COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA

# ---------------------------------------------------------------------------------------------------------------------
# TODO:
# 1. ADD LOGGING!!
# 2. Add back CSFR in settings.py
# ---------------------------------------------------------------------------------------------------------------------

# Create your views here.
def index(request):
    # TODO: IMPLEMENT THIS!
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
            municipalities = Municipality.objects.all()
            municipality_list = []
            # TODO: Fix to return the full info 3-tuple (name, study_location, population_band)
            for entry in municipalities:
                municipality_list.append(entry.name)
            return success_response({'municipalities': municipality_list})
        except Municipality.DoesNotExist:
            return success_response({'municipalities': []})

    if request.method == 'POST':
        if not request.user.is_superuser:
            return error_response(ERROR_USER_NOT_ALLOWED_OPERATION)

        try:
            json_object = json.loads(request.body)
            municipality_list = json_object['municipalities']

            # Delete previous entries
            Municipality.objects.all().delete()
            # TODO: Fix to store the full info 3-tuple (name, study_location, population_band)
            for municipality_name in municipality_list:
                municipality = Municipality(name=municipality_name)
                municipality.save()
        except json.JSONDecodeError as e:
            return error_response(ERROR_JSON_DECODING_FAILED)
        return success_response()

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
        if not request.user.is_superuser:
            return error_response(ERROR_USER_NOT_ALLOWED_OPERATION)

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

            # cHeck if this a store-data request
            data_to_write = json_object.get('data')

            if data_to_write is None:
                return error_response(ERROR_BAD_REQUEST_DATA_ENDPOINT)

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
                            "First column in sheet {} is {}. All sheets must have Municipalities as 1st column".format(
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
                                        "Column {} in sheet {} is for future year {} compared to year for the rest of the data ".format(
                                            column_name, sheet_name, year_to_use, year))
                            data_entry[property_name] = clean(val)

            # Now save each MunicipalityData to DB
            for (municipality, data_year), data in data_by_municipality_and_year.items():
                db_data = MunicipalityData()
                db_data.load(data)

                if data_year != year:
                    # Case: data where the column name indicates a year different from the user-specified year parameter
                    try:
                        # We will only insert the first time. we do not update if (municipality, year) row already exists
                        # so that we don't erase data because most of the other fields are for the different user-specified year parameter
                        # so they will empty/NA for this column specified year
                        db_data.save(force_insert=True)
                    except IntegrityError as e:
                        # One of the cases this exception is thrown is if for this different year we already have a
                        # (municipality, year) row.  In this case do not update.
                        if not ERROR_DB_MUNICIPALITY_DATA_INSERT_UNIQUE_CONSTRAINT_FAIL in str(e):
                            # log only if exception text is different unique constraint as expected
                            logging.error(
                                "Exception raised when saving the DB entry for {} {}".format(municipality, data_year))
                            logging.error(e, exc_info=True)
                else:
                    # given-year data: fully overwrite corresponding DB model objects
                    db_data.save()
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

def get_municipality_data(municipalities, year):
    dataset_for_year = MunicipalityData.objects.filter(year=year).filter(name__in=municipalities)

    # Store data as list of dict: one dict per each entry
    data = []
    for data_entry in dataset_for_year:
        data_dict = {}
        data_entry.store(data_dict)
        data.append(data_dict)
        print(data_dict)
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
    # if str starts with a valid year, return (year,rest_of_str) tuple
    # if it does not, return (default_year, str) tuple

    # remove leading and trailing whitespace
    property_name = str.strip()
    year_to_use = default_year

    print('str = {} default_year = {} sheet_name = {}'.format(str, default_year, sheet_name))

    if len(str) >= 5 and str[4] == ' ':
        try:
            year = int(str[0:4])
            if MIN_YEAR <= year <= MAX_YEAR:
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
    # dict contains (name, object) pairs to be in the JSON response
    print(dict)
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
