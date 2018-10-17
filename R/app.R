library(shiny)
library(readxl)
library(writexl)
library(DT)
library(httr)
library(jsonlite)
library(rjson)
library(dplyr)
library(splus2R)
library(miscTools)
library(rlist)

# TODO: 
# -1. Make sure the superuser and regular user UI branches are the same for their common elements
# 0. Login HTTP POST should have hashed password
# 1. Fix columns like Year + Metric e.g.: 2011 Population etc
# 2. Fix length of columns to be the same for both data and summary tables.
# 3. Save municipalities and year selection per user
# 4. Save full list of municipalities in DB via all_municipalities endpoint
# 5. Color stats row differently to stand out

# Nice to have:
# 3. Fix export to include statistics?
# 4. Add more resiliancy and error checing. Add try/catch like blocks as necessary
# 5. REFACTOR API CALLS TO BE PRIVATE !!!!
#    Have separate public get/set data methods for all endpoints instead of so many call_API* methods
# Contants file

# Data load spreadsheeet issues
# -2: Fix 2016 Building COnstruction Value per Capita and 2017 Weigthed Median Value Dwelling - values don't match.


setwd("~/Downloads/")

api_server_url <- 'http://localhost:8000/bmaapp/'
login_endpoint <- 'login'
municipalities_endpoint <- 'municipalities'
all_municipalities_endpoint <- 'all_municipalities'
data_endpoint <- 'data'

non_numeric_cols_count <- 1
export_filename <-"bmaExport.xls"

# Errors
kErrorTitleFailedToLoadData = 'Failed to Load from Excel File'

current_year <- as.integer(format(Sys.Date(), "%Y"))
oldest_year <- 1992L
years_all_options <- oldest_year: current_year

SUB_TAB_POPULATION <- "Population"
SUB_TAB_DENSITY_LAND_AREA <- "Density and Land Area"
SUB_TAB_ASSESSMENT_INFO <- "Assessment Information"
SUB_TAB_ASSESSMENT_COMPOSITION <- "Assessment Composition"
SUB_TAB_BUILDING_PERMIT_ACTIVITY <- "Building Permit Activity"
SUB_TAB_TOTAL_LEYY <- "Total Levy"
SUB_TAB_UPPER_TIER_LEVY <- "Upper Tier Levy"
SUB_TAB_LOWER_TIER_LEVY <- "Lower Tier Levy"
SUB_TAB_TAX_ASSET_CONSUMPTION_RATIO <- "Tax Asset Consumption Ratio"
SUB_TAB_FINANCIAL_POSITION_PER_CAPITA <- "Financial Position per Capita"
SUB_TAB_TAX_DIS_RES_PERCENT_OSR <- "Tax Dis Res as % OSR"
SUB_TAB_TAX_RESERVES_PERCENT_TAXATION <- "Tax Reserves as % of Taxation"
SUB_TAB_TAX_RES_PER_CAPITA <- "Tax Res per Capita"
SUB_TAB_TAX_DEBT_INT_PERCENT_OSR <- "Tax Debt Int % OSR"
SUB_TAB_TAX_DEBT_CHARGES_PERCENT_OSR <- "Tax Debt Charges as % OSR"
SUB_TAB_TOTAL_TAX_DEBT_OUT_PER_CAPITA <- "Total Debt Out per Capita"
SUB_TAB_TAX_DEBT_OUT_PER_CAPITA <- "Tax Debt Out per Capita"
SUB_TAB_DEBT_TO_RESERVE_RATIO <- "Debt to Reserve Ratio"
SUB_TAB_TAX_RECEIVABLE_PERCENT_TAX <- "Tax Receivable as % Tax"
SUB_TAB_RATES_COVERAGE_RATIO <- "Rates Coverage Ratio"
SUB_TAB_NET_FIN_LIAB_RATIO <- "Net Fin Liab Ratio"
SUB_TAB_DEVELOPMENT_CHARGES <- "Development Charges"
SUB_TAB_BUILDING_PERMIT_FEES <- "Building Permit Fees"
SUB_TAB_TAX_RATIOS <- "Tax Ratios"
SUB_TAB_OPTIONAL_CLASS <- "Optional Class"
SUB_TAB_TOTAL_TAX_RATES <- "Total Tax Rates"
SUB_TAB_MUNICIPAL_TAX_RATES <- "Municipal Tax Rates"
SUB_TAB_EDUCATIONL_TAX_RATES <- "Education Tax Rates"
SUB_TAB_RESIDENTIAL <- "Residential"
SUB_TAB_MULTI_RESIDENTIAL <- "Multi-Residential"
SUB_TAB_COMMERCIAL <- "Commercial"
SUB_TAB_INDUSTRIAL <- "Industrial"
SUB_TAB_WATER_AND_SEWER_COSTS <- "Water&Sewer Costs"
SUB_TAB_WATER_ASSET_CONSUMPTION <- "Water Asset Consumption"
SUB_TAB_WASTE_WATER_ASSET_CONSUMPTION <- "Wastewater Asset Consumption"
SUB_TAB_WATER_RES_PERCENT_OSR <- "Water Res as % OSR"
SUB_TAB_WASTE_WATER_RES_PERCENT_OSR <- "Wastewater Res as % OSR"
SUB_TAB_WATER_RES_PERCENT_ACUM_AMORT <- "Water Res as % Acum Amort"
SUB_TAB_WASTE_WATER_RES_PERCENT_ACUM_AMORT <- "Wastewater Res as % Acum Amort"
SUB_TAB_WATER_DEBT_INT_COVER <- "Water Debt Int Cover"
SUB_TAB_WASTE_WATER_DEBT_INT_COVER <- "Wastewater Debt Int Cover"
SUB_TAB_WATER_NET_FIN_LIAB <- "Water Net Fin Liab"
SUB_TAB_WASTE_WATER_NET_FIN_LIAB <- "Wastewater Net Fin Liab"
SUB_TAB_AVG_HOUSEHOLD_INCOME <- "Average Household Income"
SUB_TAB_AVG_VALUE_DWELLING <- "Average Value of Dwelling"
SUB_TAB_COMBINED_COSTS <- "Combined costs"
SUB_TAB_TAXES_PERCENT_INCOME <- "Taxes as a % of Income"
SUB_TAB_NET_EXPENDITURES_PER_CAPITA <- "Net Expenditures per Capita"

