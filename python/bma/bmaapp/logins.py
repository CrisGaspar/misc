from django.contrib.auth.models import User
import pandas as pd
creds_filename = "test.csv"

def create_users(file):
    df = pd.read_csv(file, header = None)
    for index, row in df.iterrows():
        current_username = row[0]
        current_password = row[1]
        user = User.objects.create_user(username=current_username,password=current_password)

create_users(creds_filename)