import pandas
from bmaapp.models import MunicipalityGroup

# Update to correct year and correct filenames
year = 2020

def delete_groups(data_year):
    MunicipalityGroup.objects.filter(year=data_year).delete()

def create_groups(file, data_year):
    df = pandas.read_csv(file, header = None)
    for index, row in df.iterrows():
        # ignore 1st row which has column labels
        if index != 0:
            group_name = row[0]
            municipality_name = row[1]
            group = MunicipalityGroup()
            group.year = data_year
            group.group_name = group_name
            group.municipality_name = municipality_name
            group.save()

delete_groups(year)
create_groups("2020_locations.csv", year)
create_groups("2020_populations.csv", year)
create_groups("2020_tiers.csv", year)