subtab_name_to_constant_name <- list(
  "Population" = "SUB_TAB_POPULATION", 
  "Density and Land Area" = "SUB_TAB_DENSITY_LAND_AREA", 
  "Assessment Information" = "SUB_TAB_ASSESSMENT_INFO", 
  "Assessment Composition" = "SUB_TAB_ASSESSMENT_COMPOSITION", 
  "Building Permit Activity" = "SUB_TAB_BUILDING_PERMIT_ACTIVITY", 
  "Total Levy" = "SUB_TAB_TOTAL_LEYY", 
  "Upper Tier Levy" = "SUB_TAB_UPPER_TIER_LEVY", 
  "Lower Tier Levy" = "SUB_TAB_LOWER_TIER_LEVY", 
  "Tax Asset Consumption Ratio" = "SUB_TAB_TAX_ASSET_CONSUMPTION_RATIO", 
  "Financial Position per Capita" = "SUB_TAB_FINANCIAL_POSITION_PER_CAPITA", 
  "Tax Dis Res as % OSR" = "SUB_TAB_TAX_DIS_RES_PERCENT_OSR", 
  "Tax Reserves as % of Taxation" = "SUB_TAB_TAX_RESERVES_PERCENT_TAXATION", 
  "Tax Res per Capita" = "SUB_TAB_TAX_RES_PER_CAPITA", 
  "Tax Debt Int % OSR" = "SUB_TAB_TAX_DEBT_INT_PERCENT_OSR", 
  "Tax Debt Charges as % OSR" = "SUB_TAB_TAX_DEBT_CHARGES_PERCENT_OSR", 
  "Total Debt Out per Capita" = "SUB_TAB_TOTAL_TAX_DEBT_OUT_PER_CAPITA", 
  "Tax Debt Out per Capita" = "SUB_TAB_TAX_DEBT_OUT_PER_CAPITA", 
  "Debt to Reserve Ratio" = "SUB_TAB_DEBT_TO_RESERVE_RATIO", 
  "Tax Receivable as % Tax" = "SUB_TAB_TAX_RECEIVABLE_PERCENT_TAX", 
  "Rates Coverage Ratio" = "SUB_TAB_RATES_COVERAGE_RATIO", 
  "Net Fin Liab Ratio" = "SUB_TAB_NET_FIN_LIAB_RATIO", 
  "Development Charges" = "SUB_TAB_DEVELOPMENT_CHARGES", 
  "Building Permit Fees" = "SUB_TAB_BUILDING_PERMIT_FEES", 
  "Tax Ratios" = "SUB_TAB_TAX_RATIOS", 
  "Optional Class" = "SUB_TAB_OPTIONAL_CLASS", 
  "Total Tax Rates" = "SUB_TAB_TOTAL_TAX_RATES", 
  "Municipal Tax Rates" = "SUB_TAB_MUNICIPAL_TAX_RATES", 
  "Education Tax Rates" = "SUB_TAB_EDUCATIONL_TAX_RATES", 
  "Residential" = "SUB_TAB_RESIDENTIAL", 
  "Multi-Residential" = "SUB_TAB_MULTI_RESIDENTIAL", 
  "Commercial" = "SUB_TAB_COMMERCIAL", 
  "Industrial" = "SUB_TAB_INDUSTRIAL", 
  "Water&Sewer Costs" = "SUB_TAB_WATER_AND_SEWER_COSTS", 
  "Water Asset Consumption" = "SUB_TAB_WATER_ASSET_CONSUMPTION", 
  "Wastewater Asset Consumption" = "SUB_TAB_WASTE_WATER_ASSET_CONSUMPTION", 
  "Water Res as % OSR" = "SUB_TAB_WATER_RES_PERCENT_OSR", 
  "Wastewater Res as % OSR" = "SUB_TAB_WASTE_WATER_RES_PERCENT_OSR", 
  "Water Res as % Acum Amort" = "SUB_TAB_WATER_RES_PERCENT_ACUM_AMORT", 
  "Wastewater Res as % Acum Amort" = "SUB_TAB_WASTE_WATER_RES_PERCENT_ACUM_AMORT", 
  "Water Debt Int Cover" = "SUB_TAB_WATER_DEBT_INT_COVER", 
  "Wastewater Debt Int Cover" = "SUB_TAB_WASTE_WATER_DEBT_INT_COVER", 
  "Water Net Fin Liab" = "SUB_TAB_WATER_NET_FIN_LIAB", 
  "Wastewater Net Fin Liab" = "SUB_TAB_WASTE_WATER_NET_FIN_LIAB", 
  "Average Household Income" = "SUB_TAB_AVG_HOUSEHOLD_INCOME", 
  "Average Value of Dwelling" = "SUB_TAB_AVG_VALUE_DWELLING", 
  "Combined costs" = "SUB_TAB_COMBINED_COSTS", 
  "Taxes as a % of Income" = "SUB_TAB_TAXES_PERCENT_INCOME", 
  "Net Expenditures per Capita" = "SUB_TAB_NET_EXPENDITURES_PER_CAPITA"
)

COLUMN_NAME_MUNICIPALITY = 'Municipality'
COLUMN_NAME_YEAR = 'Year'
COLUMN_NAME_POPULATION = 'Population'
COLUMN_NAME_POPULATION_DENSITY = 'Population Density per sq. km.'
COLUMN_NAME_POPULATION_INCREASE = 'Population Increase'
COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA = 'Building Construction Value per Capita'
COLUMN_NAME_ESTIMATED_AVG_HOUSEHOLD_INCOME = 'Estimated Average Household Income'
COLUMN_NAME_WEIGHTED_MEDIAN_VAL_DWELLING = 'Weighted Median Value of Dwelling'
COLUMN_NAME_UNWEIGHTED_ASSESSMENT_PER_CAPITA = 'Unweighted Assessment per Capita'
COLUMN_NAME_WEIGHTED_ASSESSMENT_PER_CAPITA = 'Weighted Assessment per Capita'
COLUMN_NAME_LAND_AREA = 'Land Area km2'
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
COLUMN_NAME_TOTAL_COMMERCIAL_RESIDUAL = 'Total Comm.  Residual'
COLUMN_NAME_TOTAL_COMMERCIAL_OFFICE = 'Total Comm.  Office'
COLUMN_NAME_TOTAL_COMMERCIAL_PARK_VAC = 'Total Commercial Park/Vac'
COLUMN_NAME_TOTAL_COMMERCIAL_SHOPPING = 'Total Comm.  Shopping'
COLUMN_NAME_TOTAL_INDUSTRIAL_RESIDUAL = 'Total Ind. Residual'
COLUMN_NAME_TOTAL_INDUSTRIAL_LARGE = 'Total Ind. Large'
COLUMN_NAME_MUNICIPAL_RESID = 'Municipal Resid.'
COLUMN_NAME_MUNICIPAL_MULTI_RESID = 'Municipal Multi Resid.'
COLUMN_NAME_MUNICIPAL_COMM_RESIDUAL = 'Municipal Comm.  Residual'
COLUMN_NAME_MUNICIPAL_COMM_OFFICE = 'Municipal Comm.  Office'
COLUMN_NAME_MUNICIPAL_COMMERCIAL_PARK_VAC = 'Municipal Commercial Park/Vac'
COLUMN_NAME_MUNICIPAL_COMM_SHOPPING = 'Municipal Comm.  Shopping'
COLUMN_NAME_MUNICIPAL_IND_RESIDUAL = 'Municipal Ind. Residual'
COLUMN_NAME_MUNICIPAL_IND_LARGE = 'Municipal Ind. Large'
COLUMN_NAME_EDUCATION_RESID = 'Education Resid.'
COLUMN_NAME_EDUCATION_MULTI_RESID = 'Education Multi Resid.'
COLUMN_NAME_EDUCATION_COMM_RESIDUAL = 'Education Comm.  Residual'
COLUMN_NAME_EDUCATION_COMM_OFFICE = 'Education Comm.  Office'
COLUMN_NAME_EDUCATION_COMMERCIAL_PARK_VAC = 'Education Commercial Park/Vac'
COLUMN_NAME_EDUCATION_COMM_SHOPPING = 'Education Comm.  Shopping'
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
COLUMN_NAME_COMMERCIAL_10K_M3 = 'Commercial  10,000 m3 2"'
COLUMN_NAME_INDUSTRIAL_30K_M3 = 'Industrial  30,000 m3 3"'
COLUMN_NAME_INDUSTRIAL_100K_M3 = 'Industrial  100,000 m3 4"'
COLUMN_NAME_INDUSTRIAL_500K_M3 = 'Industrial  500,000 m3 6"'
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
COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN = 'Total Municipal Tax Burden'
COLUMN_NAME_PROPERTY_TAXES_PERCENT_HOUSEHOLD_INCOME = 'Property Taxes as a % of Household Income'
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
COLUMN_NAME_MUSEUM = 'Museum'
COLUMN_NAME_CULTURAL = 'Cultural'
COLUMN_NAME_PLANNING = 'Planning'
COLUMN_NAME_COMM_IND = 'Comm & Ind.'
COLUMN_NAME_GENERAL_GOVERNMENT = 'General Government'
COLUMN_NAME_CONSERVATION_AUTHORITY = 'Conservation Authority'
COLUMN_NAME_AMBULANCE = 'Ambulance'
COLUMN_NAME_CEMETERIES = 'Cemeteries'

menu_tabs_text <- list(
  "Socio Economic Indicators",
  "Municipal Financial Indicators",
  "Select User Fee Information",
  "Tax Policies",
  "Comparison of Relative Taxes",
  "Comparison of Water & Sewer Costs",
  "Taxes as a % of Income",
  "Net Expenditures per Capita"
)

