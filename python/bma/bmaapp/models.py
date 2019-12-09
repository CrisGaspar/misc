from django.db import models

default_decimal_places = 15
default_max_digits_year = 4
default_max_digits = 30
default_max_string_length = 100

COLUMN_NAME_MUNICIPALITY = 'Municipality'
COLUMN_NAME_YEAR = 'Year'

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
COLUMN_NAME_LANDFILL = 'Landfill'
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
COLUMN_NAME_MULTIPLES_DWELLING__3_OR_MORE = 'Multiples Dwelling 3+ bed. per unit'
COLUMN_NAME_MULTIPLES_DWELLING_1_OR_2 = 'Multiples Dwelling 1&2 bed. per unit'
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
COLUMN_NAME_AGRICULTURE_AND_REFORESTATION = 'Agriculture and reforestation'

excel_column_name_to_db_column_name = {
    COLUMN_NAME_MUNICIPALITY: 'name',
    COLUMN_NAME_YEAR: 'year',

    COLUMN_NAME_POPULATION_DENSITY: 'population_density_per_km2',
    COLUMN_NAME_POPULATION: 'population',
    COLUMN_NAME_LAND_AREA: 'land_area_km2',

    COLUMN_NAME_POPULATION_INCREASE: 'population_increase_percent',
    COLUMN_NAME_BUILDING_CONSTRUCTION_VALUE: 'building_construction_value',
    COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA: 'building_construction_per_capita_value',
    COLUMN_NAME_ESTIMATED_AVG_HOUSEHOLD_INCOME: 'estimated_average_household_income',
    COLUMN_NAME_WEIGHTED_MEDIAN_VAL_DWELLING: 'weighted_median_dwelling_value',
    COLUMN_NAME_UNWEIGHTED_ASSESSMENT_PER_CAPITA: 'unweighted_assessment_per_capita',
    COLUMN_NAME_WEIGHTED_ASSESSMENT_PER_CAPITA: 'weighted_assessment_per_capita',
    COLUMN_NAME_TOTAL_UNWEIGHTED_ASSESSMENT: 'total_unweighted_assessment',
    COLUMN_NAME_TOTAL_WEIGHTED_ASSESSMENT: 'total_weighted_assessment',

    COLUMN_NAME_RESIDENTIAL: 'residential',
    COLUMN_NAME_MULTI_RESIDENTIAL: 'multi_residential',
    COLUMN_NAME_COMMERCIAL: 'commercial',
    COLUMN_NAME_INDUSTRIAL: 'industrial',
    COLUMN_NAME_PIPELINES: 'pipelines',
    COLUMN_NAME_FARMLANDS: 'farmlands',
    COLUMN_NAME_FORESTS: 'forests',
    COLUMN_NAME_LANDFILL: 'landfill',

    COLUMN_NAME_TOTAL_NET_LEVY: 'total_net_levy_upper_and_lower_tiers',
    COLUMN_NAME_LEVY_PER_CAPITA: 'levy_per_capita',
    COLUMN_NAME_UPPER_TIER_LEVY: 'upper_tier_levy',
    COLUMN_NAME_UPPER_TIER_LEVY_PER_CAPITA: 'upper_tier_levy_per_capita',
    COLUMN_NAME_LOWER_TIER_LEVY: 'lower_tier_levy',
    COLUMN_NAME_LOWER_TIER_LEVY_PER_CAPITA: 'lower_tier_levy_per_capita',
    COLUMN_NAME_TAX_ASSET_CONSUMPTION_RATIO: 'tax_asset_consumption_ratio',
    COLUMN_NAME_FINANCIAL_POSITION_PER_CAPITA: 'financial_position_per_capita',
    COLUMN_NAME_TAX_DISCRETIONARY_RESERVES_PERCENT_SOURCE_REVENUES: 'tax_discretionary_reserves_percent_own_source_revenues',
    COLUMN_NAME_TAX_RESERVES_PERCENT_TAXATION: 'tax_reserves_percent_taxation',
    COLUMN_NAME_TAX_RESERVE_PER_CAPITA: 'tax_reserves_capita',
    COLUMN_NAME_TAX_DEBT_INT_PERCENT_OSR: 'tax_debt_int_percent_osr',
    COLUMN_NAME_TAXR_DEBT_CHARGES_PERCENT_OSR: 'tax_debt_charges_percent_osr',
    COLUMN_NAME_TOTAL_DEBT_OUTSTANDING_PER_CAPITA: 'total_debt_outstanding_capita',
    COLUMN_NAME_TAX_DEBT_OUTSTANDING_PER_CAPITA: 'tax_debt_outstanding_capita',
    COLUMN_NAME_DEBT_TO_RESERVE_RATIO: 'debt_to_reserve_ratio',
    COLUMN_NAME_TAXES_RECEIVABLE_PERCENT_TAXES_LEVIED: 'taxes_receivable_percent_taxes_levied',
    COLUMN_NAME_RATES_COVERAGE_RATIO: 'rates_coverage_ratio',
    COLUMN_NAME_NET_FINANCIAL_LIABILITIES_RATIO: 'net_financial_liabilities_ratio',

    COLUMN_NAME_SINGLE_DETACHED_DWELLINGS_PER_UNIT: 'single_detached_dwellings_per_unit',
    COLUMN_NAME_MULTIPLES_DWELLING__3_OR_MORE: 'multiples_dwelling_3_plus_per_unit',
    COLUMN_NAME_MULTIPLES_DWELLING_1_OR_2: 'multiples_dwelling_1_or_2_per_unit',
    COLUMN_NAME_APARTMENT_UNITS_2_OR_MORE: 'apartment_units_at_least_2_per_unit',
    COLUMN_NAME_APARTMENT_UNITS_LESS_THAN_2: 'apartment_units_less_than_2_per_unit',
    COLUMN_NAME_NON_RESIDENTIAL_COMMERCIAL_PER_SQFT: 'non_residential_commercial_per_sq_ft',
    COLUMN_NAME_NON_RESIDENTIAL_INDUSTRIAL_PER_SQFT: 'non_residential_industrial_per_sq_ft',
    COLUMN_NAME_BUILDING_PERMIT_FEE: 'building_permit_fee',

    COLUMN_NAME_TAX_RATIOS_MULTI_RESIDENTIAL: 'multi_residential_tax_ratio',
    COLUMN_NAME_TAX_RATIOS_COMMERCIAL_RESIDUAL: 'commercial_residual',
    COLUMN_NAME_TAX_RATIOS_INDUSTRIAL_RESIDUAL: 'industrial_residual',

    COLUMN_NAME_NEW_MULTI_RESIDENTIAL: 'new_multi_residential',
    COLUMN_NAME_COMMERCIAL_OFFICE: 'commercial_office',
    COLUMN_NAME_COMMERCIAL_SHOPPING: 'commercial_shopping',
    COLUMN_NAME_COMMERCIAL_PARKING: 'commercial_parking',
    COLUMN_NAME_INDUSTRIAL_LARGE: 'industrial_large',

    COLUMN_NAME_TOTAL_RESID: 'total_resid',
    COLUMN_NAME_TOTAL_MULTI_RESID: 'total_multi_resid',
    COLUMN_NAME_TOTAL_COMMERCIAL_RESIDUAL: 'total_comm_residual',
    COLUMN_NAME_TOTAL_COMMERCIAL_OFFICE: 'total_comm_office',
    COLUMN_NAME_TOTAL_COMMERCIAL_PARK_VAC: 'total_commercial_park_vac',
    COLUMN_NAME_TOTAL_COMMERCIAL_SHOPPING: 'total_comm_shopping',
    COLUMN_NAME_TOTAL_INDUSTRIAL_RESIDUAL: 'total_ind_residual',
    COLUMN_NAME_TOTAL_INDUSTRIAL_LARGE: 'total_ind_large',

    COLUMN_NAME_MUNICIPAL_RESID: 'municipal_resid',
    COLUMN_NAME_MUNICIPAL_MULTI_RESID: 'municipal_multi_resid',
    COLUMN_NAME_MUNICIPAL_COMM_RESIDUAL: 'municipal_comm_residual',
    COLUMN_NAME_MUNICIPAL_COMM_OFFICE: 'municipal_comm_office',
    COLUMN_NAME_MUNICIPAL_COMMERCIAL_PARK_VAC: 'municipal_commercial_park_vac',
    COLUMN_NAME_MUNICIPAL_COMM_SHOPPING: 'municipal_comm_shopping',
    COLUMN_NAME_MUNICIPAL_IND_RESIDUAL: 'municipal_ind_residual',
    COLUMN_NAME_MUNICIPAL_IND_LARGE: 'municipal_ind_large',

    COLUMN_NAME_EDUCATION_RESID: 'education_resid',
    COLUMN_NAME_EDUCATION_MULTI_RESID: 'education_multi_resid',
    COLUMN_NAME_EDUCATION_COMM_RESIDUAL: 'education_comm_residual',
    COLUMN_NAME_EDUCATION_COMM_OFFICE: 'education_comm_office',
    COLUMN_NAME_EDUCATION_COMMERCIAL_PARK_VAC: 'education_commercial_park_vac',
    COLUMN_NAME_EDUCATION_COMM_SHOPPING: 'education_comm_shopping',
    COLUMN_NAME_EDUCATION_IND_RESIDUAL: 'education_ind_residual',
    COLUMN_NAME_EDUCATION_IND_LARGE: 'education_ind_large',

    COLUMN_NAME_BUNGALOW: 'bungalow',
    COLUMN_NAME_2_STOREY: 'two_storey',
    COLUMN_NAME_EXECUTIVE: 'executive',
    COLUMN_NAME_MULTI_RES_WALK_UP: 'multi_res_walk_up',
    COLUMN_NAME_MULTI_RES_HIGH_RISE: 'multi_res_high_rise',
    COLUMN_NAME_TAX_SHOPPING: 'shopping',
    COLUMN_NAME_TAX_HOTEL: 'hotel',
    COLUMN_NAME_TAX_MOTEL: 'motel',
    COLUMN_NAME_TAX_OFFICE: 'office',
    COLUMN_NAME_TAX_IND_STANDARD: 'industrial_standard',
    COLUMN_NAME_TAX_IND_LARGE: 'industrial_large',
    COLUMN_NAME_TAX_IND_VACANT: 'industrial_vacant',

    COLUMN_NAME_RESIDENTIAL_200_M3: 'residential_200_m3_5_8_inch',
    COLUMN_NAME_COMMERCIAL_10K_M3: 'commercial_10000_m3_2_inch',
    COLUMN_NAME_INDUSTRIAL_30K_M3: 'industrial_30000_m3_3_inch',
    COLUMN_NAME_INDUSTRIAL_100K_M3: 'industrial_100000_m3_4_inch',
    COLUMN_NAME_INDUSTRIAL_500K_M3: 'industrial_500000_m3_6_inch',
    COLUMN_NAME_WATER_ASSET_CONSUMPTION: 'water_asset_consumption',
    COLUMN_NAME_WW_ASSET_CONSUMPTION: 'ww_asset_consumption',
    COLUMN_NAME_WATER_RES_PERCENT_OSR: 'water_res_as_percent_osr',
    COLUMN_NAME_WW_RES_PERCENT_OSR: 'ww_res_percent_osr',
    COLUMN_NAME_WATER_RES_PERCENT_ACUM_AMORT: 'water_res_as_percent_acum_amort',
    COLUMN_NAME_WW_RES_PERCENT_ACUM_AMORT: 'ww_res_percent_acum_amort',
    COLUMN_NAME_WATER_DEBT_INTEREST_COVERAGE: 'water_debt_interest_coverage',
    COLUMN_NAME_WW_DEBT_INTEREST_COVERAGE: 'ww_debt_interest_coverage',
    COLUMN_NAME_WATER_NET_LIN_LIAB: 'water_net_lin_liab',
    COLUMN_NAME_WW_NET_LIN_LIAB: 'ww_net_lin_liab',
    COLUMN_NAME_EST_AVG_HOUSEHOLD_INCOME: 'est_avg_household_income',
    COLUMN_NAME_RESIDENTIAL_WATER_SEWER_COSTS: 'residential_water_sewer_costs',
    COLUMN_NAME_AVG_RESIDENTIAL_TAXES: 'average_residential_taxes',
    COLUMN_NAME_PROPERTY_TAXES_PERCENT_HOUSEHOLD_INCOME: 'property_taxes_percent_household_income',
    COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN: 'total_municipal_tax_burden',
    COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN_PERCENT_HOUSEHOLD_INCOME: 'total_municipal_burden_percent_household_income',

    COLUMN_NAME_FIRE: 'fire',
    COLUMN_NAME_ROADS_PAVED: 'roads_paved',
    COLUMN_NAME_BRIDGES_CULVERTS: 'bridges_and_culverts',
    COLUMN_NAME_TRAFFIC: 'traffic',
    COLUMN_NAME_WINTER_ROADS: 'winter_roads',
    COLUMN_NAME_WINTER_SIDEWALKS: 'winter_sidewalks',
    COLUMN_NAME_TRANSIT: 'transit',
    COLUMN_NAME_PARKING: 'parking',
    COLUMN_NAME_WASTE_COLLECTION: 'waste_collection',
    COLUMN_NAME_WASTE_DISPOSAL: 'waste_disposal',
    COLUMN_NAME_STORM: 'storm',
    COLUMN_NAME_RECYCLING: 'recycling',
    COLUMN_NAME_PUBLIC_HEALTH: 'public_health',
    COLUMN_NAME_EMERGENCY_MEASURES: 'emergency_measures',
    COLUMN_NAME_GENERAL_ASSISTANCE: 'general_assistance',
    COLUMN_NAME_ASSISTANCE_AGED: 'assistance_to_the_aged',
    COLUMN_NAME_POA: 'poa',
    COLUMN_NAME_CHILD_CARE: 'child_care',
    COLUMN_NAME_SOCIAL_HOUSING: 'social_housing',
    COLUMN_NAME_PARKS: 'parks',
    COLUMN_NAME_RECREATION_PROGRAMS: 'recreation_programs',
    COLUMN_NAME_REC_FAC_GOLF: 'rec_fac_golf',
    COLUMN_NAME_REC_FACILITIES_OTHER: 'rec_facilities_other',
    COLUMN_NAME_LIBRARY: 'library',
    COLUMN_NAME_MUSEUMS: 'museums',
    COLUMN_NAME_CULTURAL: 'cultural',
    COLUMN_NAME_PLANNING: 'planning',
    COLUMN_NAME_COMM_IND: 'comm_and_ind',
    COLUMN_NAME_GENERAL_GOVERNMENT: 'general_government',
    COLUMN_NAME_CONSERVATION_AUTHORITY: 'conservation_authority',
    COLUMN_NAME_AMBULANCE: 'ambulance',
    COLUMN_NAME_CEMETERIES: 'cemeteries',
    COLUMN_NAME_AGRICULTURE_AND_REFORESTATION: 'agriculture_and_reforestation'
}


