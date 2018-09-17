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
import json
import logging

from bmaapp.models import EndUser, Municipality, MunicipalityData
from bmaapp.models import COLUMN_NAME_MULTI_RESIDENTIAL, COLUMN_NAME_TAX_RATIOS_MULTI_RESIDENTIAL
from bmaapp.models import COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA_WITH_YEAR_PREFIX, COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA

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
ERROR_USERID_DOES_NOT_EXIST = ' Userid does not exist'
ERROR_UNSUPPORTED_HTTP_OPERATION = 'Endpoint supports only GET and POST'
ERROR_USER_AUTHENTICATION_FAILED = 'Invalid userid or invalid password'
ERROR_MISSING_YEAR_PARAMETER = 'Missing year parameter'

#TODO: ADD LOGGING!!


EXPECTED_SHEET_NAMES = [
    "Population", "Density and Land Area", "Assessment Information", "Assessment Composition", "Building Permit Activity",

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


def clean(str):
    # convert "NA" to None
    if str == NA_VALUE:
        return None
    return str

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

# Helper methods
def is_user_allowed(current_user, target_user):
    return (current_user.username == target_user) or current_user.is_superuser

def error_response(error_msg):
    return JsonResponse({'success': 'false', 'error_message' : 'ERROR: ' + error_msg})

def success_response():
    return JsonResponse({'success': 'true', 'error_message': ''})

def login_success_response(is_superuser):
    return JsonResponse({'success': 'true', 'error_message': '', 'is_superuser': is_superuser})

def _json_object_hook(d): return namedtuple('X', d.keys())(*d.values())
def json2obj(data): return json.loads(data, object_hook=_json_object_hook)


# Create your views here.
def index(request):
    # TODO: IMPLEMENT THIS!
    return HttpResponse("Hello, world. You're at the BMA index.")

# PRE condition: user logged in
def get_municipalities_for_user(userID):
    try:
        entries = EndUser.objects.filter(userid = userID)
    except EndUser.DoesNotExist:
        entries = None

    municipalities = []
    for entry in entries:
        municipalities.append(entry.municipality_name)
    return JsonResponse({ "municipalities" : municipalities})

# PRE condition: user logged in
def store_municipalities_for_user(user_id, municipality_list):
    # delete any previously stored municipalities
    EndUser.objects.filter(userid=user_id).delete()
    for name in municipality_list:
        user = EndUser(userid=user_id, municipality_name=name)
        user.save()
    return


def municipalities(request):
    if request.user is None or not request.user.is_authenticated:
        return error_response(ERROR_USER_NOT_AUTHENTICATED)

    if request.method == 'GET' and 'userid' in request.GET:
        user_id = request.GET['userid']
        if user_id:
            if not is_user_allowed(request.user, user_id):
                return error_response(ERROR_USER_NOT_ALLOWED_OPERATION)

            return get_municipalities_for_user(user_id)
        else:
            return error_response(ERROR_MISSING_USERID_VALUE)

    if request.method == 'POST' and 'userid' in request.GET:
        user_id = request.GET['userid']

        if user_id:
            if not is_user_allowed(request.user, user_id):
                return error_response(ERROR_USER_NOT_ALLOWED_OPERATION)

            try:
                json_object = json.loads(request.body)
                municipality_list = json_object['municipalities']
                store_municipalities_for_user(user_id, municipality_list)
                return success_response()
            except EndUser.DoesNotExist as e:
                logging.error("ERROR: Userid {userid} does not exist")
                return error_response(ERROR_USERID_DOES_NOT_EXIST)
            except json.JSONDecodeError as e:
                return error_response(ERROR_JSON_DECODING_FAILED)
        else:
            return error_response(ERROR_MISSING_USERID_VALUE)

    if request.method == 'GET':
        try:
            municipalities = Municipality.objects.all()
            municipality_list = []
            #TODO: Fix to return the full info 3-tuple (name, study_location, population_band)
            for entry in municipalities:
                municipality_list.append(entry.name)
            return JsonResponse({'municipalities': municipality_list})
        except Municipality.DoesNotExist:
                return JsonResponse({'municipalities': []})

    if request.method == 'POST':
        if not request.user.is_superuser:
            return error_response(ERROR_USER_NOT_ALLOWED_OPERATION)

        try:
            json_object = json.loads(request.body)
            municipality_list = json_object['municipalities']

            # Delete previous entries
            Municipality.objects.all().delete()
            #TODO: Fix to store the full info 3-tuple (name, study_location, population_band)
            for municipality_name in municipality_list:
                municipality = Municipality(name=municipality_name)
                municipality.save()
        except json.JSONDecodeError as e:
            return error_response(ERROR_JSON_DECODING_FAILED)
        return success_response()

    return error_response(ERROR_UNSUPPORTED_HTTP_OPERATION)

def login(request):
    try:
        user_id = request.GET['userid']
        password = request.GET['password']
        user = authenticate(username = user_id, password = password)
    except MultiValueDictKeyError as e:
        user = None

    if user is not None:
        django_login(request, user)
        return login_success_response(user.is_superuser)

    return error_response(ERROR_USER_AUTHENTICATION_FAILED)

def logout(request):
    django_logout(request)
    return success_response()

def municipality_data(request):
    if request.user is None or not request.user.is_authenticated:
        return error_response(ERROR_USER_NOT_AUTHENTICATED)

    user_id = request.user.username

    if user_id is None:
        return error_response(ERROR_MISSING_USERID_VALUE)

    if request.method == 'GET':
        year = request.GET.get('year')
        print(year)
        return get_municipality_data(user_id, year)

    if request.method == 'POST':
        if not request.user.is_superuser:
            return error_response(ERROR_USER_NOT_ALLOWED_OPERATION)

        try:
            json_object = json.loads(request.body)
            data_to_write = json_object['data']

            #TODO: Fix to store the full info 3-tuple (name, study_location, population_band)
            for row_dict in data_to_write:
                print(row_dict)
                municipality_data = MunicipalityData()
                municipality_data.load(row_dict)
                municipality_data.save()
        except json.JSONDecodeError as e:
            return error_response(ERROR_JSON_DECODING_FAILED)
        return success_response()
    return error_response(ERROR_UNSUPPORTED_HTTP_OPERATION)


def get_municipality_data(userid, year):
    # TODO: restrict based on specified user's groupings preference
    dataset_for_year = MunicipalityData.objects.filter(year = year)

    # this gives you a list of dicts
    raw_data = serializers.serialize('python', dataset_for_year)
    # now extract the inner `fields` dicts
    actual_data = [d['fields'] for d in raw_data]
    # and now dump to JSON
    json_output = json.dumps(actual_data)

    return JsonResponse({'data':json_output})


def municipality_data_new(request):
    if request.user is None or not request.user.is_authenticated:
        return error_response(ERROR_USER_NOT_AUTHENTICATED)

    user_id = request.user.username

    if user_id is None:
        return error_response(ERROR_MISSING_USERID_VALUE)

    if request.method == 'GET':
        # TOOD: implement this!!!
        #year = request.GET.get('year')
        #print(year)
        #return get_municipality_data(user_id, year)
        return error_response("HTTP GET: to be implemented")

    if request.method == 'POST':
        if not request.user.is_superuser:
            return error_response(ERROR_USER_NOT_ALLOWED_OPERATION)

        try:
            year = request.GET.get('year')
            if year is None:
                return error_response(ERROR_MISSING_YEAR_PARAMETER)
            year = int(year)

            data_by_municipality_and_year = {}
            json_object = json.loads(request.body)
            data_to_write = json_object['data']
            print(data_to_write)

            for sheet_name, sheet_data in data_to_write.items():
                print(sheet_name)
                # each sheet can have different municipalities so reset
                municipalities = []

                if not sheet_name in EXPECTED_SHEET_NAMES:
                    logging.error("Unexpected sheet name: {}".format(sheet_name))
                    # ignore
                    continue
                for column_name, column_data in sheet_data.items():
                    print(column_name)
                    print(column_data)

                    if column_name == "Municipality":
                        municipalities = column_data
                    elif not municipalities:
                        # Municipalities has to be 1st column in sheet
                        return error_response("First column in sheet {} is {}. All sheets must have Municipalities as 1st column".format(sheet_name, column_name))
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
                                    return error_response("Column {} in sheet {} is for future year {} compared to year for the rest of the data ".format(column_name, sheet_name, year_to_use, year))
                            data_entry[property_name] = clean(val)

            print(data_by_municipality_and_year)

            # Now save each MunicipalityData to DB
            for (municipality, data_year), data in data_by_municipality_and_year.items():
                print (municipality, data_year)
                print (data)

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
                            logging.error("Exception raised when saving the DB entry for {} {}".format(municipality, data_year))
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