menu_sub_tabs_text <- list(
  list(SUB_TAB_POPULATION, SUB_TAB_DENSITY_LAND_AREA, SUB_TAB_ASSESSMENT_INFO, SUB_TAB_ASSESSMENT_COMPOSITION, SUB_TAB_BUILDING_PERMIT_ACTIVITY),
  
  list(SUB_TAB_TOTAL_LEYY, SUB_TAB_UPPER_TIER_LEVY, SUB_TAB_LOWER_TIER_LEVY, SUB_TAB_TAX_ASSET_CONSUMPTION_RATIO, SUB_TAB_FINANCIAL_POSITION_PER_CAPITA,
       SUB_TAB_TAX_DIS_RES_PERCENT_OSR, SUB_TAB_TAX_RESERVES_PERCENT_TAXATION, SUB_TAB_TAX_RES_PER_CAPITA, SUB_TAB_TAX_DEBT_INT_PERCENT_OSR,
       SUB_TAB_TAX_DEBT_CHARGES_PERCENT_OSR, SUB_TAB_TOTAL_TAX_DEBT_OUT_PER_CAPITA, SUB_TAB_TAX_DEBT_OUT_PER_CAPITA, SUB_TAB_DEBT_TO_RESERVE_RATIO,
       SUB_TAB_TAX_RECEIVABLE_PERCENT_TAX, SUB_TAB_RATES_COVERAGE_RATIO, SUB_TAB_NET_FIN_LIAB_RATIO),
  
  list(SUB_TAB_DEVELOPMENT_CHARGES, SUB_TAB_BUILDING_PERMIT_FEES),
  
  list(SUB_TAB_TAX_RATIOS, SUB_TAB_OPTIONAL_CLASS),
  
  list(SUB_TAB_TOTAL_TAX_RATES, SUB_TAB_MUNICIPAL_TAX_RATES, SUB_TAB_EDUCATIONL_TAX_RATES, SUB_TAB_RESIDENTIAL, SUB_TAB_MULTI_RESIDENTIAL,
       SUB_TAB_COMMERCIAL, SUB_TAB_INDUSTRIAL),
  
  list(SUB_TAB_WATER_AND_SEWER_COSTS, SUB_TAB_WATER_ASSET_CONSUMPTION, SUB_TAB_WASTE_WATER_ASSET_CONSUMPTION, SUB_TAB_WATER_RES_PERCENT_OSR,
       SUB_TAB_WASTE_WATER_RES_PERCENT_OSR, SUB_TAB_WATER_RES_PERCENT_ACUM_AMORT, SUB_TAB_WASTE_WATER_RES_PERCENT_ACUM_AMORT, SUB_TAB_WATER_DEBT_INT_COVER,
       SUB_TAB_WASTE_WATER_DEBT_INT_COVER, SUB_TAB_WATER_NET_FIN_LIAB, SUB_TAB_WASTE_WATER_NET_FIN_LIAB),
  
  list(SUB_TAB_AVG_HOUSEHOLD_INCOME, SUB_TAB_AVG_VALUE_DWELLING, SUB_TAB_COMBINED_COSTS, SUB_TAB_TAXES_PERCENT_INCOME),
  list(SUB_TAB_NET_EXPENDITURES_PER_CAPITA)
)

data_set_names <- list.flatten(menu_sub_tabs_text)

