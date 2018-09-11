from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('login', views.login, name='login'),
    path('logout', views.logout, name='logout'),
    path('municipalities', views.municipalities, name='municipalities'),
    path('old_data', views.municipality_data, name='municipality_data'),
    path('data', views.municipality_data_new, name='municipality_data_new')
]