# create your models here.

class EndUser(models.Model):
    userid = models.CharField(max_length=default_max_string_length, null=True)
    municipality_name = models.CharField(max_length=default_max_string_length, null=True)


class Municipality(models.Model):
    name = models.CharField(max_length=default_max_string_length, null=True)
    study_location = models.CharField(max_length=default_max_string_length, null=True)
    population_band = models.CharField(max_length=default_max_string_length, null=True)

class MunicipalityGroup(models.Model):
    year = models.IntegerField()
    group_name = models.CharField(max_length=default_max_string_length, null=True)
    municipality_name = models.CharField(max_length=default_max_string_length, null=True)


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
    landfill = models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)

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
    agriculture_and_reforestation =  models.DecimalField(max_digits=default_max_digits, decimal_places=default_decimal_places, null=True)

    def store(self, dict):
        dict.clear()

        for excel_column_name, db_column_name in excel_column_name_to_db_column_name.items():
            dict[excel_column_name] = getattr(self, db_column_name)

    def load(self, dict):
        for excel_column_name, value in dict.items():
            db_column_name =  excel_column_name_to_db_column_name.get(excel_column_name)

            if db_column_name is None:
                print("Load: Looking for excel_column_name={} new_value={} but it's not one of the column names we expect".format(excel_column_name, value, db_column_name))
            else:
                setattr(self, db_column_name, value)

        self.yearPlusName = str(self.year) + self.name

    def get_column_value(self, excel_column_name):
        if excel_column_name == COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA_WITH_YEAR_PREFIX:
            return self.building_construction_per_capita_value

        return getattr(self, excel_column_name_to_db_column_name[excel_column_name])


