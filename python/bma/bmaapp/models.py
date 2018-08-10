from django.db import models

# Create your models here.
class EndUser(models.Model):
    userid = models.CharField(max_length=100)
    municipality_name =  models.CharField(max_length=100)

class Municipality(models.Model):
    name = models.CharField(max_length=100)
    study_location = models.CharField(max_length=100)
    population_band = models.CharField(max_length=100)