column_names_per_sub_tab_selection <- list(
  SUB_TAB_POPULATION = list(COLUMN_NAME_POPULATION, COLUMN_NAME_POPULATION_DENSITY, COLUMN_NAME_POPULATION_INCREASE, COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA,
                            COLUMN_NAME_ESTIMATED_AVG_HOUSEHOLD_INCOME, COLUMN_NAME_WEIGHTED_MEDIAN_VAL_DWELLING, COLUMN_NAME_UNWEIGHTED_ASSESSMENT_PER_CAPITA, 
                            COLUMN_NAME_WEIGHTED_ASSESSMENT_PER_CAPITA),
  SUB_TAB_DENSITY_LAND_AREA = list(COLUMN_NAME_POPULATION_DENSITY, COLUMN_NAME_LAND_AREA),
  SUB_TAB_ASSESSMENT_INFO = list(COLUMN_NAME_TOTAL_UNWEIGHTED_ASSESSMENT, COLUMN_NAME_TOTAL_WEIGHTED_ASSESSMENT, COLUMN_NAME_UNWEIGHTED_ASSESSMENT_PER_CAPITA, 
                                 COLUMN_NAME_WEIGHTED_ASSESSMENT_PER_CAPITA),
  SUB_TAB_ASSESSMENT_COMPOSITION = list(COLUMN_NAME_RESIDENTIAL, COLUMN_NAME_MULTI_RESIDENTIAL, COLUMN_NAME_COMMERCIAL, COLUMN_NAME_INDUSTRIAL, 
                                        COLUMN_NAME_PIPELINES, COLUMN_NAME_FARMLANDS, COLUMN_NAME_FORESTS),
  SUB_TAB_BUILDING_PERMIT_ACTIVITY = list(COLUMN_NAME_BUILDING_CONSTRUCTION_VALUE, COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA_WITH_YEAR_PREFIX),
  SUB_TAB_TOTAL_LEYY = list(COLUMN_NAME_TOTAL_NET_LEVY, COLUMN_NAME_LEVY_PER_CAPITA),
  SUB_TAB_UPPER_TIER_LEVY = list(COLUMN_NAME_UPPER_TIER_LEVY, COLUMN_NAME_UPPER_TIER_LEVY_PER_CAPITA),
  SUB_TAB_LOWER_TIER_LEVY = list(COLUMN_NAME_LOWER_TIER_LEVY, COLUMN_NAME_LOWER_TIER_LEVY_PER_CAPITA),
  SUB_TAB_TAX_ASSET_CONSUMPTION_RATIO = list(COLUMN_NAME_TAX_ASSET_CONSUMPTION_RATIO),
  SUB_TAB_FINANCIAL_POSITION_PER_CAPITA = list(COLUMN_NAME_FINANCIAL_POSITION_PER_CAPITA),
  SUB_TAB_TAX_DIS_RES_PERCENT_OSR = list(COLUMN_NAME_TAX_DISCRETIONARY_RESERVES_PERCENT_SOURCE_REVENUES),
  SUB_TAB_TAX_RESERVES_PERCENT_TAXATION = list(COLUMN_NAME_TAX_RESERVES_PERCENT_TAXATION),
  SUB_TAB_TAX_RES_PER_CAPITA = list(COLUMN_NAME_TAX_RESERVE_PER_CAPITA),
  SUB_TAB_TAX_DEBT_INT_PERCENT_OSR = list(COLUMN_NAME_TAX_DEBT_INT_PERCENT_OSR),
  SUB_TAB_TAX_DEBT_CHARGES_PERCENT_OSR = list(COLUMN_NAME_TAXR_DEBT_CHARGES_PERCENT_OSR),
  SUB_TAB_TOTAL_TAX_DEBT_OUT_PER_CAPITA = list(COLUMN_NAME_TOTAL_DEBT_OUTSTANDING_PER_CAPITA),
  SUB_TAB_TAX_DEBT_OUT_PER_CAPITA = list(COLUMN_NAME_TAX_DEBT_OUTSTANDING_PER_CAPITA),
  SUB_TAB_DEBT_TO_RESERVE_RATIO = list(COLUMN_NAME_DEBT_TO_RESERVE_RATIO),
  SUB_TAB_TAX_RECEIVABLE_PERCENT_TAX = list(COLUMN_NAME_TAXES_RECEIVABLE_PERCENT_TAXES_LEVIED),
  SUB_TAB_RATES_COVERAGE_RATIO = list(COLUMN_NAME_RATES_COVERAGE_RATIO),
  SUB_TAB_NET_FIN_LIAB_RATIO = list(COLUMN_NAME_NET_FINANCIAL_LIABILITIES_RATIO),
  
  SUB_TAB_DEVELOPMENT_CHARGES = list(COLUMN_NAME_SINGLE_DETACHED_DWELLINGS_PER_UNIT, COLUMN_NAME_MULTIPLES_DWELLING__3_OR_MORE, 
                                     COLUMN_NAME_MULTIPLES_DWELLING_1_OR_2, COLUMN_NAME_APARTMENT_UNITS_2_OR_MORE, COLUMN_NAME_APARTMENT_UNITS_LESS_THAN_2, 
                                     COLUMN_NAME_NON_RESIDENTIAL_COMMERCIAL_PER_SQFT, COLUMN_NAME_NON_RESIDENTIAL_INDUSTRIAL_PER_SQFT),
  SUB_TAB_BUILDING_PERMIT_FEES = list(COLUMN_NAME_BUILDING_PERMIT_FEE),
  SUB_TAB_TAX_RATIOS = list(COLUMN_NAME_TAX_RATIOS_MULTI_RESIDENTIAL, COLUMN_NAME_TAX_RATIOS_COMMERCIAL_RESIDUAL, COLUMN_NAME_TAX_RATIOS_INDUSTRIAL_RESIDUAL),
  SUB_TAB_OPTIONAL_CLASS = list(COLUMN_NAME_NEW_MULTI_RESIDENTIAL, COLUMN_NAME_COMMERCIAL_OFFICE, COLUMN_NAME_COMMERCIAL_SHOPPING, COLUMN_NAME_COMMERCIAL_PARKING, 
                                COLUMN_NAME_INDUSTRIAL_LARGE),
  SUB_TAB_TOTAL_TAX_RATES = list(COLUMN_NAME_TOTAL_RESID, COLUMN_NAME_TOTAL_MULTI_RESID, COLUMN_NAME_TOTAL_COMMERCIAL_RESIDUAL, COLUMN_NAME_TOTAL_COMMERCIAL_OFFICE, 
                                 COLUMN_NAME_TOTAL_COMMERCIAL_PARK_VAC, COLUMN_NAME_TOTAL_COMMERCIAL_SHOPPING, COLUMN_NAME_TOTAL_INDUSTRIAL_RESIDUAL, 
                                 COLUMN_NAME_TOTAL_INDUSTRIAL_LARGE),
  SUB_TAB_MUNICIPAL_TAX_RATES = list(COLUMN_NAME_MUNICIPAL_RESID, COLUMN_NAME_MUNICIPAL_MULTI_RESID, COLUMN_NAME_MUNICIPAL_COMM_RESIDUAL, 
                                     COLUMN_NAME_MUNICIPAL_COMM_OFFICE, COLUMN_NAME_MUNICIPAL_COMMERCIAL_PARK_VAC, COLUMN_NAME_MUNICIPAL_COMM_SHOPPING, 
                                     COLUMN_NAME_MUNICIPAL_IND_RESIDUAL, COLUMN_NAME_MUNICIPAL_IND_LARGE),
  SUB_TAB_EDUCATIONL_TAX_RATES = list(COLUMN_NAME_EDUCATION_RESID, COLUMN_NAME_EDUCATION_MULTI_RESID, COLUMN_NAME_EDUCATION_COMM_RESIDUAL, 
                                      COLUMN_NAME_EDUCATION_COMM_OFFICE, COLUMN_NAME_EDUCATION_COMMERCIAL_PARK_VAC, COLUMN_NAME_EDUCATION_COMM_SHOPPING, 
                                      COLUMN_NAME_EDUCATION_IND_RESIDUAL, COLUMN_NAME_EDUCATION_IND_LARGE),
  SUB_TAB_RESIDENTIAL = list(COLUMN_NAME_BUNGALOW, COLUMN_NAME_2_STOREY, COLUMN_NAME_EXECUTIVE),
  SUB_TAB_MULTI_RESIDENTIAL = list(COLUMN_NAME_MULTI_RES_WALK_UP, COLUMN_NAME_MULTI_RES_HIGH_RISE),
  SUB_TAB_COMMERCIAL = list(COLUMN_NAME_TAX_SHOPPING, COLUMN_NAME_TAX_HOTEL, COLUMN_NAME_TAX_MOTEL, COLUMN_NAME_TAX_OFFICE),
  SUB_TAB_INDUSTRIAL = list(COLUMN_NAME_TAX_IND_STANDARD, COLUMN_NAME_TAX_IND_LARGE, COLUMN_NAME_TAX_IND_VACANT),
  SUB_TAB_WATER_AND_SEWER_COSTS = list(COLUMN_NAME_RESIDENTIAL_200_M3, COLUMN_NAME_COMMERCIAL_10K_M3, COLUMN_NAME_INDUSTRIAL_30K_M3, 
                                       COLUMN_NAME_INDUSTRIAL_100K_M3, COLUMN_NAME_INDUSTRIAL_500K_M3),
  SUB_TAB_WATER_ASSET_CONSUMPTION = list(COLUMN_NAME_WATER_ASSET_CONSUMPTION),
  SUB_TAB_WASTE_WATER_ASSET_CONSUMPTION = list(COLUMN_NAME_WW_ASSET_CONSUMPTION),
  SUB_TAB_WATER_RES_PERCENT_OSR = list(COLUMN_NAME_WATER_RES_PERCENT_OSR),
  SUB_TAB_WASTE_WATER_RES_PERCENT_OSR = list(COLUMN_NAME_WW_RES_PERCENT_OSR),
  SUB_TAB_WATER_RES_PERCENT_ACUM_AMORT = list(COLUMN_NAME_WATER_RES_PERCENT_ACUM_AMORT),
  SUB_TAB_WASTE_WATER_RES_PERCENT_ACUM_AMORT = list(COLUMN_NAME_WW_RES_PERCENT_ACUM_AMORT),
  SUB_TAB_WATER_DEBT_INT_COVER = list(COLUMN_NAME_WATER_DEBT_INTEREST_COVERAGE),
  SUB_TAB_WASTE_WATER_DEBT_INT_COVER = list(COLUMN_NAME_WW_DEBT_INTEREST_COVERAGE),
  SUB_TAB_WATER_NET_FIN_LIAB = list(COLUMN_NAME_WATER_NET_LIN_LIAB),
  SUB_TAB_WASTE_WATER_NET_FIN_LIAB = list(COLUMN_NAME_WW_NET_LIN_LIAB),
  SUB_TAB_AVG_HOUSEHOLD_INCOME = list(COLUMN_NAME_EST_AVG_HOUSEHOLD_INCOME),
  SUB_TAB_AVG_VALUE_DWELLING = list(COLUMN_NAME_WEIGHTED_MEDIAN_VAL_DWELLING),
  SUB_TAB_COMBINED_COSTS = list(COLUMN_NAME_RESIDENTIAL_WATER_SEWER_COSTS, COLUMN_NAME_AVG_RESIDENTIAL_TAXES, COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN),
  SUB_TAB_TAXES_PERCENT_INCOME = list(COLUMN_NAME_AVG_RESIDENTIAL_TAXES, COLUMN_NAME_PROPERTY_TAXES_PERCENT_HOUSEHOLD_INCOME, 
                                      COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN, COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN_PERCENT_HOUSEHOLD_INCOME),
  SUB_TAB_NET_EXPENDITURES_PER_CAPITA = list(COLUMN_NAME_FIRE, COLUMN_NAME_ROADS_PAVED, COLUMN_NAME_BRIDGES_CULVERTS, COLUMN_NAME_TRAFFIC, 
                                             COLUMN_NAME_WINTER_ROADS, COLUMN_NAME_WINTER_SIDEWALKS, COLUMN_NAME_TRANSIT, COLUMN_NAME_PARKING, 
                                             COLUMN_NAME_WASTE_COLLECTION, COLUMN_NAME_WASTE_DISPOSAL, COLUMN_NAME_STORM, COLUMN_NAME_RECYCLING, 
                                             COLUMN_NAME_PUBLIC_HEALTH, COLUMN_NAME_EMERGENCY_MEASURES, COLUMN_NAME_GENERAL_ASSISTANCE, 
                                             COLUMN_NAME_ASSISTANCE_AGED, COLUMN_NAME_POA, COLUMN_NAME_CHILD_CARE, COLUMN_NAME_SOCIAL_HOUSING, 
                                             COLUMN_NAME_PARKS, COLUMN_NAME_RECREATION_PROGRAMS, COLUMN_NAME_REC_FAC_GOLF, COLUMN_NAME_REC_FACILITIES_OTHER, 
                                             COLUMN_NAME_LIBRARY, COLUMN_NAME_MUSEUM, COLUMN_NAME_CULTURAL, COLUMN_NAME_PLANNING, COLUMN_NAME_COMM_IND, 
                                             COLUMN_NAME_GENERAL_GOVERNMENT, COLUMN_NAME_CONSERVATION_AUTHORITY, COLUMN_NAME_AMBULANCE, COLUMN_NAME_CEMETERIES)
)

ALL_COLUMN_NAMES_LIST <- unique(append(list(COLUMN_NAME_MUNICIPALITY, COLUMN_NAME_YEAR),
                                       list.flatten(column_names_per_sub_tab_selection)))

FORMAT_SETTINGS_CURRENCY_DEFAULT = list("SYMBOL" = "$", "SEPARATOR" = ",", "DECIMALS" = 0)
FORMAT_SETTINGS_CURRENCY_2_DECIMALS = list("SYMBOL" = "$", "SEPARATOR" = ",", "DECIMALS" = 2)
FORMAT_SETTINGS_COUNTER = list("SYMBOL" = "", "SEPARATOR" = ",", "DECIMALS" = 0)
FORMAT_SETTINGS_PERCENT_1_DECIMAL = list("SYMBOL" = "", "SEPARATOR" = ",", "DECIMALS" = 1)
FORMAT_SETTINGS_PERCENT_2_DECIMALS = list("SYMBOL" = "", "SEPARATOR" = ",", "DECIMALS" = 2)
FORMAT_SETTINGS_PERCENT_4_DECIMALS = list("SYMBOL" = "", "SEPARATOR" = ",", "DECIMALS" = 4)
FORMAT_SETTINGS_PERCENT_5_DECIMALS = list("SYMBOL" = "", "SEPARATOR" = ",", "DECIMALS" = 5)
FORMAT_SETTINGS_PERCENT_6_DECIMALS = list("SYMBOL" = "", "SEPARATOR" = ",", "DECIMALS" = 6)

AS_IS_DISPLAY_COLUMNS = list(COLUMN_NAME_MUNICIPALITY, COLUMN_NAME_YEAR)

COLUMNS_COUNTER = c(COLUMN_NAME_POPULATION, COLUMN_NAME_POPULATION_DENSITY, COLUMN_NAME_LAND_AREA, COLUMN_NAME_TOTAL_INDUSTRIAL_LARGE)

