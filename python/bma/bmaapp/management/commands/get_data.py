from django.core.management.base import BaseCommand, CommandError
from bmaapp.models import MunicipalityData
from bmaapp.utils import convert_db_data
import pandas


class Command(BaseCommand):
    help = 'Display data for given year and municipality'

    def add_arguments(self, parser):
        parser.add_argument('year')
        parser.add_argument('municipality')

    def get_data(self, data_year, municipality):
        db_data = MunicipalityData.objects.filter(year=data_year).filter(name=municipality)
        data = convert_db_data(db_data)
        self.stdout.write(f'{data}')

    def handle(self, *args, **options):
        year = options['year']
        municipality = options['municipality']
        if year is None or municipality is None:
            self.stderr.write('Missing year or municipality')
        self.get_data(year, municipality)

