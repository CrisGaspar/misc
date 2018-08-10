from django.shortcuts import render
from django.http import HttpResponse, JsonResponse, Http404
from django.contrib.auth import authenticate
from django.contrib.auth import login as django_login
from django.contrib.auth import logout as django_logout
from django.contrib.auth.decorators import login_required
from django.utils.datastructures import MultiValueDictKeyError

import json

from bmaapp.models import EndUser, Municipality

# Create your views here.
def index(request):
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
#    except EndUser.DoesNotExist:
#        return
    for name in municipality_list:
        user = EndUser(userid=user_id, municipality_name=name)
        user.save()
    return


def municipalities(request):
    if request.user is None or not request.user.is_authenticated:
        error_msg = "ERROR: User MUST authenticate first"
        return error_response(error_msg)

    if request.method == 'GET' and 'userid' in request.GET:
        user_id = request.GET['userid']
        if user_id:
            if not is_user_allowed(request.user, user_id):
                error_msg = "ERROR: User can only access its own preferences"
                return error_response(error_msg)

            return get_municipalities_for_user(user_id)
        else:
            error_msg = "ERROR: Missing userid value in 'userid' query parameter"
            return error_response(error_msg)

    if request.method == 'POST' and 'userid' in request.GET:
        user_id = request.GET['userid']

        if user_id:
            if not is_user_allowed(request.user, user_id):
                error_msg = "ERROR: User can only access its own preferences"
                return error_response(error_msg)

            try:
                json_object = json.loads(request.body)
                municipality_list = json_object['municipalities']
                store_municipalities_for_user(user_id, municipality_list)
                return success_response()
            # TODO: Should there be unique error_codes defined and added to JSON response ?????????????
            except EndUser.DoesNotExist as e:
                error_msg = "ERROR: Userid {userid} does not exist"
                return error_response(error_msg)
            except json.JSONDecodeError as e:
                error_msg = "ERROR: JSON decoding failed for request body."
                return error_response(error_msg)
        else:
            error_msg = "ERROR: Missing userid value in 'userid' query parameter"
            return error_response(error_msg)

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
            error_msg = 'MUST be logged in as superuser to change full list of municipalities'
            return error_response(error_msg)

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
            error_msg = "ERROR: JSON decoding failed for request body."
            return error_response(error_msg)
        return success_response()

    raise Http404('ERROR: Municipalities endpoint supports only GET or POST')

def login(request):
    try:
        user_id = request.GET['userid']
        password = request.GET['password']
        user = authenticate(username = user_id, password = password)
    except MultiValueDictKeyError as e:
        user = None

    if user is not None:
        django_login(request, user)
        return success_response()

    error_msg = 'ERROR: Invalid userid or password'
    return error_response(error_msg)

def logout(request):
    django_logout(request)
    return success_response()


# Helper methods
def is_user_allowed(current_user, target_user):
    return (current_user.username == target_user) or current_user.is_superuser

def error_response(error_msg):
    return JsonResponse({'success': 'false', 'error_message' : error_msg})

def success_response():
    return JsonResponse({'success': 'true', 'error_message': ''})