COLUMNS_PERCENT_1_DECIMAL = c(COLUMN_NAME_WATER_NET_LIN_LIAB, COLUMN_NAME_WW_NET_LIN_LIAB)

COLUMNS_PERCENT_2_DECIMALS = c(COLUMN_NAME_POPULATION_INCREASE, COLUMN_NAME_RESIDENTIAL, COLUMN_NAME_MULTI_RESIDENTIAL, COLUMN_NAME_COMMERCIAL, 
                               COLUMN_NAME_INDUSTRIAL, COLUMN_NAME_PIPELINES, COLUMN_NAME_FARMLANDS, COLUMN_NAME_FORESTS, COLUMN_NAME_TAX_ASSET_CONSUMPTION_RATIO, 
                               COLUMN_NAME_TAX_DISCRETIONARY_RESERVES_PERCENT_SOURCE_REVENUES, COLUMN_NAME_TAX_RESERVES_PERCENT_TAXATION, 
                               COLUMN_NAME_TAX_DEBT_INT_PERCENT_OSR, COLUMN_NAME_TAXR_DEBT_CHARGES_PERCENT_OSR, COLUMN_NAME_DEBT_TO_RESERVE_RATIO, 
                               COLUMN_NAME_TAXES_RECEIVABLE_PERCENT_TAXES_LEVIED, COLUMN_NAME_RATES_COVERAGE_RATIO, COLUMN_NAME_NET_FINANCIAL_LIABILITIES_RATIO, 
                               COLUMN_NAME_WATER_ASSET_CONSUMPTION, COLUMN_NAME_WW_ASSET_CONSUMPTION, COLUMN_NAME_WATER_RES_PERCENT_OSR, COLUMN_NAME_WW_RES_PERCENT_OSR, 
                               COLUMN_NAME_WATER_RES_PERCENT_ACUM_AMORT, COLUMN_NAME_WW_RES_PERCENT_ACUM_AMORT, COLUMN_NAME_WATER_DEBT_INTEREST_COVERAGE, 
                               COLUMN_NAME_WW_DEBT_INTEREST_COVERAGE, COLUMN_NAME_PROPERTY_TAXES_PERCENT_HOUSEHOLD_INCOME, 
                               COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN_PERCENT_HOUSEHOLD_INCOME)

COLUMNS_PERCENT_4_DECIMALS = c(COLUMN_NAME_TAX_RATIOS_MULTI_RESIDENTIAL, COLUMN_NAME_TAX_RATIOS_COMMERCIAL_RESIDUAL, COLUMN_NAME_TAX_RATIOS_INDUSTRIAL_RESIDUAL, 
                               COLUMN_NAME_NEW_MULTI_RESIDENTIAL, COLUMN_NAME_COMMERCIAL_OFFICE, COLUMN_NAME_COMMERCIAL_SHOPPING, COLUMN_NAME_COMMERCIAL_PARKING, 
                               COLUMN_NAME_INDUSTRIAL_LARGE)

COLUMNS_PERCENT_5_DECIMALS = c(COLUMN_NAME_TOTAL_RESID, COLUMN_NAME_TOTAL_MULTI_RESID, COLUMN_NAME_TOTAL_COMMERCIAL_RESIDUAL, COLUMN_NAME_TOTAL_COMMERCIAL_OFFICE, 
                               COLUMN_NAME_TOTAL_COMMERCIAL_PARK_VAC, COLUMN_NAME_TOTAL_COMMERCIAL_SHOPPING, COLUMN_NAME_TOTAL_INDUSTRIAL_RESIDUAL)

COLUMNS_PERCENT_6_DECIMALS = c(COLUMN_NAME_MUNICIPAL_RESID, COLUMN_NAME_MUNICIPAL_MULTI_RESID, COLUMN_NAME_MUNICIPAL_COMM_RESIDUAL, COLUMN_NAME_MUNICIPAL_COMM_OFFICE, 
                               COLUMN_NAME_MUNICIPAL_COMMERCIAL_PARK_VAC, COLUMN_NAME_MUNICIPAL_COMM_SHOPPING, COLUMN_NAME_MUNICIPAL_IND_RESIDUAL, 
                               COLUMN_NAME_MUNICIPAL_IND_LARGE, COLUMN_NAME_EDUCATION_RESID, COLUMN_NAME_EDUCATION_MULTI_RESID, COLUMN_NAME_EDUCATION_COMM_RESIDUAL, 
                               COLUMN_NAME_EDUCATION_COMM_OFFICE, COLUMN_NAME_EDUCATION_COMMERCIAL_PARK_VAC, COLUMN_NAME_EDUCATION_COMM_SHOPPING, 
                               COLUMN_NAME_EDUCATION_IND_LARGE)

COLUMNS_CURRENCY_2_DECIMALS = c(COLUMN_NAME_NON_RESIDENTIAL_COMMERCIAL_PER_SQFT, COLUMN_NAME_NON_RESIDENTIAL_INDUSTRIAL_PER_SQFT, COLUMN_NAME_TAX_SHOPPING, 
                                COLUMN_NAME_TAX_OFFICE, COLUMN_NAME_TAX_IND_STANDARD, COLUMN_NAME_TAX_IND_LARGE)

COLUMNS_CURRENCY_0_DECIMALS = c(COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA, COLUMN_NAME_ESTIMATED_AVG_HOUSEHOLD_INCOME, COLUMN_NAME_WEIGHTED_MEDIAN_VAL_DWELLING, 
                                COLUMN_NAME_UNWEIGHTED_ASSESSMENT_PER_CAPITA, COLUMN_NAME_WEIGHTED_ASSESSMENT_PER_CAPITA, COLUMN_NAME_TOTAL_UNWEIGHTED_ASSESSMENT, 
                                COLUMN_NAME_TOTAL_WEIGHTED_ASSESSMENT, COLUMN_NAME_BUILDING_CONSTRUCTION_VALUE, COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA_WITH_YEAR_PREFIX,
                                COLUMN_NAME_TOTAL_NET_LEVY, COLUMN_NAME_LEVY_PER_CAPITA, COLUMN_NAME_UPPER_TIER_LEVY, COLUMN_NAME_UPPER_TIER_LEVY_PER_CAPITA, 
                                COLUMN_NAME_LOWER_TIER_LEVY, COLUMN_NAME_LOWER_TIER_LEVY_PER_CAPITA, COLUMN_NAME_FINANCIAL_POSITION_PER_CAPITA, 
                                COLUMN_NAME_TAX_RESERVE_PER_CAPITA, COLUMN_NAME_TOTAL_DEBT_OUTSTANDING_PER_CAPITA, COLUMN_NAME_TAX_DEBT_OUTSTANDING_PER_CAPITA, 
                                COLUMN_NAME_SINGLE_DETACHED_DWELLINGS_PER_UNIT, COLUMN_NAME_MULTIPLES_DWELLING__3_OR_MORE, COLUMN_NAME_MULTIPLES_DWELLING_1_OR_2, 
                                COLUMN_NAME_APARTMENT_UNITS_2_OR_MORE, COLUMN_NAME_APARTMENT_UNITS_LESS_THAN_2, COLUMN_NAME_BUILDING_PERMIT_FEE, COLUMN_NAME_BUNGALOW, 
                                COLUMN_NAME_2_STOREY, COLUMN_NAME_EXECUTIVE, COLUMN_NAME_MULTI_RES_WALK_UP, COLUMN_NAME_MULTI_RES_HIGH_RISE, COLUMN_NAME_TAX_HOTEL, 
                                COLUMN_NAME_TAX_MOTEL, COLUMN_NAME_TAX_IND_VACANT, COLUMN_NAME_RESIDENTIAL_200_M3, COLUMN_NAME_COMMERCIAL_10K_M3, 
                                COLUMN_NAME_INDUSTRIAL_30K_M3, COLUMN_NAME_INDUSTRIAL_100K_M3, COLUMN_NAME_INDUSTRIAL_500K_M3, COLUMN_NAME_EST_AVG_HOUSEHOLD_INCOME, 
                                COLUMN_NAME_RESIDENTIAL_WATER_SEWER_COSTS, COLUMN_NAME_AVG_RESIDENTIAL_TAXES, COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN, COLUMN_NAME_FIRE, 
                                COLUMN_NAME_ROADS_PAVED, COLUMN_NAME_BRIDGES_CULVERTS, COLUMN_NAME_TRAFFIC, COLUMN_NAME_WINTER_ROADS, COLUMN_NAME_WINTER_SIDEWALKS, 
                                COLUMN_NAME_TRANSIT, COLUMN_NAME_PARKING, COLUMN_NAME_WASTE_COLLECTION, COLUMN_NAME_WASTE_DISPOSAL, COLUMN_NAME_STORM, COLUMN_NAME_RECYCLING, 
                                COLUMN_NAME_PUBLIC_HEALTH, COLUMN_NAME_EMERGENCY_MEASURES, COLUMN_NAME_GENERAL_ASSISTANCE, COLUMN_NAME_ASSISTANCE_AGED, COLUMN_NAME_POA, 
                                COLUMN_NAME_CHILD_CARE, COLUMN_NAME_SOCIAL_HOUSING, COLUMN_NAME_PARKS, COLUMN_NAME_RECREATION_PROGRAMS, COLUMN_NAME_REC_FAC_GOLF, 
                                COLUMN_NAME_REC_FACILITIES_OTHER, COLUMN_NAME_LIBRARY, COLUMN_NAME_MUSEUM, COLUMN_NAME_CULTURAL, COLUMN_NAME_PLANNING, COLUMN_NAME_COMM_IND, 
                                COLUMN_NAME_GENERAL_GOVERNMENT, COLUMN_NAME_CONSERVATION_AUTHORITY, COLUMN_NAME_AMBULANCE, COLUMN_NAME_CEMETERIES)

