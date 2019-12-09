from django.contrib.auth.models import User
import pandas as pd
creds_filename = "test.csv"

def create_users(file):
    df = pd.read_csv(file, header = None)
    # delete all creds
    # if we can figure out how to update when creation fails, that would be better
    #User.objects.all().delete()
    for index, row in df.iterrows():
        current_username = row[0]
        current_password = row[1]
        user = User.objects.create_user(username=current_username,password=current_password)

    # superuser
    #user = User.objects.create_user(username='crisoti',password=null)
    #user.is_superuser=True
    #user.is_staff=True
    #user.save()

create_users(creds_filename)