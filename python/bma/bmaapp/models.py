from django.db import models

default_decimal_places = 15
default_max_digits_year = 4
default_max_digits = 30
default_max_string_length = 100

COLUMN_NAME_MUNICIPALITY = 'Municipality'
COLUMN_NAME_YEAR = 'Year'

# self.region_county_district = dict.get('region_county_district')
# self.study_location = dict.get('study_location')
# self.tier = dict.get('tier')
# self.population_bands = dict.get('population_bands')

COLUMN_NAME_POPULATION_DENSITY = 'Population Density per sq. km.'
COLUMN_NAME_POPULATION = 'Population'
COLUMN_NAME_LAND_AREA = 'Land Area km2'
COLUMN_NAME_POPULATION_INCREASE = 'Population Increase'
COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA = 'Building Construction Value per Capita'
COLUMN_NAME_ESTIMATED_AVG_HOUSEHOLD_INCOME = 'Estimated Average Household Income'
COLUMN_NAME_WEIGHTED_MEDIAN_VAL_DWELLING = 'Weighted Median Value of Dwelling'
COLUMN_NAME_UNWEIGHTED_ASSESSMENT_PER_CAPITA = 'Unweighted Assessment per Capita'
COLUMN_NAME_WEIGHTED_ASSESSMENT_PER_CAPITA = 'Weighted Assessment per Capita'
COLUMN_NAME_TOTAL_UNWEIGHTED_ASSESSMENT = 'Total Unweighted Assessment'
COLUMN_NAME_TOTAL_WEIGHTED_ASSESSMENT = 'Total Weighted Assessment'
COLUMN_NAME_RESIDENTIAL = 'Residential'
COLUMN_NAME_MULTI_RESIDENTIAL = 'Multi-Residential'
COLUMN_NAME_COMMERCIAL = 'Commercial'
COLUMN_NAME_INDUSTRIAL = 'Industrial'
COLUMN_NAME_PIPELINES = 'Pipelines'
COLUMN_NAME_FARMLANDS = 'Farmlands'
COLUMN_NAME_FORESTS = 'Forests'
COLUMN_NAME_BUILDING_CONSTRUCTION_VALUE = 'Building Construction Value ($000)'
COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA_WITH_YEAR_PREFIX = 'per Capita'
COLUMN_NAME_TOTAL_NET_LEVY = 'Total Net Levy (Upper and Lower Tiers)'
COLUMN_NAME_LEVY_PER_CAPITA = 'Levy per Capita'
COLUMN_NAME_UPPER_TIER_LEVY = 'Upper Tier Levy'
COLUMN_NAME_UPPER_TIER_LEVY_PER_CAPITA = 'Upper Tier Levy per Capita'
COLUMN_NAME_LOWER_TIER_LEVY = 'Lower Tier Levy'
COLUMN_NAME_LOWER_TIER_LEVY_PER_CAPITA = 'Lower Tier Levy per Capita'
COLUMN_NAME_TAX_ASSET_CONSUMPTION_RATIO = 'Tax Asset Consumption Ratio'
COLUMN_NAME_FINANCIAL_POSITION_PER_CAPITA = 'Financial Position per Capita'
COLUMN_NAME_TAX_DISCRETIONARY_RESERVES_PERCENT_SOURCE_REVENUES = 'Tax Discretionary Reserves as a % of Own Source Revenues'
COLUMN_NAME_TAX_RESERVES_PERCENT_TAXATION = 'Tax Reserves as a % of Taxation'
COLUMN_NAME_TAX_RESERVE_PER_CAPITA = 'Tax Reserves / Capita'
COLUMN_NAME_TAX_DEBT_INT_PERCENT_OSR = 'Tax Debt Int as % OSR'
COLUMN_NAME_TAXR_DEBT_CHARGES_PERCENT_OSR = 'Tax Debt Charges as % OSR'
COLUMN_NAME_TOTAL_DEBT_OUTSTANDING_PER_CAPITA = 'Total Debt Outstanding / Capita'
COLUMN_NAME_TAX_DEBT_OUTSTANDING_PER_CAPITA = 'Tax Debt Outstanding / Capita'
COLUMN_NAME_DEBT_TO_RESERVE_RATIO = 'Debt to Reserve Ratio'
COLUMN_NAME_TAXES_RECEIVABLE_PERCENT_TAXES_LEVIED = 'Taxes Receivable as a % of Taxes Levied'
COLUMN_NAME_RATES_COVERAGE_RATIO = 'Rates Coverage Ratio'
COLUMN_NAME_NET_FINANCIAL_LIABILITIES_RATIO = 'Net Financial Liabilities Ratio'
COLUMN_NAME_SINGLE_DETACHED_DWELLINGS_PER_UNIT = 'Single Detached Dwellings per unit'
COLUMN_NAME_MULTIPLES_DWELLING__3_OR_MORE = 'Multiples Dwelling 3+ per unit'
COLUMN_NAME_MULTIPLES_DWELLING_1_OR_2 = 'Multiples Dwelling 1&2 per unit'
COLUMN_NAME_APARTMENT_UNITS_2_OR_MORE = 'Apartment units >=2 per unit'
COLUMN_NAME_APARTMENT_UNITS_LESS_THAN_2 = 'Apartment units < 2 per unit'
COLUMN_NAME_NON_RESIDENTIAL_COMMERCIAL_PER_SQFT = 'Non Residential Commercial per sq. ft.'
COLUMN_NAME_NON_RESIDENTIAL_INDUSTRIAL_PER_SQFT = 'Non Residential Industrial per sq. ft.'
COLUMN_NAME_BUILDING_PERMIT_FEE = 'Building Permit Fee'

COLUMN_NAME_TAX_RATIOS_MULTI_RESIDENTIAL = 'Multi-Residential Tax Ratio'
COLUMN_NAME_TAX_RATIOS_COMMERCIAL_RESIDUAL = 'Commercial (Residual)'
COLUMN_NAME_TAX_RATIOS_INDUSTRIAL_RESIDUAL = 'Industrial (Residual)'