excel_sheet_names <- function(filename) {
  readxl::excel_sheets(filename)
}

read_excel_allsheets <- function(filename) {
  sheets <- readxl::excel_sheets(filename)
  x <- lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
  names(x) <- sheets
  x
}

# Convert data_frame to numeric columns except the first 1 column which is the municipalities names
convert_to_numeric <- function(data_frame) {
  cols <- (non_numeric_cols_count+1):ncol(data_frame)
  data_frame[cols] <- lapply(data_frame[cols], as.numeric)
  data_frame
}

get_filter_columns <- function(selected_sub_tab) {
  subtab_constant <- subtab_name_to_constant_name[[selected_sub_tab]]
  column_names <- column_names_per_sub_tab_selection[[subtab_constant]]
  column_names <- append(list(COLUMN_NAME_MUNICIPALITY, COLUMN_NAME_YEAR), column_names) 
}

filter_data_frame <- function(data_frame, filter_columns) {
  filtered_data_frame <- data_frame[unlist(filter_columns, use.name=FALSE)]
}

# Create stats data frame for given data frame with min, max, average, and median
# for each of numeric column in given data frame
get_stats <- function(data_frame) {
  data_frame_only_numeric <- data_frame[,-non_numeric_cols_count]

  # Create empty data frame that will store the stats
  df <- data.frame(matrix(ncol = ncol(data_frame)-non_numeric_cols_count, nrow = 0))

  # Copy non-numeric column names
  colnames(df) <- colnames(data_frame_only_numeric)

  df["Min",] <- colMins(data_frame_only_numeric, na.rm = TRUE)
  df["Max",] <- colMaxs(data_frame_only_numeric, na.rm = TRUE)
  df["Average",] <- colMeans(data_frame_only_numeric, na.rm = TRUE)
  # Note: using colMedians from miscTools package because splus2R package implementation does not work with NA values
  df["Median",] <- splus2R::colMedians(data_frame_only_numeric, na.rm = TRUE)
  df
}

# Call API login endpoint with given credentials to authenticate user
call_login_endpoint <- function(userid, password) {
  url <- paste(api_server_url, login_endpoint, "?", "userid", "=", userid, "&", "password", "=", password, sep="")
  call_success <- httr::GET(url)
  call_success_text <- content(call_success, "text")
  call_success_final <- fromJSON(call_success_text)
  print(call_success_final)
}

call_API_municipalities_endpoint <- function(method = httr::GET, municipalities = NULL) {
  call_API_municipalities_helper(municipalities_endpoint, method = method, municipalities = municipalities)
}

call_API_all_municipalities_endpoint <- function(method = httr::GET, municipalities = NULL) {
  call_API_municipalities_helper(all_municipalities_endpoint, method = method, municipalities = municipalities)
}

call_API_municipalities_helper <- function(endpoint, method = httr::GET, municipalities = NULL) {
  url <-paste(api_server_url, endpoint, sep="")

  error <- NULL  
  if (identical(method, httr::GET)) {
    if (!is.null(municipalities)) {
      error <- "Attempt to call API municipalities endpoint with GET but municipalities should not be passed in"
    }
    else {
      # Valid parameters. No request body needed
      requestBody <- NULL  
    }
  }
  else if (identical(method, httr::POST)) {
    if (!is.null(municipalities)) {
      # Valid parameters
      # Pass municipalities in the body as JSON
      requestBody <- paste('{"municipalities":', toJSON(municipalities),'}')
    }
    else {
      error <- "Attempt to call API municipalities endpoint with POST but no municipalities set"
    }
  }
  else {
    error <- "Attempt to call API municipalities endpoint with unsupported HTTP method"
  }
  
  if (!is.null(error)) {
    print(error)
    result = list(success = "false", error_message = error)
    print(result)
    return
  }
  
  call_success <- method(url, body=requestBody)
  call_success_text <- content(call_success, "text")
  
  # Get API response (succesful or unsuccesful)
  call_success_final <- fromJSON(call_success_text)
  print(call_success_final)
}

# Call data read/write endpoint
call_API_data_endpoint <- function(municipalities = NULL, year = NULL, data_frames = NULL) {
  url <-paste(api_server_url, data_endpoint, "?year=", year, sep="")
  method <- httr::POST
  
  # To get data a year parameter and a list of municipalities is passed as JSON body
  if ((!is.null(municipalities)) && (length(municipalities) >= 1) && (!is.null(year))) {
    requestBody <- paste('{"municipalities":', toJSON(municipalities),'}')
  }
  else if ((!is.null(data_frames)) && (!is.null(year))) {
    # POST is called with list of data_frames in JSON format in body
    # print(rjson::toJSON(data_frames))
    requestBody <- paste('{"data":',  rjson::toJSON(data_frames), '}')
  }
  else {
    err <- paste("Cannot call API data endpoint because one of the parameters is not valid: year = ",  year, 
                 " no municicpalities = ", is.null(municipalities) || length(municipalities) == 0, 
                 " data_frames is NULL = ", is.null(data_frames))
    result <- list(success = 'false', error_message = err)
    return
  }
  
  call_success <- method(url, body=requestBody)
  call_success_text <- content(call_success, "text")
  print(call_success_text)
  
  # Get API response (succesful or unsuccesful)
  call_success_final <- jsonlite::fromJSON(call_success_text)
  print(call_success_final)
}

