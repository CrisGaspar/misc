from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('login', views.login, name='login'),
    path('logout', views.logout, name='logout'),
    path('municipalities', views.municipalities, name='municipalities'),
    path('all_municipalities', views.all_municipalities, name='all_municipalities'),
    path('municipality_groups', views.municipality_groups, name='municipality_groups'),
    path('data', views.municipality_data, name='municipality_data'),
    path('data_subset_by_years', views.municipality_data_by_years, name='municipality_data_by_years')
]