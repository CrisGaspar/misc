from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('login', views.login, name='login'),
    path('logout', views.logout, name='logout'),
    path('municipalities', views.municipalities, name='municipalities'),
    path('all_municipalities', views.all_municipalities, name='all_municipalities'),
    path('old_data', views.old_municipality_data, name='old_municipality_data'),
    path('data', views.municipality_data_new, name='municipality_data_new')
]