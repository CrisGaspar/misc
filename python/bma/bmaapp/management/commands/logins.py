from django.core.management.base import BaseCommand, CommandError
from django.contrib.auth.models import User
import pandas as pd


class Command(BaseCommand):
    help = 'Adds users to django from csv file plus 1 superuser'

    def add_arguments(self, parser):
        parser.add_argument('year')
        parser.add_argument('username')
        parser.add_argument('password')

    # Creates users in DB based on given csv file
    def create_users(self, file, superuser_name, superuser_password):
        # read user credentials from given csv file
        users_data = pd.read_csv(file)

        # existing db creds: delete instead of upsert snce some users credentials may get revoked hence not present in the given file
        User.objects.all().delete()

        for index, row in users_data.iterrows():
            # skip first row that has column labels
            if index != 0:
                current_username = row['Login']
                current_password = row['Password']
                user = User.objects.create_user(username=current_username,password=current_password)

        # create superuser
        if superuser_name is None or superuser_password is None:
            self.stderr.write('Missing superuser name or password')
        else:
            user = User.objects.create_user(username=superuser_name,password=superuser_password)
            user.is_superuser=True
            user.is_staff=True
            user.save()

    def handle(self, *args, **options):
        year = options['year']
        self.create_users(f'data/{year}_logins.csv', options['username'], options['password'])

