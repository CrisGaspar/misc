import pandas
from bmaapp.models import MunicipalityGroup

def delete_groups(data_year):
    MunicipalityGroup.objects.filter(year=data_year).delete()

def create_groups(file, data_year):
    df = pandas.read_csv(file, header = None)
    for index, row in df.iterrows():
        group_name = row[0]
        municipality_name = row[1]
        group = MunicipalityGroup()
        group.year = data_year
        group.group_name = group_name
        group.municipality_name = municipality_name
        group.save()

delete_groups(2019)
create_groups("2019_loc_groups.csv", 2019)
create_groups("2019_pop_groups.csv", 2019)
create_groups("2019_tier_groups.csv", 2019)