COLUMN_NAME_NEW_MULTI_RESIDENTIAL = 'New Multi-Residential'
COLUMN_NAME_COMMERCIAL_OFFICE = 'Commercial Office'
COLUMN_NAME_COMMERCIAL_SHOPPING = 'Commercial Shopping'
COLUMN_NAME_COMMERCIAL_PARKING = 'Commercial Parking'
COLUMN_NAME_INDUSTRIAL_LARGE = 'Industrial Large'
COLUMN_NAME_TOTAL_RESID = 'Total Resid.'
COLUMN_NAME_TOTAL_MULTI_RESID = 'Total Multi Resid.'
COLUMN_NAME_TOTAL_COMMERCIAL_RESIDUAL = 'Total Comm. Residual'
COLUMN_NAME_TOTAL_COMMERCIAL_OFFICE = 'Total Comm. Office'
COLUMN_NAME_TOTAL_COMMERCIAL_PARK_VAC = 'Total Commercial Park/Vac'
COLUMN_NAME_TOTAL_COMMERCIAL_SHOPPING = 'Total Comm. Shopping'
COLUMN_NAME_TOTAL_INDUSTRIAL_RESIDUAL = 'Total Ind. Residual'
COLUMN_NAME_TOTAL_INDUSTRIAL_LARGE = 'Total Ind. Large'
COLUMN_NAME_MUNICIPAL_RESID = 'Municipal Resid.'
COLUMN_NAME_MUNICIPAL_MULTI_RESID = 'Municipal Multi Resid.'
COLUMN_NAME_MUNICIPAL_COMM_RESIDUAL = 'Municipal Comm. Residual'
COLUMN_NAME_MUNICIPAL_COMM_OFFICE = 'Municipal Comm. Office'
COLUMN_NAME_MUNICIPAL_COMMERCIAL_PARK_VAC = 'Municipal Commercial Park/Vac'
COLUMN_NAME_MUNICIPAL_COMM_SHOPPING = 'Municipal Comm. Shopping'
COLUMN_NAME_MUNICIPAL_IND_RESIDUAL = 'Municipal Ind. Residual'
COLUMN_NAME_MUNICIPAL_IND_LARGE = 'Municipal Ind. Large'
COLUMN_NAME_EDUCATION_RESID = 'Education Resid.'
COLUMN_NAME_EDUCATION_MULTI_RESID = 'Education Multi Resid.'
COLUMN_NAME_EDUCATION_COMM_RESIDUAL = 'Education Comm. Residual'
COLUMN_NAME_EDUCATION_COMM_OFFICE = 'Education Comm. Office'
COLUMN_NAME_EDUCATION_COMMERCIAL_PARK_VAC = 'Education Commercial Park/Vac'
COLUMN_NAME_EDUCATION_COMM_SHOPPING = 'Education Comm. Shopping'
COLUMN_NAME_EDUCATION_IND_RESIDUAL = 'Education Ind. Residual'
COLUMN_NAME_EDUCATION_IND_LARGE = 'Education Ind. Large'
COLUMN_NAME_BUNGALOW = 'Bungalow'
COLUMN_NAME_2_STOREY = '2 Storey'
COLUMN_NAME_EXECUTIVE = 'Executive'
COLUMN_NAME_MULTI_RES_WALK_UP = 'Multi-Res Walk up'
COLUMN_NAME_MULTI_RES_HIGH_RISE = 'Multi-Res High Rise'
COLUMN_NAME_TAX_SHOPPING = 'Shopping'
COLUMN_NAME_TAX_HOTEL = 'Hotel'
COLUMN_NAME_TAX_MOTEL = 'Motel'
COLUMN_NAME_TAX_OFFICE = 'Office'
COLUMN_NAME_TAX_IND_STANDARD = 'Industrial Standard'
COLUMN_NAME_TAX_IND_LARGE = 'Industrial Large'
COLUMN_NAME_TAX_IND_VACANT = 'Industrial Vacant'

COLUMN_NAME_RESIDENTIAL_200_M3 = 'Residential 200 m3 5/8"'
COLUMN_NAME_COMMERCIAL_10K_M3 = 'Commercial 10,000 m3 2"'
COLUMN_NAME_INDUSTRIAL_30K_M3 = 'Industrial 30,000 m3 3"'
COLUMN_NAME_INDUSTRIAL_100K_M3 = 'Industrial 100,000 m3 4"'
COLUMN_NAME_INDUSTRIAL_500K_M3 = 'Industrial 500,000 m3 6"'
COLUMN_NAME_WATER_ASSET_CONSUMPTION = 'Water Asset Consumption'
COLUMN_NAME_WW_ASSET_CONSUMPTION = 'WW Asset Consumption'
COLUMN_NAME_WATER_RES_PERCENT_OSR = 'Water Res As % OSR'
COLUMN_NAME_WW_RES_PERCENT_OSR = 'WW Res As % OSR'
COLUMN_NAME_WATER_RES_PERCENT_ACUM_AMORT = 'Water Res as % Acum Amort'
COLUMN_NAME_WW_RES_PERCENT_ACUM_AMORT = 'WW Res as % Acum Amort'
COLUMN_NAME_WATER_DEBT_INTEREST_COVERAGE = 'Water Debt Interest Coverage'
COLUMN_NAME_WW_DEBT_INTEREST_COVERAGE = 'WW Debt Interest Coverage'
COLUMN_NAME_WATER_NET_LIN_LIAB = 'Water Net Lin Liab'
COLUMN_NAME_WW_NET_LIN_LIAB = 'WW Net Lin Liab'
COLUMN_NAME_EST_AVG_HOUSEHOLD_INCOME = 'Est. Avg. Household Income'
COLUMN_NAME_RESIDENTIAL_WATER_SEWER_COSTS = 'Residential - Water and Sewer Costs'
COLUMN_NAME_AVG_RESIDENTIAL_TAXES = 'Average Residential Taxes'
COLUMN_NAME_PROPERTY_TAXES_PERCENT_HOUSEHOLD_INCOME = 'Property Taxes as a % of Household Income'
COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN = 'Total Municipal Tax Burden'
COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN_PERCENT_HOUSEHOLD_INCOME = 'Total Municipal Burden as a % of Household Income'

COLUMN_NAME_FIRE = 'Fire'
COLUMN_NAME_ROADS_PAVED = 'Roads Paved'
COLUMN_NAME_BRIDGES_CULVERTS = 'Bridges and Culverts'
COLUMN_NAME_TRAFFIC = 'Traffic'
COLUMN_NAME_WINTER_ROADS = 'Winter Roads'
COLUMN_NAME_WINTER_SIDEWALKS = 'Winter Sidewalks'
COLUMN_NAME_TRANSIT = 'Transit'
COLUMN_NAME_PARKING = 'Parking'
COLUMN_NAME_WASTE_COLLECTION = 'Waste Collection'
COLUMN_NAME_WASTE_DISPOSAL = 'Waste Disposal'
COLUMN_NAME_STORM = 'Storm'
COLUMN_NAME_RECYCLING = 'Recycling'
COLUMN_NAME_PUBLIC_HEALTH = 'Public Health'
COLUMN_NAME_EMERGENCY_MEASURES = 'Emergency Measures'
COLUMN_NAME_GENERAL_ASSISTANCE = 'General Assistance'
COLUMN_NAME_ASSISTANCE_AGED = 'Assistance to the Aged'
COLUMN_NAME_POA = 'POA'
COLUMN_NAME_CHILD_CARE = 'Child Care'
COLUMN_NAME_SOCIAL_HOUSING = 'Social Housing'
COLUMN_NAME_PARKS = 'Parks'
COLUMN_NAME_RECREATION_PROGRAMS = 'Recreation Programs'
COLUMN_NAME_REC_FAC_GOLF = 'Rec Fac Golf'
COLUMN_NAME_REC_FACILITIES_OTHER = 'Rec Facilities Other'
COLUMN_NAME_LIBRARY = 'Library'
COLUMN_NAME_MUSEUMS = 'Museums'
COLUMN_NAME_CULTURAL = 'Cultural'
COLUMN_NAME_PLANNING = 'Planning'
COLUMN_NAME_COMM_IND = 'Comm & Ind.'
COLUMN_NAME_GENERAL_GOVERNMENT = 'General Government'
COLUMN_NAME_CONSERVATION_AUTHORITY = 'Conservation Authority'
COLUMN_NAME_AMBULANCE = 'Ambulance'
COLUMN_NAME_CEMETERIES = 'Cemeteries'


# create your models here.