# UI rendering of data frame as a data table
renderDT_formatted <- function(data_frame, no_table_header = F) {
  column_names <- colnames(data_frame)
  
  if (no_table_header) {
    # show only table (no column sorting)
    # Before rendering format the numbers to display in currency format
    renderDT(datatable(data_frame, options = list(dom = 't', bSort = FALSE), colnames = NULL) %>% 
               formatCurrency(intersect(COLUMNS_COUNTER, column_names), currency = FORMAT_SETTINGS_COUNTER$SYMBOL, mark = FORMAT_SETTINGS_COUNTER$SEPARATOR, digits = FORMAT_SETTINGS_COUNTER$DECIMALS) %>% 
               formatCurrency(intersect(COLUMNS_CURRENCY_0_DECIMALS, column_names), currency = FORMAT_SETTINGS_CURRENCY_DEFAULT$SYMBOL, mark = FORMAT_SETTINGS_CURRENCY_DEFAULT$SEPARATOR, 
                              digits = FORMAT_SETTINGS_CURRENCY_DEFAULT$DECIMALS) %>% 
               formatCurrency(intersect(COLUMNS_CURRENCY_2_DECIMALS, column_names), currency = FORMAT_SETTINGS_CURRENCY_2_DECIMALS$SYMBOL, mark = FORMAT_SETTINGS_CURRENCY_2_DECIMALS$SEPARATOR, 
                              digits = FORMAT_SETTINGS_CURRENCY_2_DECIMALS$DECIMALS) %>% 
               formatCurrency(intersect(COLUMNS_PERCENT_1_DECIMAL, column_names), currency = FORMAT_SETTINGS_PERCENT_1_DECIMAL$SYMBOL, mark = FORMAT_SETTINGS_PERCENT_1_DECIMAL$SEPARATOR, 
                              digits = FORMAT_SETTINGS_PERCENT_1_DECIMAL$DECIMALS) %>% 
               formatCurrency(intersect(COLUMNS_PERCENT_2_DECIMALS, column_names), currency = FORMAT_SETTINGS_PERCENT_2_DECIMALS$SYMBOL, mark = FORMAT_SETTINGS_PERCENT_2_DECIMALS$SEPARATOR, 
                              digits = FORMAT_SETTINGS_PERCENT_2_DECIMALS$DECIMALS) %>% 
               formatCurrency(intersect(COLUMNS_PERCENT_4_DECIMALS, column_names), currency = FORMAT_SETTINGS_PERCENT_4_DECIMALS$SYMBOL, mark = FORMAT_SETTINGS_PERCENT_4_DECIMALS$SEPARATOR, 
                              digits = FORMAT_SETTINGS_PERCENT_4_DECIMALS$DECIMALS) %>% 
               formatCurrency(intersect(COLUMNS_PERCENT_5_DECIMALS, column_names), currency = FORMAT_SETTINGS_PERCENT_5_DECIMALS$SYMBOL, mark = FORMAT_SETTINGS_PERCENT_5_DECIMALS$SEPARATOR, 
                              digits = FORMAT_SETTINGS_PERCENT_5_DECIMALS$DECIMALS) %>% 
               formatCurrency(intersect(COLUMNS_PERCENT_6_DECIMALS, column_names), currency = FORMAT_SETTINGS_PERCENT_6_DECIMALS$SYMBOL, mark = FORMAT_SETTINGS_PERCENT_6_DECIMALS$SEPARATOR, 
                              digits = FORMAT_SETTINGS_PERCENT_6_DECIMALS$DECIMALS), 
             selection = 'none', server = F)
  }
  else {
    # Do not show search box
    # Before rendering format the numbers to display in currency format
    renderDT(datatable(data_frame, options = list(searching = FALSE)) %>% 
               formatCurrency(intersect(COLUMNS_COUNTER, column_names), currency = FORMAT_SETTINGS_COUNTER$SYMBOL, mark = FORMAT_SETTINGS_COUNTER$SEPARATOR, digits = FORMAT_SETTINGS_COUNTER$DECIMALS) %>% 
               formatCurrency(intersect(COLUMNS_CURRENCY_0_DECIMALS, column_names), currency = FORMAT_SETTINGS_CURRENCY_DEFAULT$SYMBOL, mark = FORMAT_SETTINGS_CURRENCY_DEFAULT$SEPARATOR, 
                              digits = FORMAT_SETTINGS_CURRENCY_DEFAULT$DECIMALS) %>% 
               formatCurrency(intersect(COLUMNS_CURRENCY_2_DECIMALS, column_names), currency = FORMAT_SETTINGS_CURRENCY_2_DECIMALS$SYMBOL, mark = FORMAT_SETTINGS_CURRENCY_2_DECIMALS$SEPARATOR, 
                              digits = FORMAT_SETTINGS_CURRENCY_2_DECIMALS$DECIMALS) %>% 
               formatCurrency(intersect(COLUMNS_PERCENT_1_DECIMAL, column_names), currency = FORMAT_SETTINGS_PERCENT_1_DECIMAL$SYMBOL, mark = FORMAT_SETTINGS_PERCENT_1_DECIMAL$SEPARATOR, 
                              digits = FORMAT_SETTINGS_PERCENT_1_DECIMAL$DECIMALS) %>% 
               formatCurrency(intersect(COLUMNS_PERCENT_2_DECIMALS, column_names), currency = FORMAT_SETTINGS_PERCENT_2_DECIMALS$SYMBOL, mark = FORMAT_SETTINGS_PERCENT_2_DECIMALS$SEPARATOR, 
                              digits = FORMAT_SETTINGS_PERCENT_2_DECIMALS$DECIMALS) %>% 
               formatCurrency(intersect(COLUMNS_PERCENT_4_DECIMALS, column_names), currency = FORMAT_SETTINGS_PERCENT_4_DECIMALS$SYMBOL, mark = FORMAT_SETTINGS_PERCENT_4_DECIMALS$SEPARATOR, 
                              digits = FORMAT_SETTINGS_PERCENT_4_DECIMALS$DECIMALS) %>% 
               formatCurrency(intersect(COLUMNS_PERCENT_5_DECIMALS, column_names), currency = FORMAT_SETTINGS_PERCENT_5_DECIMALS$SYMBOL, mark = FORMAT_SETTINGS_PERCENT_5_DECIMALS$SEPARATOR, 
                              digits = FORMAT_SETTINGS_PERCENT_5_DECIMALS$DECIMALS) %>% 
               formatCurrency(intersect(COLUMNS_PERCENT_6_DECIMALS, column_names), currency = FORMAT_SETTINGS_PERCENT_6_DECIMALS$SYMBOL, mark = FORMAT_SETTINGS_PERCENT_6_DECIMALS$SEPARATOR, 
                              digits = FORMAT_SETTINGS_PERCENT_6_DECIMALS$DECIMALS), 
             selection = 'none', server = F)
  }
}

filter_and_display <- function(output, data_frame, selected_sub_tab) {
  if (!is.null(data_frame)) {
    filter_columns <- get_filter_columns(selected_sub_tab)
    filtered_data_frame <- filter_data_frame(data_frame, filter_columns)
    print(filtered_data_frame)
    
    # Render data and stats tables in UI
    output$data <- renderDT_formatted(filtered_data_frame)
    filtered_data_frame_stats <- get_stats(filtered_data_frame)
    output$data_stats <- renderDT_formatted(filtered_data_frame_stats, no_table_header = T)
    
    # return the filtered_data_frame
    filtered_data_frame
  }
} 

get_empty_data_frame <- function() {
  df <- data.frame(matrix(ncol = length(ALL_COLUMN_NAMES_LIST), nrow = 0))
  colnames(df) <- ALL_COLUMN_NAMES_LIST
  df
}

refresh_data_display <- function(output, selected_sub_tab, municipalities=list(), year=current_year) {
  # Refresh data frame filtered to selected municipalities and selected year
  result <- call_API_data_endpoint(municipalities = municipalities, year = year)

  if (result$success == "false") {
    data_frame <- get_empty_data_frame()
    showModal(modalDialog(
      title = "Failed to Get Data",
      result$error_message,
      easyClose = TRUE,
      footer = NULL))
  }
  else if (is.null(result$data) || length(result$data) == 0 || result$data == "[]") {
    data_frame <- get_empty_data_frame()
    showModal(modalDialog(
      title = "No Data Found For Selected Year and Selected Municipalities",
      result$error_message,
      easyClose = TRUE,
      footer = NULL))
  }
  else {
    data_frame <- result$data
  }
  
  data_frame <- convert_to_numeric(data_frame)

  filtered_data_frame <- filter_and_display(output, data_frame, selected_sub_tab)
  list(data_frame, filtered_data_frame)
}


#
# UI definition
#
ui <- uiOutput("ui")

