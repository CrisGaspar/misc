from django.contrib.auth.backends import ModelBackend
from django.contrib.auth.models import User

import logging

class HashedPasswordAuthBackend(ModelBackend):
    def authenticate(self, request = None, username=None, password=None):
        try:
            print("u: {} p: {}".format(username, password))
            print("ASDAD")
            logging.info("ASSA")

            return User.objects.get(username=username, password=password)
        except User.DoesNotExist:
            return None

    def get_user(self, user_id):
        try:
            return User.objects.get(pk=user_id)
        except User.DoesNotExist:
            return None