from django.core.management.base import BaseCommand, CommandError
from bmaapp.models import MunicipalityGroup
from bmaapp.utils import normalize_name
import pandas


class Command(BaseCommand):
    help = 'Adds municipality groups to Django DB from csv files'

    def add_arguments(self, parser):
        parser.add_argument('year')

    def delete_groups(self, data_year):
        MunicipalityGroup.objects.filter(year=data_year).delete()

    def create_groups(self, file, data_year):
        df = pandas.read_csv(file, header = None)
        for index, row in df.iterrows():
            # ignore 1st row which has column labels
            if index != 0:
                group_name = row[0]
                municipality_name = normalize_name(row[1])
                group = MunicipalityGroup()
                group.year = data_year
                group.group_name = group_name
                group.municipality_name = municipality_name
                group.save()

    def handle(self, *args, **options):
        year = options['year']
        self.delete_groups(year)
        self.create_groups(f'data/{year}_locations.csv', year)
        self.create_groups(f'data/{year}_populations.csv', year)
        self.create_groups(f'data/{year}_tiers.csv', year)