#
# Server function sets up how the UI works
#
server <- function(input, output, session) {
  municipality_choices <- reactiveValues(all = list(), selected = list())

  #### UI code --------------------------------------------------------------
  output$ui <- renderUI({
    if (user_input$authenticated == FALSE) {
      ##### UI code for login page
      fluidPage(
        fluidRow(
          column(width = 2, offset = 5,
                 br(), br(), br(), br(),
                 uiOutput("uiLogin"),
                 uiOutput("pass")
          )
        )
      )
    } 
    else if (user_input$is_superuser) {
      #### App's UI code goes here!
      fluidPage(
        sidebarLayout(
          sidebarPanel(
            width = 2,
            selectInput(inputId = "municipalitySelector",
                        label="Custom Grouping",
                        choices = municipality_choices$all,
                        selected = municipality_choices$selected,
                        multiple = TRUE,
                        selectize = FALSE,
                        size = 10),
            
            selectInput(inputId = "data_display_year_selector",
                        label="Year",
                        choices = years_all_options,
                        selected = current_year,
                        selectize = TRUE),
            actionButton(inputId="saveUserSelectionButton", label ="Save"),
            
            # Horizontal line ----
            tags$hr(),
            
            selectInput(inputId = "data_load_year_selector",
                        label="Year for Data Import",
                        choices = years_all_options,
                        selected = current_year,
                        selectize = TRUE),

            # Input: Select a file ----
            fileInput(inputId = "load_file", "Choose Excel File",
                      multiple = FALSE,
                      accept = c("text/xls"))
          ),
          mainPanel(
            width = 10,
            # Generate the navigation menu
            # Create menu tabs using menu_tabs_text for titles
            # Create menu tab i it's subtabs use menu_sub_tabs_text[[i]] for titles
            do.call(navbarPage, c(title = "Data Sets", id='navbar_page', lapply(1:length(menu_sub_tabs_text), function(i) {
              do.call(navbarMenu, c(title = menu_tabs_text[[i]], lapply(1:length(menu_sub_tabs_text[[i]]), function(j) {
                tabPanel(menu_sub_tabs_text[[i]][j], menu_sub_tabs_text[[i]][j])
              })))
            }))),
            DTOutput("data"),
            DTOutput("data_stats"),
            downloadButton(export_filename, "Download")
            # actionButton(inputId="saveUserSelectionButton", label ="Save"),
            #  actionButton(inputId = "save", label = "Save"),
            
            # Output: Tabset w/ plot, summary, and table ----
            #          tabsetPanel(type = "tabs",
            #                      tabPanel("Data",
            #                        DTOutput("data"),
            #                        DTOutput("data_stats")
            #  actionButton(inputId="exportButton", label ="Export"),
            # Button
            #downloadButton(export_filename, "Download"),
            #                      ),
            #                      tabPanel("Summary", verbatimTextOutput("summary"))
            #          )
          )
        )
      )
    }
    else {
      #### App's UI code goes here!
      #### Not superuser
      fluidPage(
        selectInput(inputId = "municipalitySelector",
                    label="Custom Grouping",
                    choices = municipality_choices$all,
                    selected = municipality_choices$selected,
                    multiple = TRUE,
                    selectize = FALSE,
                    size = 10),
        
        selectInput(inputId = "data_display_year_selector",
                    label="Select Year for Data Display",
                    choices = years_all_options,
                    selected = current_year,
                    selectize = TRUE),
        
        tags$hr(),
        DTOutput("data"),
        DTOutput("data_stats"),
        downloadButton(export_filename, "Download"),
        
        # Main panel for displaying outputs ----
        mainPanel(
          do.call(navbarPage, c(title = "Datasets", id="navbar_page", lapply(1:length(menu_sub_tabs_text), function(i) {
            do.call(navbarMenu, c(title = menu_tabs_text[[i]], id = "tabs", lapply(1:length(menu_sub_tabs_text[[i]]), function(j) {
              tabPanel(menu_sub_tabs_text[[i]][j], menu_sub_tabs_text[[i]][j])
            })))
          })))
        )
      )
    }    
  })

  ################### APP SERVER CODE #####################################################

  # TODO: GRAPHS!!!!

  # Generate a summary of the data ----
  output$summary <- renderPrint({
    "Summary Test..."
  })


  #
  # UI event handling
  #
  # Loading data from file
  observeEvent(input$load_file, {
    filename = input$load_file$datapath
    sheet_names_read <- excel_sheet_names(filename)
    print(sheet_names_read)

    # We check for missing sheets.
    missing_sheets <- setdiff(data_set_names, sheet_names_read)

    if (length(missing_sheets) > 0) {
      err <- paste("Missing sheets in uploaded file: ", paste(data_set_names, collapse=", "))

      showModal(modalDialog(
        title = kErrorTitleFailedToLoadData,
        err,
        easyClose = TRUE,
        footer = NULL))

      return
    }

    # Check and log any new sheets but still continue to upload
    new_sheets <- setdiff(sheet_names_read, data_set_names)
    if (length(new_sheets) > 0) {
      info <- paste("New sheets in uploaded file: ", paste(new_sheets, collapse=", "))
      print(info)
    }

    # Read all data and send to API to save
    data_sheets <- read_excel_allsheets(filename)
    result <- call_API_data_endpoint(data_frames = data_sheets, year = input$data_load_year_selector)

    # TODO: Add error handling for the REST endpoint connection fails
    if (result$success == "true") {
      print("Data loading successful")
      
      # Refresh data frame filtered to selected municipalities and selected year
      # Store data_frame so that it's accessible to the observeEvent code that is triggered 
      # when another sub-tab is selected in the UI
      data_frames_list <- refresh_data_display(output, input$navbar_page, municipalities = input$municipalitySelector, year = input$data_display_year_selector)
      municipal_data$data_frame_all_columns <- data_frames_list[[1]]
      municipal_data$data_frame_filtered_columns <- data_frames_list[[2]]
    }
    else {
      # Handle error
      print("Data loading failed!")
      showModal(modalDialog(
        title = kErrorTitleFailedToLoadData,
        result$error_message,
        easyClose = TRUE,
        footer = NULL))
    }
  })

  municipal_data <- reactiveValues(data_frame_all_columns = NULL, data_frame_filtered_columns = NULL)
  
  # Municipality Selection
  observeEvent(input$municipalitySelector, {
    # Refresh data frame filtered to selected municipalities and selected year
    # Store data_frame so that it's accessible to the observeEvent code that is triggered 
    # when another sub-tab is selected in the UI
    data_frames_list <- refresh_data_display(output, input$navbar_page, municipalities = input$municipalitySelector, year = input$data_display_year_selector)
    municipal_data$data_frame_all_columns <- data_frames_list[[1]]
    municipal_data$data_frame_filtered_columns <- data_frames_list[[2]]
  })
  
  # Year Selection
  observeEvent(input$data_display_year_selector, {
    # Refresh data frame filtered to selected municipalities and selected year
    # Store data_frame so that it's accessible to the observeEvent code that is triggered 
    # when another sub-tab is selected in the UI
    data_frames_list <- refresh_data_display(output, input$navbar_page, municipalities = input$municipalitySelector, year = input$data_display_year_selector)
    municipal_data$data_frame_all_columns <- data_frames_list[[1]]
    municipal_data$data_frame_filtered_columns <- data_frames_list[[2]]
  })
 
  # Sub-tab/Dataset Selection 
  observeEvent(input$navbar_page, {
    selected_sub_tab <- input$navbar_page
    municipal_data$data_frame_filtered_columns <- filter_and_display(output, municipal_data$data_frame_all_columns, selected_sub_tab)
  })

  # Button to save currently selected municipalities
  observeEvent(input$saveUserSelectionButton, {
    tryCatch(
      # Call API to store the selected municipalities
      result <- call_API_municipalities_endpoint(method = httr::POST, municipalities=input$municipalitySelector),
      error = function(err) {
        showModal(modalDialog(
          title = "Failed to Save Settings",
          err,
          easyClose = TRUE,
          footer = NULL))
      }
    )

    if (result$success == "true") {
      showModal(modalDialog(
        title = "Successfully Saved Settings",
        easyClose = TRUE,
        footer = NULL))
    }
    else {
      showModal(modalDialog(
        title = "Failed to Save Settings",
        result$error_message,
        easyClose = TRUE,
        footer = NULL))
    }
  })

  # Datatable Export
  observeEvent(input$exportButton, {
    write_xlsx(data_frame, export_filename)

    showModal(modalDialog(
      title = paste("Exported to file: ", export_filename),
      easyClose = TRUE,
      footer = NULL))
  })

  # Data Load
  output$bmaExport.xls <- downloadHandler(
    filename = export_filename,
    contentType = "text/xls",
    content = function(file) {
      print(file)
      print(municipal_data$data_frame_filtered_columns)
      write_xlsx(municipal_data$data_frame_filtered_columns, file)
    }
  )

  #### PASSWORD server code ----------------------------------------------------
  # reactive value containing user's authentication status
  user_input <- reactiveValues(authenticated = FALSE, error_message = NULL, is_superuser = F)

  observeEvent(input$login_button, {
    login_result <- call_login_endpoint(input$user_name, input$password)

    if (login_result$success == "true") {
      user_input$authenticated <- TRUE
      user_input$is_superuser <- (login_result$is_superuser == 'TRUE')

      # Get full list of Municipalities
      result <- call_API_all_municipalities_endpoint(method = httr::GET)

      if (result$success == 'false') {
        showModal(modalDialog(
          title = "Failed to get full list of municipalities",
          result$error_message,
          easyClose = TRUE,
          footer = NULL))
        return
      }
    
      municipality_choices$all <- result$municipalities

      # Get municipalities subset preferred by current user
      result <- call_API_municipalities_endpoint(method = httr::GET)
      
      if (result$success == 'false') {
        showModal(modalDialog(
          title = "Failed to get your preferred list of municipalities",
          result$error_message,
          easyClose = TRUE,
          footer = NULL))
        return
      }
      
      municipality_choices$selected <- result$municipalities
    } 
    else {
      user_input$authenticated <- FALSE
      user_input$error_message <- login_result$error_message
    }
  })

  # password entry UI componenets:
  #   username and password text fields, login button
  output$uiLogin <- renderUI({
    wellPanel(
      textInput("user_name", "User Name:"),
      passwordInput("password", "Password:"),
      actionButton("login_button", "Log in")
    )
  })

  # error message if bad credentials
  output$pass <- renderUI({
    if (!is.null(user_input$error_message)) {
      h5(strong(paste0("Failed to login. Incorrect credentials.\n"), style = "color:red"), align = "center")
    } else {
      ""
    }
  })
}

# start our web app
shinyApp(ui = ui, server = server)