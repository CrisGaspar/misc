def get_data_for_year(data_year, municipality):
    dataset_for_year = MunicipalityData.objects.filter(year=data_year).filter(name=municipality)
    for entry in dataset_for_year:
        print(entry.est_avg_household_income)

get_data_for_year(2017, "Aurora")