class EndUser(models.Model):
    userid = models.CharField(max_length=default_max_string_length, null=True)
    municipality_name = models.CharField(max_length=default_max_string_length, null=True)


class Municipality(models.Model):
    name = models.CharField(max_length=default_max_string_length, null=True)
    study_location = models.CharField(max_length=default_max_string_length, null=True)
    population_band = models.CharField(max_length=default_max_string_length, null=True)

class MunicipalityGroup(models.Model):
    group_name = models.CharField(max_length=default_max_string_length, null=True)
    muncipality_name = models.CharField(max_length=default_max_string_length, null=True)


class MunicipalityData(models.Model):
    # NOTE: Django does not allow a primary key with multiple columns despite the fact that mysql DB
    # it uses actually does allow that
    # Hence the need for the following extra field that combines municipality name with year to create a
    # combined primary key
    yearPlusName = models.CharField(max_length=default_max_string_length + 4, primary_key=True)

    name = models.CharField(max_length=default_max_string_length)
    year = models.IntegerField()

    region_county_district = models.CharField(max_length=default_max_string_length, null=True)
    study_location = models.CharField(max_length=default_max_string_length, null=True)
    tier = models.CharField(max_length=default_max_string_length, null=True)
    population_bands = models.CharField(max_length=default_max_string_length, null=True)

    land_area_km2 = models.CharField(max_length=default_max_string_length, null=True)
    population = models.IntegerField(null=True)
    population_density_per_km2 = models.DecimalField(max_digits=default_max_digits,
                                                     decimal_places=default_decimal_places, null=True)
    population_increase_percent = models.DecimalField(max_digits=default_max_digits,
                                                      decimal_places=default_decimal_places, null=True)
    building_construction_value = models.DecimalField(max_digits=default_max_digits,
                                                      decimal_places=default_decimal_places, null=True)
    building_construction_per_capita_value = models.DecimalField(max_digits=default_max_digits,
                                                                 decimal_places=default_decimal_places, null=True)
    estimated_average_household_income = models.DecimalField(max_digits=default_max_digits,
                                                             decimal_places=default_decimal_places, null=True)
    weighted_median_dwelling_value = models.DecimalField(max_digits=default_max_digits,
                                                         decimal_places=default_decimal_places, null=True)
    unweighted_assessment_per_capita = models.DecimalField(max_digits=default_max_digits,
                                                           decimal_places=default_decimal_places, null=True)
    weighted_assessment_per_capita = models.DecimalField(max_digits=default_max_digits,
                                                         decimal_places=default_decimal_places, null=True)
    total_unweighted_assessment = models.DecimalField(max_digits=default_max_digits,
                                                      decimal_places=default_decimal_places, null=True)
    total_weighted_assessment = models.DecimalField(max_digits=default_max_digits,
                                                    decimal_places=default_decimal_places, null=True)

    residential = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    multi_residential = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                            null=True)
    commercial = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    industrial = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    pipelines = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    farmlands = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    forests = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)

    total_net_levy_upper_and_lower_tiers = models.DecimalField(max_digits=default_max_digits,
                                                               decimal_places=default_decimal_places, null=True)
    levy_per_capita = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                          null=True)
    upper_tier_levy = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                          null=True)
    upper_tier_levy_per_capita = models.DecimalField(max_digits=default_max_digits,
                                                     decimal_places=default_decimal_places, null=True)
    lower_tier_levy = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                          null=True)
    lower_tier_levy_per_capita = models.DecimalField(max_digits=default_max_digits,
                                                     decimal_places=default_decimal_places, null=True)
    tax_asset_consumption_ratio = models.DecimalField(max_digits=default_max_digits,
                                                      decimal_places=default_decimal_places, null=True)
    financial_position_per_capita = models.DecimalField(max_digits=default_max_digits,
                                                        decimal_places=default_decimal_places, null=True)
    tax_discretionary_reserves_percent_own_source_revenues = models.DecimalField(max_digits=default_max_digits,
                                                                                 decimal_places=default_decimal_places,
                                                                                 null=True)
    tax_reserves_percent_taxation = models.DecimalField(max_digits=default_max_digits,
                                                        decimal_places=default_decimal_places, null=True)
    tax_reserves_capita = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                              null=True)
    tax_debt_int_percent_osr = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                                   null=True)
    tax_debt_charges_percent_osr = models.DecimalField(max_digits=default_max_digits,
                                                       decimal_places=default_decimal_places, null=True)
    total_debt_outstanding_capita = models.DecimalField(max_digits=default_max_digits,
                                                        decimal_places=default_decimal_places, null=True)
    tax_debt_outstanding_capita = models.DecimalField(max_digits=default_max_digits,
                                                      decimal_places=default_decimal_places, null=True)
    debt_to_reserve_ratio = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                                null=True)
    taxes_receivable_percent_taxes_levied = models.DecimalField(max_digits=default_max_digits,
                                                                decimal_places=default_decimal_places, null=True)
    rates_coverage_ratio = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                               null=True)
    net_financial_liabilities_ratio = models.DecimalField(max_digits=default_max_digits,
                                                          decimal_places=default_decimal_places, null=True)

    single_detached_dwellings_per_unit = models.DecimalField(max_digits=default_max_digits,
                                                             decimal_places=default_decimal_places, null=True)
    multiples_dwelling_3_plus_per_unit = models.DecimalField(max_digits=default_max_digits,
                                                             decimal_places=default_decimal_places, null=True)
    multiples_dwelling_1_or_2_per_unit = models.DecimalField(max_digits=default_max_digits,
                                                             decimal_places=default_decimal_places, null=True)
    apartment_units_at_least_2_per_unit = models.DecimalField(max_digits=default_max_digits,
                                                              decimal_places=default_decimal_places, null=True)
    apartment_units_less_than_2_per_unit = models.DecimalField(max_digits=default_max_digits,
                                                               decimal_places=default_decimal_places, null=True)
    non_residential_commercial_per_sq_ft = models.DecimalField(max_digits=default_max_digits,
                                                               decimal_places=default_decimal_places, null=True)
    non_residential_industrial_per_sq_ft = models.DecimalField(max_digits=default_max_digits,
                                                               decimal_places=default_decimal_places, null=True)
    building_permit_fee = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                              null=True)

    multi_residential_tax_ratio = models.DecimalField(max_digits=default_max_digits,
                                                      decimal_places=default_decimal_places, null=True)
    commercial_residual = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                              null=True)
    industrial_residual = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                              null=True)

    new_multi_residential = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                                null=True)
    commercial_office = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                            null=True)
    commercial_shopping = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                              null=True)
    commercial_parking = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                             null=True)
    industrial_large = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                           null=True)

    total_resid = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    total_multi_resid = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                            null=True)
    total_comm_residual = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                              null=True)
    total_comm_office = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                            null=True)
    total_commercial_park_vac = models.DecimalField(max_digits=default_max_digits,
                                                    decimal_places=default_decimal_places, null=True)
    total_comm_shopping = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                              null=True)
    total_ind_residual = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                             null=True)
    total_ind_large = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                          null=True)

    municipal_resid = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                          null=True)
    municipal_multi_resid = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                                null=True)
    municipal_comm_residual = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                                  null=True)
    municipal_comm_office = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                                null=True)
    municipal_commercial_park_vac = models.DecimalField(max_digits=default_max_digits,
                                                        decimal_places=default_decimal_places, null=True)
    municipal_comm_shopping = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                                  null=True)
    municipal_ind_residual = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                                 null=True)
    municipal_ind_large = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                              null=True)

    education_resid = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                          null=True)
    education_multi_resid = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                                null=True)
    education_comm_residual = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                                  null=True)
    education_comm_office = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                                null=True)
    education_commercial_park_vac = models.DecimalField(max_digits=default_max_digits,
                                                        decimal_places=default_decimal_places, null=True)
    education_comm_shopping = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                                  null=True)
    education_ind_residual = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                                 null=True)
    education_ind_large = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                              null=True)

    bungalow = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    two_storey = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    executive = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    multi_res_walk_up = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                            null=True)
    multi_res_high_rise = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                              null=True)
    shopping = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    hotel = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    motel = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    office = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    industrial_standard = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                              null=True)
    industrial_large = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                           null=True)
    industrial_vacant = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                            null=True)

    residential_200_m3_5_8_inch = models.DecimalField(max_digits=default_max_digits,
                                                      decimal_places=default_decimal_places, null=True)
    commercial_10000_m3_2_inch = models.DecimalField(max_digits=default_max_digits,
                                                     decimal_places=default_decimal_places, null=True)
    industrial_30000_m3_3_inch = models.DecimalField(max_digits=default_max_digits,
                                                     decimal_places=default_decimal_places, null=True)
    industrial_100000_m3_4_inch = models.DecimalField(max_digits=default_max_digits,
                                                      decimal_places=default_decimal_places, null=True)
    industrial_500000_m3_6_inch = models.DecimalField(max_digits=default_max_digits,
                                                      decimal_places=default_decimal_places, null=True)
    water_asset_consumption = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                                  null=True)
    ww_asset_consumption = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                               null=True)
    water_res_as_percent_osr = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                                   null=True)
    ww_res_percent_osr = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                             null=True)
    water_res_as_percent_acum_amort = models.DecimalField(max_digits=default_max_digits,
                                                          decimal_places=default_decimal_places, null=True)
    ww_res_percent_acum_amort = models.DecimalField(max_digits=default_max_digits,
                                                    decimal_places=default_decimal_places, null=True)
    water_debt_interest_coverage = models.DecimalField(max_digits=default_max_digits,
                                                       decimal_places=default_decimal_places, null=True)
    ww_debt_interest_coverage = models.DecimalField(max_digits=default_max_digits,
                                                    decimal_places=default_decimal_places, null=True)
    water_net_lin_liab = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                             null=True)
    ww_net_lin_liab = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                          null=True)
    est_avg_household_income = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                                   null=True)
    residential_water_sewer_costs = models.DecimalField(max_digits=default_max_digits,
                                                        decimal_places=default_decimal_places, null=True)
    average_residential_taxes = models.DecimalField(max_digits=default_max_digits,
                                                    decimal_places=default_decimal_places, null=True)
    property_taxes_percent_household_income = models.DecimalField(max_digits=default_max_digits,
                                                                  decimal_places=default_decimal_places, null=True)
    total_municipal_tax_burden = models.DecimalField(max_digits=default_max_digits,
                                                     decimal_places=default_decimal_places, null=True)
    total_municipal_burden_percent_household_income = models.DecimalField(max_digits=default_max_digits,
                                                                          decimal_places=default_decimal_places,
                                                                          null=True)

    fire = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    roads_paved = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    bridges_and_culverts = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                               null=True)
    traffic = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    winter_roads = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    winter_sidewalks = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                           null=True)
    transit = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    parking = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    waste_collection = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                           null=True)
    waste_disposal = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                         null=True)
    storm = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    recycling = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    public_health = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    emergency_measures = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                             null=True)
    general_assistance = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                             null=True)
    assistance_to_the_aged = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                                 null=True)
    poa = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    child_care = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    social_housing = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                         null=True)
    parks = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    recreation_programs = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                              null=True)
    rec_fac_golf = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    rec_facilities_other = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                               null=True)
    library = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    museums = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    cultural = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    planning = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    comm_and_ind = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    general_government = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                             null=True)
    conservation_authority = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places,
                                                 null=True)
    ambulance = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)
    cemeteries = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)

    def store(self, dict):
        dict.clear()

        dict[COLUMN_NAME_MUNICIPALITY] = self.name
        dict[COLUMN_NAME_YEAR] = self.year

        #        dict[] = self.region_county_district
        #        dict[] = self.study_location
        #        dict[] = self.tier
        #        dict[] = self.population_bands

        dict[COLUMN_NAME_POPULATION_DENSITY] = self.population_density_per_km2
        dict[COLUMN_NAME_POPULATION] = self.population
        dict[COLUMN_NAME_LAND_AREA] = self.land_area_km2

        dict[COLUMN_NAME_POPULATION_INCREASE] = self.population_increase_percent
        dict[COLUMN_NAME_BUILDING_CONSTRUCTION_VALUE] = self.building_construction_value
        dict[COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA] = self.building_construction_per_capita_value
        dict[COLUMN_NAME_ESTIMATED_AVG_HOUSEHOLD_INCOME] = self.estimated_average_household_income
        dict[COLUMN_NAME_WEIGHTED_MEDIAN_VAL_DWELLING] = self.weighted_median_dwelling_value
        dict[COLUMN_NAME_UNWEIGHTED_ASSESSMENT_PER_CAPITA] = self.unweighted_assessment_per_capita
        dict[COLUMN_NAME_WEIGHTED_ASSESSMENT_PER_CAPITA] = self.weighted_assessment_per_capita
        dict[COLUMN_NAME_TOTAL_UNWEIGHTED_ASSESSMENT] = self.total_unweighted_assessment
        dict[COLUMN_NAME_TOTAL_WEIGHTED_ASSESSMENT] = self.total_weighted_assessment

        dict[COLUMN_NAME_RESIDENTIAL] = self.residential
        dict[COLUMN_NAME_MULTI_RESIDENTIAL] = self.multi_residential
        dict[COLUMN_NAME_COMMERCIAL] = self.commercial
        dict[COLUMN_NAME_INDUSTRIAL] = self.industrial
        dict[COLUMN_NAME_PIPELINES] = self.pipelines
        dict[COLUMN_NAME_FARMLANDS] = self.farmlands
        dict[COLUMN_NAME_FORESTS] = self.forests

        dict[COLUMN_NAME_TOTAL_NET_LEVY] = self.total_net_levy_upper_and_lower_tiers
        dict[COLUMN_NAME_LEVY_PER_CAPITA] = self.levy_per_capita
        dict[COLUMN_NAME_UPPER_TIER_LEVY] = self.upper_tier_levy
        dict[COLUMN_NAME_UPPER_TIER_LEVY_PER_CAPITA] = self.upper_tier_levy_per_capita
        dict[COLUMN_NAME_LOWER_TIER_LEVY] = self.lower_tier_levy
        dict[COLUMN_NAME_LOWER_TIER_LEVY_PER_CAPITA] = self.lower_tier_levy_per_capita
        dict[COLUMN_NAME_TAX_ASSET_CONSUMPTION_RATIO] = self.tax_asset_consumption_ratio
        dict[COLUMN_NAME_FINANCIAL_POSITION_PER_CAPITA] = self.financial_position_per_capita
        dict[
            COLUMN_NAME_TAX_DISCRETIONARY_RESERVES_PERCENT_SOURCE_REVENUES] = self.tax_discretionary_reserves_percent_own_source_revenues
        dict[COLUMN_NAME_TAX_RESERVES_PERCENT_TAXATION] = self.tax_reserves_percent_taxation
        dict[COLUMN_NAME_TAX_RESERVE_PER_CAPITA] = self.tax_reserves_capita
        dict[COLUMN_NAME_TAX_DEBT_INT_PERCENT_OSR] = self.tax_debt_int_percent_osr
        dict[COLUMN_NAME_TAXR_DEBT_CHARGES_PERCENT_OSR] = self.tax_debt_charges_percent_osr
        dict[COLUMN_NAME_TOTAL_DEBT_OUTSTANDING_PER_CAPITA] = self.total_debt_outstanding_capita
        dict[COLUMN_NAME_TAX_DEBT_OUTSTANDING_PER_CAPITA] = self.tax_debt_outstanding_capita
        dict[COLUMN_NAME_DEBT_TO_RESERVE_RATIO] = self.debt_to_reserve_ratio
        dict[COLUMN_NAME_TAXES_RECEIVABLE_PERCENT_TAXES_LEVIED] = self.taxes_receivable_percent_taxes_levied
        dict[COLUMN_NAME_RATES_COVERAGE_RATIO] = self.rates_coverage_ratio
        dict[COLUMN_NAME_NET_FINANCIAL_LIABILITIES_RATIO] = self.net_financial_liabilities_ratio

        dict[COLUMN_NAME_SINGLE_DETACHED_DWELLINGS_PER_UNIT] = self.single_detached_dwellings_per_unit
        dict[COLUMN_NAME_MULTIPLES_DWELLING__3_OR_MORE] = self.multiples_dwelling_3_plus_per_unit
        dict[COLUMN_NAME_MULTIPLES_DWELLING_1_OR_2] = self.multiples_dwelling_1_or_2_per_unit
        dict[COLUMN_NAME_APARTMENT_UNITS_2_OR_MORE] = self.apartment_units_at_least_2_per_unit
        dict[COLUMN_NAME_APARTMENT_UNITS_LESS_THAN_2] = self.apartment_units_less_than_2_per_unit
        dict[COLUMN_NAME_NON_RESIDENTIAL_COMMERCIAL_PER_SQFT] = self.non_residential_commercial_per_sq_ft
        dict[COLUMN_NAME_NON_RESIDENTIAL_INDUSTRIAL_PER_SQFT] = self.non_residential_industrial_per_sq_ft
        dict[COLUMN_NAME_BUILDING_PERMIT_FEE] = self.building_permit_fee

        dict[COLUMN_NAME_TAX_RATIOS_MULTI_RESIDENTIAL] = self.multi_residential_tax_ratio
        dict[COLUMN_NAME_TAX_RATIOS_COMMERCIAL_RESIDUAL] = self.commercial_residual
        dict[COLUMN_NAME_TAX_RATIOS_INDUSTRIAL_RESIDUAL] = self.industrial_residual

        dict[COLUMN_NAME_NEW_MULTI_RESIDENTIAL] = self.new_multi_residential
        dict[COLUMN_NAME_COMMERCIAL_OFFICE] = self.commercial_office
        dict[COLUMN_NAME_COMMERCIAL_SHOPPING] = self.commercial_shopping
        dict[COLUMN_NAME_COMMERCIAL_PARKING] = self.commercial_parking
        dict[COLUMN_NAME_INDUSTRIAL_LARGE] = self.industrial_large

        dict[COLUMN_NAME_TOTAL_RESID] = self.total_resid
        dict[COLUMN_NAME_TOTAL_MULTI_RESID] = self.total_multi_resid
        dict[COLUMN_NAME_TOTAL_COMMERCIAL_RESIDUAL] = self.total_comm_residual
        dict[COLUMN_NAME_TOTAL_COMMERCIAL_OFFICE] = self.total_comm_office
        dict[COLUMN_NAME_TOTAL_COMMERCIAL_PARK_VAC] = self.total_commercial_park_vac
        dict[COLUMN_NAME_TOTAL_COMMERCIAL_SHOPPING] = self.total_comm_shopping
        dict[COLUMN_NAME_TOTAL_INDUSTRIAL_RESIDUAL] = self.total_ind_residual
        dict[COLUMN_NAME_TOTAL_INDUSTRIAL_LARGE] = self.total_ind_large

        dict[COLUMN_NAME_MUNICIPAL_RESID] = self.municipal_resid
        dict[COLUMN_NAME_MUNICIPAL_MULTI_RESID] = self.municipal_multi_resid
        dict[COLUMN_NAME_MUNICIPAL_COMM_RESIDUAL] = self.municipal_comm_residual
        dict[COLUMN_NAME_MUNICIPAL_COMM_OFFICE] = self.municipal_comm_office
        dict[COLUMN_NAME_MUNICIPAL_COMMERCIAL_PARK_VAC] = self.municipal_commercial_park_vac
        dict[COLUMN_NAME_MUNICIPAL_COMM_SHOPPING] = self.municipal_comm_shopping
        dict[COLUMN_NAME_MUNICIPAL_IND_RESIDUAL] = self.municipal_ind_residual
        dict[COLUMN_NAME_MUNICIPAL_IND_LARGE] = self.municipal_ind_large

        dict[COLUMN_NAME_EDUCATION_RESID] = self.education_resid
        dict[COLUMN_NAME_EDUCATION_MULTI_RESID] = self.education_multi_resid
        dict[COLUMN_NAME_EDUCATION_COMM_RESIDUAL] = self.education_comm_residual
        dict[COLUMN_NAME_EDUCATION_COMM_OFFICE] = self.education_comm_office
        dict[COLUMN_NAME_EDUCATION_COMMERCIAL_PARK_VAC] = self.education_commercial_park_vac
        dict[COLUMN_NAME_EDUCATION_COMM_SHOPPING] = self.education_comm_shopping
        dict[COLUMN_NAME_EDUCATION_IND_RESIDUAL] = self.education_ind_residual
        dict[COLUMN_NAME_EDUCATION_IND_LARGE] = self.education_ind_large

        dict[COLUMN_NAME_BUNGALOW] = self.bungalow
        dict[COLUMN_NAME_2_STOREY] = self.two_storey
        dict[COLUMN_NAME_EXECUTIVE] = self.executive
        dict[COLUMN_NAME_MULTI_RES_WALK_UP] = self.multi_res_walk_up
        dict[COLUMN_NAME_MULTI_RES_HIGH_RISE] = self.multi_res_high_rise
        dict[COLUMN_NAME_TAX_SHOPPING] = self.shopping
        dict[COLUMN_NAME_TAX_HOTEL] = self.hotel
        dict[COLUMN_NAME_TAX_MOTEL] = self.motel
        dict[COLUMN_NAME_TAX_OFFICE] = self.office
        dict[COLUMN_NAME_TAX_IND_STANDARD] = self.industrial_standard
        dict[COLUMN_NAME_TAX_IND_LARGE] = self.industrial_large
        dict[COLUMN_NAME_TAX_IND_VACANT] = self.industrial_vacant

        dict[COLUMN_NAME_RESIDENTIAL_200_M3] = self.residential_200_m3_5_8_inch
        dict[COLUMN_NAME_COMMERCIAL_10K_M3] = self.commercial_10000_m3_2_inch
        dict[COLUMN_NAME_INDUSTRIAL_30K_M3] = self.industrial_30000_m3_3_inch
        dict[COLUMN_NAME_INDUSTRIAL_100K_M3] = self.industrial_100000_m3_4_inch
        dict[COLUMN_NAME_INDUSTRIAL_500K_M3] = self.industrial_500000_m3_6_inch
        dict[COLUMN_NAME_WATER_ASSET_CONSUMPTION] = self.water_asset_consumption
        dict[COLUMN_NAME_WW_ASSET_CONSUMPTION] = self.ww_asset_consumption
        dict[COLUMN_NAME_WATER_RES_PERCENT_OSR] = self.water_res_as_percent_osr
        dict[COLUMN_NAME_WW_RES_PERCENT_OSR] = self.ww_res_percent_osr
        dict[COLUMN_NAME_WATER_RES_PERCENT_ACUM_AMORT] = self.water_res_as_percent_acum_amort
        dict[COLUMN_NAME_WW_RES_PERCENT_ACUM_AMORT] = self.ww_res_percent_acum_amort
        dict[COLUMN_NAME_WATER_DEBT_INTEREST_COVERAGE] = self.water_debt_interest_coverage
        dict[COLUMN_NAME_WW_DEBT_INTEREST_COVERAGE] = self.ww_debt_interest_coverage
        dict[COLUMN_NAME_WATER_NET_LIN_LIAB] = self.water_net_lin_liab
        dict[COLUMN_NAME_WW_NET_LIN_LIAB] = self.ww_net_lin_liab
        dict[COLUMN_NAME_EST_AVG_HOUSEHOLD_INCOME] = self.est_avg_household_income
        dict[COLUMN_NAME_RESIDENTIAL_WATER_SEWER_COSTS] = self.residential_water_sewer_costs
        dict[COLUMN_NAME_AVG_RESIDENTIAL_TAXES] = self.average_residential_taxes
        dict[COLUMN_NAME_PROPERTY_TAXES_PERCENT_HOUSEHOLD_INCOME] = self.property_taxes_percent_household_income
        dict[COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN] = self.total_municipal_tax_burden
        dict[
            COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN_PERCENT_HOUSEHOLD_INCOME] = self.total_municipal_burden_percent_household_income

        dict[COLUMN_NAME_FIRE] = self.fire
        dict[COLUMN_NAME_ROADS_PAVED] = self.roads_paved
        dict[COLUMN_NAME_BRIDGES_CULVERTS] = self.bridges_and_culverts
        dict[COLUMN_NAME_TRAFFIC] = self.traffic
        dict[COLUMN_NAME_WINTER_ROADS] = self.winter_roads
        dict[COLUMN_NAME_WINTER_SIDEWALKS] = self.winter_sidewalks
        dict[COLUMN_NAME_TRANSIT] = self.transit
        dict[COLUMN_NAME_PARKING] = self.parking
        dict[COLUMN_NAME_WASTE_COLLECTION] = self.waste_collection
        dict[COLUMN_NAME_WASTE_DISPOSAL] = self.waste_disposal
        dict[COLUMN_NAME_STORM] = self.storm
        dict[COLUMN_NAME_RECYCLING] = self.recycling
        dict[COLUMN_NAME_PUBLIC_HEALTH] = self.public_health
        dict[COLUMN_NAME_EMERGENCY_MEASURES] = self.emergency_measures
        dict[COLUMN_NAME_GENERAL_ASSISTANCE] = self.general_assistance
        dict[COLUMN_NAME_ASSISTANCE_AGED] = self.assistance_to_the_aged
        dict[COLUMN_NAME_POA] = self.poa
        dict[COLUMN_NAME_CHILD_CARE] = self.child_care
        dict[COLUMN_NAME_SOCIAL_HOUSING] = self.social_housing
        dict[COLUMN_NAME_PARKS] = self.parks
        dict[COLUMN_NAME_RECREATION_PROGRAMS] = self.recreation_programs
        dict[COLUMN_NAME_REC_FAC_GOLF] = self.rec_fac_golf
        dict[COLUMN_NAME_REC_FACILITIES_OTHER] = self.rec_facilities_other
        dict[COLUMN_NAME_LIBRARY] = self.library
        dict[COLUMN_NAME_MUSEUMS] = self.museums
        dict[COLUMN_NAME_CULTURAL] = self.cultural
        dict[COLUMN_NAME_PLANNING] = self.planning
        dict[COLUMN_NAME_COMM_IND] = self.comm_and_ind
        dict[COLUMN_NAME_GENERAL_GOVERNMENT] = self.general_government
        dict[COLUMN_NAME_CONSERVATION_AUTHORITY] = self.conservation_authority
        dict[COLUMN_NAME_AMBULANCE] = self.ambulance
        dict[COLUMN_NAME_CEMETERIES] = self.cemeteries

    def load(self, dict):
        self.name = dict.get(COLUMN_NAME_MUNICIPALITY)
        self.year = dict.get(COLUMN_NAME_YEAR)
        self.yearPlusName = str(self.year) + self.name

        #        self.region_county_district = dict.get('')
        #        self.study_location = dict.get('')
        #        self.tier = dict.get('')
        #        self.population_bands = dict.get('')

        self.population_density_per_km2 = dict.get(COLUMN_NAME_POPULATION_DENSITY)
        self.population = dict.get(COLUMN_NAME_POPULATION)
        self.land_area_km2 = dict.get(COLUMN_NAME_LAND_AREA)

        self.population_increase_percent = dict.get(COLUMN_NAME_POPULATION_INCREASE)
        self.building_construction_value = dict.get(COLUMN_NAME_BUILDING_CONSTRUCTION_VALUE)
        self.building_construction_per_capita_value = dict.get(COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA)
        self.estimated_average_household_income = dict.get(COLUMN_NAME_ESTIMATED_AVG_HOUSEHOLD_INCOME)
        self.weighted_median_dwelling_value = dict.get(COLUMN_NAME_WEIGHTED_MEDIAN_VAL_DWELLING)
        self.unweighted_assessment_per_capita = dict.get(COLUMN_NAME_UNWEIGHTED_ASSESSMENT_PER_CAPITA)
        self.weighted_assessment_per_capita = dict.get(COLUMN_NAME_WEIGHTED_ASSESSMENT_PER_CAPITA)
        self.total_unweighted_assessment = dict.get(COLUMN_NAME_TOTAL_UNWEIGHTED_ASSESSMENT)
        self.total_weighted_assessment = dict.get(COLUMN_NAME_TOTAL_WEIGHTED_ASSESSMENT)

        self.residential = dict.get(COLUMN_NAME_RESIDENTIAL)
        self.multi_residential = dict.get(COLUMN_NAME_MULTI_RESIDENTIAL)
        self.commercial = dict.get(COLUMN_NAME_COMMERCIAL)
        self.industrial = dict.get(COLUMN_NAME_INDUSTRIAL)
        self.pipelines = dict.get(COLUMN_NAME_PIPELINES)
        self.farmlands = dict.get(COLUMN_NAME_FARMLANDS)
        self.forests = dict.get(COLUMN_NAME_FORESTS)

        self.total_net_levy_upper_and_lower_tiers = dict.get(COLUMN_NAME_TOTAL_NET_LEVY)
        self.levy_per_capita = dict.get(COLUMN_NAME_LEVY_PER_CAPITA)
        self.upper_tier_levy = dict.get(COLUMN_NAME_UPPER_TIER_LEVY)
        self.upper_tier_levy_per_capita = dict.get(COLUMN_NAME_UPPER_TIER_LEVY_PER_CAPITA)
        self.lower_tier_levy = dict.get(COLUMN_NAME_LOWER_TIER_LEVY)
        self.lower_tier_levy_per_capita = dict.get(COLUMN_NAME_LOWER_TIER_LEVY_PER_CAPITA)
        self.tax_asset_consumption_ratio = dict.get(COLUMN_NAME_TAX_ASSET_CONSUMPTION_RATIO)
        self.financial_position_per_capita = dict.get(COLUMN_NAME_FINANCIAL_POSITION_PER_CAPITA)
        self.tax_discretionary_reserves_percent_own_source_revenues = dict.get(
            COLUMN_NAME_TAX_DISCRETIONARY_RESERVES_PERCENT_SOURCE_REVENUES)
        self.tax_reserves_percent_taxation = dict.get(COLUMN_NAME_TAX_RESERVES_PERCENT_TAXATION)
        self.tax_reserves_capita = dict.get(COLUMN_NAME_TAX_RESERVE_PER_CAPITA)
        self.tax_debt_int_percent_osr = dict.get(COLUMN_NAME_TAX_DEBT_INT_PERCENT_OSR)
        self.tax_debt_charges_percent_osr = dict.get(COLUMN_NAME_TAXR_DEBT_CHARGES_PERCENT_OSR)
        self.total_debt_outstanding_capita = dict.get(COLUMN_NAME_TOTAL_DEBT_OUTSTANDING_PER_CAPITA)
        self.tax_debt_outstanding_capita = dict.get(COLUMN_NAME_TAX_DEBT_OUTSTANDING_PER_CAPITA)
        self.debt_to_reserve_ratio = dict.get(COLUMN_NAME_DEBT_TO_RESERVE_RATIO)
        self.taxes_receivable_percent_taxes_levied = dict.get(COLUMN_NAME_TAXES_RECEIVABLE_PERCENT_TAXES_LEVIED)
        self.rates_coverage_ratio = dict.get(COLUMN_NAME_RATES_COVERAGE_RATIO)
        self.net_financial_liabilities_ratio = dict.get(COLUMN_NAME_NET_FINANCIAL_LIABILITIES_RATIO)

        self.single_detached_dwellings_per_unit = dict.get(COLUMN_NAME_SINGLE_DETACHED_DWELLINGS_PER_UNIT)
        self.multiples_dwelling_3_plus_per_unit = dict.get(COLUMN_NAME_MULTIPLES_DWELLING__3_OR_MORE)
        self.multiples_dwelling_1_or_2_per_unit = dict.get(COLUMN_NAME_MULTIPLES_DWELLING_1_OR_2)
        self.apartment_units_at_least_2_per_unit = dict.get(COLUMN_NAME_APARTMENT_UNITS_2_OR_MORE)
        self.apartment_units_less_than_2_per_unit = dict.get(COLUMN_NAME_APARTMENT_UNITS_LESS_THAN_2)
        self.non_residential_commercial_per_sq_ft = dict.get(COLUMN_NAME_NON_RESIDENTIAL_COMMERCIAL_PER_SQFT)
        self.non_residential_industrial_per_sq_ft = dict.get(COLUMN_NAME_NON_RESIDENTIAL_INDUSTRIAL_PER_SQFT)
        self.building_permit_fee = dict.get(COLUMN_NAME_BUILDING_PERMIT_FEE)

        self.multi_residential_tax_ratio = dict.get(COLUMN_NAME_TAX_RATIOS_MULTI_RESIDENTIAL)
        self.commercial_residual = dict.get(COLUMN_NAME_TAX_RATIOS_COMMERCIAL_RESIDUAL)
        self.industrial_residual = dict.get(COLUMN_NAME_TAX_RATIOS_INDUSTRIAL_RESIDUAL)

        self.new_multi_residential = dict.get(COLUMN_NAME_NEW_MULTI_RESIDENTIAL)
        self.commercial_office = dict.get(COLUMN_NAME_COMMERCIAL_OFFICE)
        self.commercial_shopping = dict.get(COLUMN_NAME_COMMERCIAL_SHOPPING)
        self.commercial_parking = dict.get(COLUMN_NAME_COMMERCIAL_PARKING)
        self.industrial_large = dict.get(COLUMN_NAME_INDUSTRIAL_LARGE)

        self.total_resid = dict.get(COLUMN_NAME_TOTAL_RESID)
        self.total_multi_resid = dict.get(COLUMN_NAME_TOTAL_MULTI_RESID)
        self.total_comm_residual = dict.get(COLUMN_NAME_TOTAL_COMMERCIAL_RESIDUAL)
        self.total_comm_office = dict.get(COLUMN_NAME_TOTAL_COMMERCIAL_OFFICE)
        self.total_commercial_park_vac = dict.get(COLUMN_NAME_TOTAL_COMMERCIAL_PARK_VAC)
        self.total_comm_shopping = dict.get(COLUMN_NAME_TOTAL_COMMERCIAL_SHOPPING)
        self.total_ind_residual = dict.get(COLUMN_NAME_TOTAL_INDUSTRIAL_RESIDUAL)
        self.total_ind_large = dict.get(COLUMN_NAME_TOTAL_INDUSTRIAL_LARGE)

        self.municipal_resid = dict.get(COLUMN_NAME_MUNICIPAL_RESID)
        self.municipal_multi_resid = dict.get(COLUMN_NAME_MUNICIPAL_MULTI_RESID)
        self.municipal_comm_residual = dict.get(COLUMN_NAME_MUNICIPAL_COMM_RESIDUAL)
        self.municipal_comm_office = dict.get(COLUMN_NAME_MUNICIPAL_COMM_OFFICE)
        self.municipal_commercial_park_vac = dict.get(COLUMN_NAME_MUNICIPAL_COMMERCIAL_PARK_VAC)
        self.municipal_comm_shopping = dict.get(COLUMN_NAME_MUNICIPAL_COMM_SHOPPING)
        self.municipal_ind_residual = dict.get(COLUMN_NAME_MUNICIPAL_IND_RESIDUAL)
        self.municipal_ind_large = dict.get(COLUMN_NAME_MUNICIPAL_IND_LARGE)

        self.education_resid = dict.get(COLUMN_NAME_EDUCATION_RESID)
        self.education_multi_resid = dict.get(COLUMN_NAME_EDUCATION_MULTI_RESID)
        self.education_comm_residual = dict.get(COLUMN_NAME_EDUCATION_COMM_RESIDUAL)
        self.education_comm_office = dict.get(COLUMN_NAME_EDUCATION_COMM_OFFICE)
        self.education_commercial_park_vac = dict.get(COLUMN_NAME_EDUCATION_COMMERCIAL_PARK_VAC)
        self.education_comm_shopping = dict.get(COLUMN_NAME_EDUCATION_COMM_SHOPPING)
        self.education_ind_residual = dict.get(COLUMN_NAME_EDUCATION_IND_RESIDUAL)
        self.education_ind_large = dict.get(COLUMN_NAME_EDUCATION_IND_LARGE)

        self.bungalow = dict.get(COLUMN_NAME_BUNGALOW)
        self.two_storey = dict.get(COLUMN_NAME_2_STOREY)
        self.executive = dict.get(COLUMN_NAME_EXECUTIVE)
        self.multi_res_walk_up = dict.get(COLUMN_NAME_MULTI_RES_WALK_UP)
        self.multi_res_high_rise = dict.get(COLUMN_NAME_MULTI_RES_HIGH_RISE)
        self.shopping = dict.get(COLUMN_NAME_TAX_SHOPPING)
        self.hotel = dict.get(COLUMN_NAME_TAX_HOTEL)
        self.motel = dict.get(COLUMN_NAME_TAX_MOTEL)
        self.office = dict.get(COLUMN_NAME_TAX_OFFICE)
        self.industrial_standard = dict.get(COLUMN_NAME_TAX_IND_STANDARD)
        self.industrial_large = dict.get(COLUMN_NAME_TAX_IND_LARGE)
        self.industrial_vacant = dict.get(COLUMN_NAME_TAX_IND_VACANT)

        self.residential_200_m3_5_8_inch = dict.get(COLUMN_NAME_RESIDENTIAL_200_M3)
        self.commercial_10000_m3_2_inch = dict.get(COLUMN_NAME_COMMERCIAL_10K_M3)
        self.industrial_30000_m3_3_inch = dict.get(COLUMN_NAME_INDUSTRIAL_30K_M3)
        self.industrial_100000_m3_4_inch = dict.get(COLUMN_NAME_INDUSTRIAL_100K_M3)
        self.industrial_500000_m3_6_inch = dict.get(COLUMN_NAME_INDUSTRIAL_500K_M3)
        self.water_asset_consumption = dict.get(COLUMN_NAME_WATER_ASSET_CONSUMPTION)
        self.ww_asset_consumption = dict.get(COLUMN_NAME_WW_ASSET_CONSUMPTION)
        self.water_res_as_percent_osr = dict.get(COLUMN_NAME_WATER_RES_PERCENT_OSR)
        self.ww_res_percent_osr = dict.get(COLUMN_NAME_WW_RES_PERCENT_OSR)
        self.water_res_as_percent_acum_amort = dict.get(COLUMN_NAME_WATER_RES_PERCENT_ACUM_AMORT)
        self.ww_res_percent_acum_amort = dict.get(COLUMN_NAME_WW_RES_PERCENT_ACUM_AMORT)
        self.water_debt_interest_coverage = dict.get(COLUMN_NAME_WATER_DEBT_INTEREST_COVERAGE)
        self.ww_debt_interest_coverage = dict.get(COLUMN_NAME_WW_DEBT_INTEREST_COVERAGE)
        self.water_net_lin_liab = dict.get(COLUMN_NAME_WATER_NET_LIN_LIAB)
        self.ww_net_lin_liab = dict.get(COLUMN_NAME_WW_NET_LIN_LIAB)
        self.est_avg_household_income = dict.get(COLUMN_NAME_EST_AVG_HOUSEHOLD_INCOME)
        self.residential_water_sewer_costs = dict.get(COLUMN_NAME_RESIDENTIAL_WATER_SEWER_COSTS)
        self.average_residential_taxes = dict.get(COLUMN_NAME_AVG_RESIDENTIAL_TAXES)
        self.property_taxes_percent_household_income = dict.get(COLUMN_NAME_PROPERTY_TAXES_PERCENT_HOUSEHOLD_INCOME)
        self.total_municipal_tax_burden = dict.get(COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN)
        self.total_municipal_burden_percent_household_income = dict.get(
            COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN_PERCENT_HOUSEHOLD_INCOME)

        self.fire = dict.get(COLUMN_NAME_FIRE)
        self.roads_paved = dict.get(COLUMN_NAME_ROADS_PAVED)
        self.bridges_and_culverts = dict.get(COLUMN_NAME_BRIDGES_CULVERTS)
        self.traffic = dict.get(COLUMN_NAME_TRAFFIC)
        self.winter_roads = dict.get(COLUMN_NAME_WINTER_ROADS)
        self.winter_sidewalks = dict.get(COLUMN_NAME_WINTER_SIDEWALKS)
        self.transit = dict.get(COLUMN_NAME_TRANSIT)
        self.parking = dict.get(COLUMN_NAME_PARKING)
        self.waste_collection = dict.get(COLUMN_NAME_WASTE_COLLECTION)
        self.waste_disposal = dict.get(COLUMN_NAME_WASTE_DISPOSAL)
        self.storm = dict.get(COLUMN_NAME_STORM)
        self.recycling = dict.get(COLUMN_NAME_RECYCLING)
        self.public_health = dict.get(COLUMN_NAME_PUBLIC_HEALTH)
        self.emergency_measures = dict.get(COLUMN_NAME_EMERGENCY_MEASURES)
        self.general_assistance = dict.get(COLUMN_NAME_GENERAL_ASSISTANCE)
        self.assistance_to_the_aged = dict.get(COLUMN_NAME_ASSISTANCE_AGED)
        self.poa = dict.get(COLUMN_NAME_POA)
        self.child_care = dict.get(COLUMN_NAME_CHILD_CARE)
        self.social_housing = dict.get(COLUMN_NAME_SOCIAL_HOUSING)
        self.parks = dict.get(COLUMN_NAME_PARKS)
        self.recreation_programs = dict.get(COLUMN_NAME_RECREATION_PROGRAMS)
        self.rec_fac_golf = dict.get(COLUMN_NAME_REC_FAC_GOLF)
        self.rec_facilities_other = dict.get(COLUMN_NAME_REC_FACILITIES_OTHER)
        self.library = dict.get(COLUMN_NAME_LIBRARY)
        self.museums = dict.get(COLUMN_NAME_MUSEUMS)
        self.cultural = dict.get(COLUMN_NAME_CULTURAL)
        self.planning = dict.get(COLUMN_NAME_PLANNING)
        self.comm_and_ind = dict.get(COLUMN_NAME_COMM_IND)
        self.general_government = dict.get(COLUMN_NAME_GENERAL_GOVERNMENT)
        self.conservation_authority = dict.get(COLUMN_NAME_CONSERVATION_AUTHORITY)
        self.ambulance = dict.get(COLUMN_NAME_AMBULANCE)
        self.cemeteries = dict.get(COLUMN_NAME_CEMETERIES)

    def get_column_value(self, column_name):
        if column_name == COLUMN_NAME_POPULATION:
            return self.population
        elif column_name == COLUMN_NAME_BUILDING_CONSTRUCTION_VALUE:
            return self.building_construction_value
        elif column_name == COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA_WITH_YEAR_PREFIX or column_name == COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA:
            return self.building_construction_per_capita_value
        elif column_name == COLUMN_NAME_ESTIMATED_AVG_HOUSEHOLD_INCOME:
            return self.estimated_average_household_income
        else:
            return None

