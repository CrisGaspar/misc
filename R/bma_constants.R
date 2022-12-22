# Convention: all constants start with 'k'

# Configuration
kApiUrl <- 'http://localhost:8000/bmaapp/'
kLoginEndpoint <- 'login'
kAllMunicipalitiesEndpoint <- 'all_municipalities'
kMunicipalityGroupsEndpoint <- 'municipality_groups'
kDataEndpoint <- 'data'
kDataByYearsEndpoint <- 'data_subset_by_years'

# Only Municipality column (1st one) is non-numeric
kNonNumericColumnsCount <- 1

# Errors
kErrorFailedToLoadData <- 'Failed to Load from Excel File'
kInfoNoMunicipalitySelection <- 'No Initial Municipality Selection'

# Defaults to most recent year we have data for
# TODO: Get it from API instead of hard-coded value
kMostRecentYear <- 2022L
# 2014 is the oldest year
kAllYears <- 2014L: kMostRecentYear

# R language does not have enums so have to use string consts instead
kPopulationGroup <- "Population"
kTierGroup <- "Tier"
kLocationGroup <- "Location"

# Labels and selectors
kAllMunicipalitiesLabel <- "All Municipalities"
kCustomMunicipalityGroupsLabel <- "Custom Groups"
kAllMunicipalitySelector <- "municipalitySelector"
kCustomMunicipalityGroupSelector <- "municipalityGroupSelector"

# Special sheet name used in more than 1 place hence made constant
kSheetNetExpendituresPerCapita <- "Net Expenditures per Capita"

# Tabs names: should be enum but R does not suport enums
kTabPopulation <- "Population"
kTabDensityLandArea <- "Density and Land Area"
kTabAssessmentInfo <- "Assessment Information"
kTabAssessmentComposition <- "Assessment Composition"
kTabBuildingPermitByYear <- "Building Permit Activity"
kTabTotalLevy <- "Total Levy"
kTabUpperTierLevy <- "Upper Tier Levy"
kTabLowerTierLevy <- "Lower Tier Levy"
kTabTaxAssetConsumptionRatio <- "Tax Asset Consumption Ratio"
kTabFinancialPositionPerCapita <- "Financial Position per Capita"
kTabTaxDisResPercentOSR <- "Tax Dis Res as Percent OSR"
kTabTaxReservesPercentTaxation <- "Tax Reserves as Percent of Taxation"
kTabTaxResPerCapita <- "Tax Res per Capita"
kTabTaxDebtIntPercentOSR <- "Tax Debt Int Percent OSR"
kTabTaxDebtChargesPercentOSR <- "Tax Debt Charges as Percent OSR"
kTabTotalTaxDebtOutPerCapita <- "Total Debt Out per Capita"
kTabTaxDebtOutPerCapita <- "Tax Debt Out per Capita"
kTabDebtToReserveRatio <- "Debt to Reserve Ratio"
kTabTaxReceivablePercentTax <- "Tax Receivable as Percent Tax"
kTabRatesCoverageRatio <- "Rates Coverage Ratio"
kTabNetFinLiabRatio <- "Net Fin Liab Ratio"
kTabDevelopmentCharges <- "Development Charges"
kTabBuildingPermitFees <- "Building Permit Fees"
kTabTaxRatios <- "Tax Ratios"
kTabOptionalClass <- "Optional Class"
kTabTotalTaxRates <- "Total Tax Rates"
kTabMunicipalTaxRates <- "Municipal Tax Rates"
kTabEducationalTaxRates <- "Education Tax Rates"
kTabResidential <- "Residential"
kTabMultiResidential <- "Multi-Residential"
kTabCommercial <- "Commercial"
kTabIndustrial <- "Industrial"
kTabWaterAndSewerCosts <- "Water and Sewer Costs"
kTabWaterAssetConsumption <- "Water Asset Consumption"
kTabWasterWaterAssetConsumption <- "Wastewater Asset Consumption"
kTabWaterResPercentOSR <- "Water Res as Percent OSR"
kTabWasteWaterResPercentOSR <- "Wastewater Res as Percent OSR"
kTabWaterResPercentAcumAmort <- "Water Res as Percent Acum Amort"
kTabWasteWaterResPercentAcumAmort <- "Wastewater Res as Percent Acum Amort"
kTabWaterDebtIntCover <- "Water Debt Int Cover"
kTabWasteWaterDebtIntCover <- "Wastewater Debt Int Cover"
kTabWaterNetFinLiab <- "Water Net Fin Liab"
kTabWasteWaterNetFinLiab <- "Wastewater Net Fin Liab"
kTabAvgHouseholdIncome <- "Average Household Income"
kTabAvgValueDwelling <- "Average Value of Dwelling"
kTabCombinedCosts <- "Combined costs"
kTabTaxesPercentIncome <- "Taxes as a Percent of Income"
kTabNetExpendituresPerCapitaFireServices = 'Fire Services'
kTabNetExpendituresPerCapitaRoadsPaved = 'Roadways - Paved'
kTabNetExpendituresPerCapitaBridgesCulverts = 'Roadways - Bridges and Culverts'
kTabNetExpendituresPerCapitaTraffic = 'Roadways - Traffic Control'
kTabNetExpendituresPerCapitaWinterRoads = 'Winter Control - Roads'
kTabNetExpendituresPerCapitaWinterSidewalks = 'Winter Control - Sidewalks'
kTabNetExpendituresPerCapitaTransit = 'Transit Services'
kTabNetExpendituresPerCapitaParking = 'Parking'
kTabNetExpendituresPerCapitaWasteCollection = 'Waste Collection'
kTabNetExpendituresPerCapitaWasteDisposal = 'Waste Disposal'
kTabNetExpendituresPerCapitaStormUrban = 'Storm Sewer - Urban'
kTabNetExpendituresPerCapitaPublicHealth = 'Public Health'
kTabNetExpendituresPerCapitaEmmergencyMeasures = 'Emergency Measures'
kTabNetExpendituresPerCapitaGeneralAssistance = 'General Assistance'
kTabNetExpendituresPerCapitaAssistanceAged = 'Assistance to the Aged'
kTabNetExpendituresPerCapitaChildCare = 'Child Care'
kTabNetExpendituresPerCapitaSocialHousing = 'Social Housing'
kTabNetExpendituresPerCapitaParks = 'Parks'
kTabNetExpendituresPerCapitaRecPrograms = 'Rec Programs'
kTabNetExpendituresPerCapitaGolfMarinaSkiHill = 'Golf, Marina, Ski Hill'
kTabNetExpendituresPerCapitaRecFacilitiesOther = 'Rec Facilities Other'
kTabNetExpendituresPerCapitaLibrary = 'Library'
kTabNetExpendituresPerCapitaMuseums = 'Museums'
kTabNetExpendituresPerCapitaCultural = 'Cultural Services'
kTabNetExpendituresPerCapitaPlanning = 'Planning'
kTabNetExpendituresPerCapitaCommercialIndustrial = 'Commercial and Industrial'
kTabNetExpendituresPerCapitaGeneralGovernment = 'General Government'
kTabNetExpendituresPerCapitaConservationAuthority = 'Conservation Authority'
kTabNetExpendituresPerCapitaAmbulance = 'Ambulance Services'
kTabNetExpendituresPerCapitaCemeteries = 'Cemeteries'
kTabNetExpendituresPerCapitaAgriAndReforestation = 'Agriculture and reforestation'

kTabNetExpendituresPerCapitaCourtSecurity = 'Court Security'
kTabNetExpendituresPerCapitaPolice = 'Police'
kTabNetExpendituresPerCapitaPrisonerTransport = 'Prisoner Transport'
kTabNetExpendituresPerCapitaProtectiveInspectionAndControl = 'Protective Inspection and Control'
kTabNetExpendituresPerCapitaProvincialOffencesAct = 'Provincial Offences Act'
kTabNetExpendituresPerCapitaRoadsUnpaved = 'Roads Unpaved'
kTabNetExpendituresPerCapitaTransitDisabled = 'Transit Services - Disabled'
kTabNetExpendituresPerCapitaStreetLighting = 'Street Lighting'
kTabNetExpendituresPerCapitaAirTransportation = 'Air Transportation'
kTabNetExpendituresPerCapitaStormSewerRural = 'Storm Sewer - Rural'
kTabNetExpendituresPerCapitaSolidWasteDiversion = 'Solid Waste Diversion'
kTabNetExpendituresPerCapitaHospitals = 'Hospitals'
kTabNetExpendituresPerCapitaCovidExpenses = 'Covid Expenses'
kTabNetExpendituresPerCapitaBldgPermitsInspectionServices = 'Building permits and inspection services'

# Column names
COLUMN_NAME_MUNICIPALITY = 'Municipality'
COLUMN_NAME_POPULATION = 'Population'
COLUMN_NAME_POPULATION_DENSITY = 'Population Density per sq. km.'
COLUMN_NAME_ANNUAL_POPULATION_INCREASE = 'Annual Population Increase'
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
COLUMN_NAME_TAX_RESERVES_PERCENT_TAXATION = 'Tax Reserves (less WWW) as % of Taxation'
COLUMN_NAME_TAX_RESERVE_PER_CAPITA = 'Tax Reserves / Capita'
COLUMN_NAME_TAX_DEBT_INT_PERCENT_OSR = 'Tax Debt Int as % OSR'
COLUMN_NAME_TAXR_DEBT_CHARGES_PERCENT_OSR = 'Total Debt Charges (less WWW) as % of Own Source Revenues'
COLUMN_NAME_TOTAL_DEBT_OUTSTANDING_PER_CAPITA = 'Total Debt Outstanding / Capita'
COLUMN_NAME_TAX_DEBT_OUTSTANDING_PER_CAPITA = 'Total Debt Outstanding (less WWW) / Capita'
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
COLUMN_NAME_INDUSTRIAL_LARGE = 'Large Industrial'
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
COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN = 'Total Municipal Tax Burden'
COLUMN_NAME_PROPERTY_TAXES_PERCENT_HOUSEHOLD_INCOME = 'Property Taxes as a % of Household Income'
COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN_PERCENT_HOUSEHOLD_INCOME = 'Total Municipal Burden as a % of Household Income'

# Columns for Net Expenditures per Capita
COLUMN_NAME_FIRE = 'Fire'
COLUMN_NAME_ROADS_PAVED = 'Roads Paved'
COLUMN_NAME_BRIDGES_CULVERTS = 'Bridges and Culverts'
COLUMN_NAME_PARKING = 'Parking'
COLUMN_NAME_WASTE_COLLECTION = 'Waste Collection'
COLUMN_NAME_WASTE_DISPOSAL = 'Waste Disposal'
COLUMN_NAME_PUBLIC_HEALTH = 'Public Health'
COLUMN_NAME_EMERGENCY_MEASURES = 'Emergency Measures'
COLUMN_NAME_GENERAL_ASSISTANCE = 'General Assistance'
COLUMN_NAME_ASSISTANCE_AGED = 'Assistance to the Aged'
COLUMN_NAME_CHILD_CARE = 'Child Care'
COLUMN_NAME_SOCIAL_HOUSING = 'Social Housing'
COLUMN_NAME_PARKS = 'Parks'
COLUMN_NAME_RECREATION_PROGRAMS = 'Recreation Programs'
COLUMN_NAME_REC_FACILITIES_OTHER = 'Rec Facilities Other'
COLUMN_NAME_LIBRARY = 'Library'
COLUMN_NAME_MUSEUMS = 'Museums'
COLUMN_NAME_CULTURAL = 'Cultural'
COLUMN_NAME_PLANNING = 'Planning'
COLUMN_NAME_GENERAL_GOVERNMENT = 'General Government'
COLUMN_NAME_CONSERVATION_AUTHORITY = 'Conservation Authority'
COLUMN_NAME_CEMETERIES = 'Cemeteries'
COLUMN_NAME_AGRICULTURE_AND_REFORESTATION = 'Agriculture and reforestation'

COLUMN_NAME_COURT_SECURITY = 'Court Security'
COLUMN_NAME_POLICE = 'Police'
COLUMN_NAME_PRISONER_TRANSPORT = 'Prisoner Transport' 
COLUMN_NAME_PROTECTIVE_INSPECTION_AND_CONTROL = 'Protective Inspection and Control'
COLUMN_NAME_PROVINCIAL_OFFENCES_ACT = 'Provincial Offences Act'
COLUMN_NAME_ROADS_UNPAVED = 'Roads Unpaved'
COLUMN_NAME_TRAFFIC_OPERATIONS = 'Traffic Operations'
COLUMN_NAME_WINTER_CONTROL_EXCEPT_SIDEWALKS = 'Winter Control Except Sidewalks'
COLUMN_NAME_WINTER_CONTROL_SIDEWALKS_PARKING_LOTS = 'Winter Control Sidewalks, Parking Lots'
COLUMN_NAME_TRANSIT_SERVICES_CONVENTIONAL = 'Transit Services - Conventional'
COLUMN_NAME_TRANSIT_SERVICES_DISABLED = 'Transit Services - Disabled'
COLUMN_NAME_STREET_LIGHTING = 'Street Lighting'
COLUMN_NAME_AIR_TRANSPORTATION = 'Air Transportation'
COLUMN_NAME_STORM_SEWER_URBAN = 'Storm Sewer - Urban'
COLUMN_NAME_STORM_SEWER_RURAL = 'Storm Sewer - Rural'
COLUMN_NAME_SOLID_WASTE_DIVERSION = 'Solid Waste Diversion'
COLUMN_NAME_HOSPITALS = 'Hospitals'
COLUMN_NAME_AMBULANCE_SERVICES = 'Ambulance Services'
COLUMN_NAME_COVID_EXPENSES = 'Covid Expenses'
COLUMN_NAME_GOLF_MARINA_SKI_HILL = 'Golf, Marina, Ski Hill'
COLUMN_NAME_COMMERCIAL_AND_INDUSTRIAL = 'Commercial & Industrial'
COLUMN_NAME_BUILDING_PERMITS_INSPECTION_SERVICES = 'Building permits and inspection services'


# Mapping from menu items (sheets in source excel data file) to corresponding tabs
menu_sub_tabs_text <- list(
  "Socio Economic Indicators" = list(kTabPopulation, kTabDensityLandArea, kTabAssessmentInfo, 
                                     kTabAssessmentComposition, kTabBuildingPermitByYear),
  
  "Municipal Financial Indicators" = list(kTabTotalLevy, kTabUpperTierLevy, kTabLowerTierLevy, kTabTaxAssetConsumptionRatio, kTabFinancialPositionPerCapita,
       kTabTaxDisResPercentOSR, kTabTaxReservesPercentTaxation, kTabTaxResPerCapita, kTabTaxDebtIntPercentOSR,
       kTabTaxDebtChargesPercentOSR, kTabTotalTaxDebtOutPerCapita, kTabTaxDebtOutPerCapita, kTabDebtToReserveRatio,
       kTabTaxReceivablePercentTax, kTabRatesCoverageRatio, kTabNetFinLiabRatio),
  
  "Select User Fee Information" = list(kTabDevelopmentCharges, kTabBuildingPermitFees),
  
  "Tax Policies" = list(kTabTaxRatios, kTabOptionalClass),
  
  "Comparison of Relative Taxes" = list(kTabTotalTaxRates, kTabMunicipalTaxRates, kTabEducationalTaxRates, kTabResidential, kTabMultiResidential,
       kTabCommercial, kTabIndustrial),
  
  "Comparison of Water & Sewer Costs" = list(kTabWaterAndSewerCosts, kTabWaterAssetConsumption, kTabWasterWaterAssetConsumption, kTabWaterResPercentOSR,
       kTabWasteWaterResPercentOSR, kTabWaterResPercentAcumAmort, kTabWasteWaterResPercentAcumAmort, kTabWaterDebtIntCover,
       kTabWasteWaterDebtIntCover, kTabWaterNetFinLiab, kTabWasteWaterNetFinLiab),
  
  "Taxes as a % of Income" = list(kTabAvgHouseholdIncome, kTabAvgValueDwelling, kTabCombinedCosts, kTabTaxesPercentIncome)
)

# Separately set the mapping for Net Expenditures Per Capita
menu_sub_tabs_text[[kSheetNetExpendituresPerCapita]] = list(
    kTabNetExpendituresPerCapitaFireServices, kTabNetExpendituresPerCapitaRoadsPaved, kTabNetExpendituresPerCapitaBridgesCulverts, 
    kTabNetExpendituresPerCapitaTraffic, kTabNetExpendituresPerCapitaWinterRoads, kTabNetExpendituresPerCapitaWinterSidewalks, 
    kTabNetExpendituresPerCapitaTransit, kTabNetExpendituresPerCapitaParking, kTabNetExpendituresPerCapitaWasteCollection, 
    kTabNetExpendituresPerCapitaWasteDisposal, kTabNetExpendituresPerCapitaStormUrban, 
    kTabNetExpendituresPerCapitaPublicHealth, kTabNetExpendituresPerCapitaEmmergencyMeasures, kTabNetExpendituresPerCapitaGeneralAssistance,
    kTabNetExpendituresPerCapitaAssistanceAged, kTabNetExpendituresPerCapitaChildCare, 
    kTabNetExpendituresPerCapitaSocialHousing, kTabNetExpendituresPerCapitaParks, kTabNetExpendituresPerCapitaRecPrograms, 
    kTabNetExpendituresPerCapitaGolfMarinaSkiHill, kTabNetExpendituresPerCapitaRecFacilitiesOther, kTabNetExpendituresPerCapitaLibrary, 
    kTabNetExpendituresPerCapitaMuseums, kTabNetExpendituresPerCapitaCultural, kTabNetExpendituresPerCapitaPlanning, 
    kTabNetExpendituresPerCapitaCommercialIndustrial, kTabNetExpendituresPerCapitaGeneralGovernment, kTabNetExpendituresPerCapitaConservationAuthority, 
    kTabNetExpendituresPerCapitaAmbulance, kTabNetExpendituresPerCapitaCemeteries, kTabNetExpendituresPerCapitaAgriAndReforestation,
    kTabNetExpendituresPerCapitaCourtSecurity, kTabNetExpendituresPerCapitaPolice, kTabNetExpendituresPerCapitaPrisonerTransport,
    kTabNetExpendituresPerCapitaProtectiveInspectionAndControl, kTabNetExpendituresPerCapitaProvincialOffencesAct, kTabNetExpendituresPerCapitaRoadsUnpaved,
    kTabNetExpendituresPerCapitaTransitDisabled, kTabNetExpendituresPerCapitaStreetLighting, kTabNetExpendituresPerCapitaAirTransportation,
    kTabNetExpendituresPerCapitaStormSewerRural, kTabNetExpendituresPerCapitaSolidWasteDiversion, kTabNetExpendituresPerCapitaHospitals,
    kTabNetExpendituresPerCapitaCovidExpenses, kTabNetExpendituresPerCapitaBldgPermitsInspectionServices)


# Initialize list of expected sheets
kExpectedSheets <- list.flatten(menu_sub_tabs_text)

# For these sheets API returns 'Percent' so we must replace that by '%' when displaying in the app
kSheetsPercent <-list(kTabTaxDisResPercentOSR, kTabTaxReservesPercentTaxation, kTabTaxDebtIntPercentOSR, 
                      kTabTaxDebtChargesPercentOSR, kTabTaxReceivablePercentTax, kTabWaterResPercentOSR, 
                      kTabWasteWaterResPercentOSR, kTabWaterResPercentAcumAmort, kTabWasteWaterResPercentAcumAmort, 
                      kTabTaxesPercentIncome)

# Replace '%' in sheet names with 'Percent' for display in the app
kSheetsPercentUpdatedForDisplay <- lapply(kSheetsPercent, function(str) {
  sub("Percent", "%", str)
})

# Replace '&' in sheet names with 'and' for display in app
kSheetsAnd <- list(kTabWaterAndSewerCosts)
kSheetsAndUpdatedForDisplay <- lapply(kSheetsAnd, function(str) {
  sub(" and ", "&", str)
})

# Final list of expected sheets: add the sheets with modified display name, subtract the original corresponding ones, 
# and for Net Expenditures Per Capita enfore 1 single sheet as per source data Excel file
kExpectedSheets <- unique(setdiff(
  list.flatten(list.append(kExpectedSheets, kSheetsPercentUpdatedForDisplay, kSheetsAndUpdatedForDisplay, kSheetNetExpendituresPerCapita)), 
  list.flatten(list.append(kSheetsPercent, kSheetsAnd, menu_sub_tabs_text[[kSheetNetExpendituresPerCapita]])))
)

# Mapping of tab to column names for that tab
column_names_per_sub_tab_selection <- list()
column_names_per_sub_tab_selection[[kTabPopulation]] = list(
  COLUMN_NAME_POPULATION_DENSITY, COLUMN_NAME_ANNUAL_POPULATION_INCREASE, COLUMN_NAME_WEIGHTED_MEDIAN_VAL_DWELLING, COLUMN_NAME_UNWEIGHTED_ASSESSMENT_PER_CAPITA, 
  COLUMN_NAME_WEIGHTED_ASSESSMENT_PER_CAPITA)
column_names_per_sub_tab_selection[[kTabDensityLandArea]] = list(COLUMN_NAME_POPULATION_DENSITY, COLUMN_NAME_LAND_AREA)
column_names_per_sub_tab_selection[[kTabAssessmentInfo]] = list(
  COLUMN_NAME_TOTAL_UNWEIGHTED_ASSESSMENT, COLUMN_NAME_TOTAL_WEIGHTED_ASSESSMENT, COLUMN_NAME_UNWEIGHTED_ASSESSMENT_PER_CAPITA, 
  COLUMN_NAME_WEIGHTED_ASSESSMENT_PER_CAPITA)
column_names_per_sub_tab_selection[[kTabAssessmentComposition]] = list(
  COLUMN_NAME_RESIDENTIAL, COLUMN_NAME_MULTI_RESIDENTIAL, COLUMN_NAME_COMMERCIAL, COLUMN_NAME_INDUSTRIAL, COLUMN_NAME_PIPELINES, COLUMN_NAME_FARMLANDS, 
  COLUMN_NAME_FORESTS, COLUMN_NAME_LANDFILL)
column_names_per_sub_tab_selection[[kTabTotalLevy]] = list(COLUMN_NAME_TOTAL_NET_LEVY, COLUMN_NAME_LEVY_PER_CAPITA)
column_names_per_sub_tab_selection[[kTabUpperTierLevy]] = list(COLUMN_NAME_UPPER_TIER_LEVY, COLUMN_NAME_UPPER_TIER_LEVY_PER_CAPITA)
column_names_per_sub_tab_selection[[kTabLowerTierLevy]] = list(COLUMN_NAME_LOWER_TIER_LEVY, COLUMN_NAME_LOWER_TIER_LEVY_PER_CAPITA)
column_names_per_sub_tab_selection[[kTabTaxAssetConsumptionRatio]] = list(COLUMN_NAME_TAX_ASSET_CONSUMPTION_RATIO)
column_names_per_sub_tab_selection[[kTabFinancialPositionPerCapita]] = list(COLUMN_NAME_FINANCIAL_POSITION_PER_CAPITA)
column_names_per_sub_tab_selection[[kTabTaxDisResPercentOSR]] = list(COLUMN_NAME_TAX_DISCRETIONARY_RESERVES_PERCENT_SOURCE_REVENUES)
column_names_per_sub_tab_selection[[kTabTaxReservesPercentTaxation]] = list(COLUMN_NAME_TAX_RESERVES_PERCENT_TAXATION)
column_names_per_sub_tab_selection[[kTabTaxResPerCapita]] = list(COLUMN_NAME_TAX_RESERVE_PER_CAPITA)
column_names_per_sub_tab_selection[[kTabTaxDebtIntPercentOSR]] = list(COLUMN_NAME_TAX_DEBT_INT_PERCENT_OSR)
column_names_per_sub_tab_selection[[kTabTaxDebtChargesPercentOSR]] = list(COLUMN_NAME_TAXR_DEBT_CHARGES_PERCENT_OSR)
column_names_per_sub_tab_selection[[kTabTotalTaxDebtOutPerCapita]] = list(COLUMN_NAME_TOTAL_DEBT_OUTSTANDING_PER_CAPITA)
column_names_per_sub_tab_selection[[kTabTaxDebtOutPerCapita]] = list(COLUMN_NAME_TAX_DEBT_OUTSTANDING_PER_CAPITA)
column_names_per_sub_tab_selection[[kTabDebtToReserveRatio]] = list(COLUMN_NAME_DEBT_TO_RESERVE_RATIO)
column_names_per_sub_tab_selection[[kTabTaxReceivablePercentTax]] = list(COLUMN_NAME_TAXES_RECEIVABLE_PERCENT_TAXES_LEVIED)
column_names_per_sub_tab_selection[[kTabRatesCoverageRatio]] = list(COLUMN_NAME_RATES_COVERAGE_RATIO)
column_names_per_sub_tab_selection[[kTabNetFinLiabRatio]] = list(COLUMN_NAME_NET_FINANCIAL_LIABILITIES_RATIO)
column_names_per_sub_tab_selection[[kTabDevelopmentCharges]] = list(
  COLUMN_NAME_SINGLE_DETACHED_DWELLINGS_PER_UNIT, COLUMN_NAME_MULTIPLES_DWELLING__3_OR_MORE, COLUMN_NAME_MULTIPLES_DWELLING_1_OR_2, 
  COLUMN_NAME_APARTMENT_UNITS_2_OR_MORE, COLUMN_NAME_APARTMENT_UNITS_LESS_THAN_2, COLUMN_NAME_NON_RESIDENTIAL_COMMERCIAL_PER_SQFT, 
  COLUMN_NAME_NON_RESIDENTIAL_INDUSTRIAL_PER_SQFT)
column_names_per_sub_tab_selection[[kTabBuildingPermitFees]] = list(COLUMN_NAME_BUILDING_PERMIT_FEE)
column_names_per_sub_tab_selection[[kTabTaxRatios]] = list(
  COLUMN_NAME_TAX_RATIOS_MULTI_RESIDENTIAL, COLUMN_NAME_TAX_RATIOS_COMMERCIAL_RESIDUAL, COLUMN_NAME_TAX_RATIOS_INDUSTRIAL_RESIDUAL)
column_names_per_sub_tab_selection[[kTabOptionalClass]] = list(
  COLUMN_NAME_NEW_MULTI_RESIDENTIAL, COLUMN_NAME_COMMERCIAL_OFFICE, COLUMN_NAME_COMMERCIAL_SHOPPING, COLUMN_NAME_COMMERCIAL_PARKING, COLUMN_NAME_INDUSTRIAL_LARGE)
column_names_per_sub_tab_selection[[kTabTotalTaxRates]] = list(
  COLUMN_NAME_TOTAL_RESID, COLUMN_NAME_TOTAL_MULTI_RESID, COLUMN_NAME_TOTAL_COMMERCIAL_RESIDUAL, COLUMN_NAME_TOTAL_COMMERCIAL_OFFICE, 
  COLUMN_NAME_TOTAL_COMMERCIAL_PARK_VAC, COLUMN_NAME_TOTAL_COMMERCIAL_SHOPPING, COLUMN_NAME_TOTAL_INDUSTRIAL_RESIDUAL, COLUMN_NAME_TOTAL_INDUSTRIAL_LARGE)
column_names_per_sub_tab_selection[[kTabMunicipalTaxRates]] = list(
  COLUMN_NAME_MUNICIPAL_RESID, COLUMN_NAME_MUNICIPAL_MULTI_RESID, COLUMN_NAME_MUNICIPAL_COMM_RESIDUAL, COLUMN_NAME_MUNICIPAL_COMM_OFFICE, 
  COLUMN_NAME_MUNICIPAL_COMMERCIAL_PARK_VAC, COLUMN_NAME_MUNICIPAL_COMM_SHOPPING, COLUMN_NAME_MUNICIPAL_IND_RESIDUAL, COLUMN_NAME_MUNICIPAL_IND_LARGE)
column_names_per_sub_tab_selection[[kTabEducationalTaxRates]] = list(
  COLUMN_NAME_EDUCATION_RESID, COLUMN_NAME_EDUCATION_MULTI_RESID, COLUMN_NAME_EDUCATION_COMM_RESIDUAL, COLUMN_NAME_EDUCATION_COMM_OFFICE, 
  COLUMN_NAME_EDUCATION_COMMERCIAL_PARK_VAC, COLUMN_NAME_EDUCATION_COMM_SHOPPING, COLUMN_NAME_EDUCATION_IND_RESIDUAL, COLUMN_NAME_EDUCATION_IND_LARGE)
column_names_per_sub_tab_selection[[kTabResidential]] = list(COLUMN_NAME_BUNGALOW, COLUMN_NAME_2_STOREY, COLUMN_NAME_EXECUTIVE)
column_names_per_sub_tab_selection[[kTabMultiResidential]] = list(COLUMN_NAME_MULTI_RES_WALK_UP, COLUMN_NAME_MULTI_RES_HIGH_RISE)
column_names_per_sub_tab_selection[[kTabCommercial]] = list(COLUMN_NAME_TAX_SHOPPING, COLUMN_NAME_TAX_HOTEL, COLUMN_NAME_TAX_MOTEL, COLUMN_NAME_TAX_OFFICE)
column_names_per_sub_tab_selection[[kTabIndustrial]] = list(COLUMN_NAME_TAX_IND_STANDARD, COLUMN_NAME_TAX_IND_LARGE, COLUMN_NAME_TAX_IND_VACANT)
column_names_per_sub_tab_selection[[kTabWaterAndSewerCosts]] = list(
  COLUMN_NAME_RESIDENTIAL_200_M3, COLUMN_NAME_COMMERCIAL_10K_M3, COLUMN_NAME_INDUSTRIAL_30K_M3, COLUMN_NAME_INDUSTRIAL_100K_M3, COLUMN_NAME_INDUSTRIAL_500K_M3)
column_names_per_sub_tab_selection[[kTabWaterAssetConsumption]] = list(COLUMN_NAME_WATER_ASSET_CONSUMPTION)
column_names_per_sub_tab_selection[[kTabWasterWaterAssetConsumption]] = list(COLUMN_NAME_WW_ASSET_CONSUMPTION)
column_names_per_sub_tab_selection[[kTabWaterResPercentOSR]] = list(COLUMN_NAME_WATER_RES_PERCENT_OSR)
column_names_per_sub_tab_selection[[kTabWasteWaterResPercentOSR]] = list(COLUMN_NAME_WW_RES_PERCENT_OSR)
column_names_per_sub_tab_selection[[kTabWaterResPercentAcumAmort]] = list(COLUMN_NAME_WATER_RES_PERCENT_ACUM_AMORT)
column_names_per_sub_tab_selection[[kTabWasteWaterResPercentAcumAmort]] = list(COLUMN_NAME_WW_RES_PERCENT_ACUM_AMORT)
column_names_per_sub_tab_selection[[kTabWaterDebtIntCover]] = list(COLUMN_NAME_WATER_DEBT_INTEREST_COVERAGE)
column_names_per_sub_tab_selection[[kTabWasteWaterDebtIntCover]] = list(COLUMN_NAME_WW_DEBT_INTEREST_COVERAGE)
column_names_per_sub_tab_selection[[kTabWaterNetFinLiab]] = list(COLUMN_NAME_WATER_NET_LIN_LIAB)
column_names_per_sub_tab_selection[[kTabWasteWaterNetFinLiab]] = list(COLUMN_NAME_WW_NET_LIN_LIAB)
column_names_per_sub_tab_selection[[kTabAvgHouseholdIncome]] = list(COLUMN_NAME_EST_AVG_HOUSEHOLD_INCOME)
column_names_per_sub_tab_selection[[kTabAvgValueDwelling]] = list(COLUMN_NAME_WEIGHTED_MEDIAN_VAL_DWELLING)
column_names_per_sub_tab_selection[[kTabCombinedCosts]] = list(COLUMN_NAME_RESIDENTIAL_WATER_SEWER_COSTS, COLUMN_NAME_AVG_RESIDENTIAL_TAXES, COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN)
column_names_per_sub_tab_selection[[kTabTaxesPercentIncome]] = list(
  COLUMN_NAME_AVG_RESIDENTIAL_TAXES, COLUMN_NAME_PROPERTY_TAXES_PERCENT_HOUSEHOLD_INCOME, COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN, 
  COLUMN_NAME_TOTAL_MUNICIPAL_BURDEN_PERCENT_HOUSEHOLD_INCOME)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaFireServices]] = list(COLUMN_NAME_FIRE)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaRoadsPaved]] = list(COLUMN_NAME_ROADS_PAVED) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaBridgesCulverts]] = list(COLUMN_NAME_BRIDGES_CULVERTS) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaTraffic]] = list(COLUMN_NAME_TRAFFIC_OPERATIONS)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaWinterRoads]] = list(COLUMN_NAME_WINTER_CONTROL_EXCEPT_SIDEWALKS) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaWinterSidewalks]] = list(COLUMN_NAME_WINTER_CONTROL_SIDEWALKS_PARKING_LOTS) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaTransit]] = list(COLUMN_NAME_TRANSIT_SERVICES_CONVENTIONAL) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaParking]] = list(COLUMN_NAME_PARKING)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaWasteCollection]] = list(COLUMN_NAME_WASTE_COLLECTION) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaWasteDisposal]] = list(COLUMN_NAME_WASTE_DISPOSAL) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaStormUrban]] = list(COLUMN_NAME_STORM_SEWER_URBAN)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaPublicHealth]] = list(COLUMN_NAME_PUBLIC_HEALTH) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaEmmergencyMeasures]] = list(COLUMN_NAME_EMERGENCY_MEASURES) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaGeneralAssistance]] = list(COLUMN_NAME_GENERAL_ASSISTANCE)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaAssistanceAged]] = list(COLUMN_NAME_ASSISTANCE_AGED) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaChildCare]] = list(COLUMN_NAME_CHILD_CARE) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaSocialHousing]] = list(COLUMN_NAME_SOCIAL_HOUSING)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaParks]] = list(COLUMN_NAME_PARKS) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaRecPrograms]] = list(COLUMN_NAME_RECREATION_PROGRAMS) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaGolfMarinaSkiHill]] = list(COLUMN_NAME_GOLF_MARINA_SKI_HILL) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaRecFacilitiesOther]] = list(COLUMN_NAME_REC_FACILITIES_OTHER)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaLibrary]] = list(COLUMN_NAME_LIBRARY) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaMuseums]] = list(COLUMN_NAME_MUSEUMS) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaCultural]] = list(COLUMN_NAME_CULTURAL) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaPlanning]] = list(COLUMN_NAME_PLANNING) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaCommercialIndustrial]] = list(COLUMN_NAME_COMMERCIAL_AND_INDUSTRIAL)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaGeneralGovernment]] = list(COLUMN_NAME_GENERAL_GOVERNMENT) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaConservationAuthority]] = list(COLUMN_NAME_CONSERVATION_AUTHORITY) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaAmbulance]] = list(COLUMN_NAME_AMBULANCE_SERVICES) 
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaCemeteries]] = list(COLUMN_NAME_CEMETERIES)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaAgriAndReforestation]] = list(COLUMN_NAME_AGRICULTURE_AND_REFORESTATION)

column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaCourtSecurity]] = list(COLUMN_NAME_COURT_SECURITY)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaPolice]] = list(COLUMN_NAME_POLICE)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaPrisonerTransport]] = list(COLUMN_NAME_PRISONER_TRANSPORT)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaProtectiveInspectionAndControl]] = list(COLUMN_NAME_PROTECTIVE_INSPECTION_AND_CONTROL)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaProvincialOffencesAct]] = list(COLUMN_NAME_PROVINCIAL_OFFENCES_ACT)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaRoadsUnpaved]] = list(COLUMN_NAME_ROADS_UNPAVED)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaTransitDisabled]] = list(COLUMN_NAME_TRANSIT_SERVICES_DISABLED)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaStreetLighting]] = list(COLUMN_NAME_STREET_LIGHTING)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaAirTransportation]] = list(COLUMN_NAME_AIR_TRANSPORTATION)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaStormSewerRural]] = list(COLUMN_NAME_STORM_SEWER_RURAL)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaSolidWasteDiversion]] = list(COLUMN_NAME_SOLID_WASTE_DIVERSION)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaHospitals]] = list(COLUMN_NAME_HOSPITALS)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaCovidExpenses]] = list(COLUMN_NAME_COVID_EXPENSES)
column_names_per_sub_tab_selection[[kTabNetExpendituresPerCapitaBldgPermitsInspectionServices]] = list(COLUMN_NAME_BUILDING_PERMITS_INSPECTION_SERVICES)

# List of all column names: add Municipality column which is the only non-number column
ALL_COLUMN_NAMES_LIST <- unique(append(list(COLUMN_NAME_MUNICIPALITY),
                                       list.flatten(column_names_per_sub_tab_selection)))

# Different formats used when displaying column values in app
FORMAT_SETTINGS_CURRENCY_DEFAULT = list("SYMBOL" = "$", "SEPARATOR" = ",", "DECIMALS" = 0)
FORMAT_SETTINGS_CURRENCY_2_DECIMALS = list("SYMBOL" = "$", "SEPARATOR" = ",", "DECIMALS" = 2)
FORMAT_SETTINGS_COUNTER = list("SYMBOL" = "", "SEPARATOR" = ",", "DECIMALS" = 0)
FORMAT_SETTINGS_NUMBER_1_DECIMAL = list("SYMBOL" = "", "SEPARATOR" = ",", "DECIMALS" = 0)
FORMAT_SETTINGS_PERCENT_1_DECIMAL = list("SYMBOL" = "%", "SEPARATOR" = ",", "DECIMALS" = 1)
FORMAT_SETTINGS_PERCENT_2_DECIMALS = list("SYMBOL" = "%", "SEPARATOR" = ",", "DECIMALS" = 2)
FORMAT_SETTINGS_PERCENT_4_DECIMALS = list("SYMBOL" = "%", "SEPARATOR" = ",", "DECIMALS" = 4)
FORMAT_SETTINGS_PERCENT_6_DECIMALS = list("SYMBOL" = "%", "SEPARATOR" = ",", "DECIMALS" = 6)

#
# Column values display formats
#

# No-format-change-needed columns
AS_IS_DISPLAY_COLUMNS = list(COLUMN_NAME_MUNICIPALITY)

# Integer (no decimals) columns
COLUMNS_COUNTER = c(COLUMN_NAME_POPULATION, COLUMN_NAME_POPULATION_DENSITY, COLUMN_NAME_LAND_AREA)

# Columns with numbers with various number of decimals
kColumnsNumber1Decimal = c(COLUMN_NAME_WATER_NET_LIN_LIAB, COLUMN_NAME_WW_NET_LIN_LIAB)

COLUMNS_PERCENT_2_DECIMALS = c(COLUMN_NAME_ANNUAL_POPULATION_INCREASE, COLUMN_NAME_RESIDENTIAL, COLUMN_NAME_MULTI_RESIDENTIAL, COLUMN_NAME_COMMERCIAL, 
                               COLUMN_NAME_INDUSTRIAL, COLUMN_NAME_PIPELINES, COLUMN_NAME_FARMLANDS, COLUMN_NAME_FORESTS, COLUMN_NAME_LANDFILL, COLUMN_NAME_TAX_ASSET_CONSUMPTION_RATIO,
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

COLUMNS_PERCENT_6_DECIMALS = c(COLUMN_NAME_TOTAL_RESID, COLUMN_NAME_TOTAL_MULTI_RESID, COLUMN_NAME_TOTAL_COMMERCIAL_RESIDUAL, COLUMN_NAME_TOTAL_COMMERCIAL_OFFICE, 
                               COLUMN_NAME_TOTAL_COMMERCIAL_PARK_VAC, COLUMN_NAME_TOTAL_COMMERCIAL_SHOPPING, COLUMN_NAME_TOTAL_INDUSTRIAL_RESIDUAL, COLUMN_NAME_TOTAL_INDUSTRIAL_LARGE, 
                               COLUMN_NAME_MUNICIPAL_RESID, COLUMN_NAME_MUNICIPAL_MULTI_RESID, COLUMN_NAME_MUNICIPAL_COMM_RESIDUAL, COLUMN_NAME_MUNICIPAL_COMM_OFFICE, 
                               COLUMN_NAME_MUNICIPAL_COMMERCIAL_PARK_VAC, COLUMN_NAME_MUNICIPAL_COMM_SHOPPING, COLUMN_NAME_MUNICIPAL_IND_RESIDUAL, 
                               COLUMN_NAME_MUNICIPAL_IND_LARGE, COLUMN_NAME_EDUCATION_RESID, COLUMN_NAME_EDUCATION_MULTI_RESID, COLUMN_NAME_EDUCATION_COMM_RESIDUAL, 
                               COLUMN_NAME_EDUCATION_COMM_OFFICE, COLUMN_NAME_EDUCATION_COMMERCIAL_PARK_VAC, COLUMN_NAME_EDUCATION_COMM_SHOPPING,
                               COLUMN_NAME_EDUCATION_IND_RESIDUAL, COLUMN_NAME_EDUCATION_IND_LARGE)

# Columns with currency ($ amount) values 
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
                                COLUMN_NAME_ROADS_PAVED, COLUMN_NAME_BRIDGES_CULVERTS, COLUMN_NAME_TRAFFIC_OPERATIONS, COLUMN_NAME_WINTER_CONTROL_EXCEPT_SIDEWALKS, COLUMN_NAME_WINTER_CONTROL_SIDEWALKS_PARKING_LOTS, 
                                COLUMN_NAME_TRANSIT_SERVICES_CONVENTIONAL, COLUMN_NAME_PARKING, COLUMN_NAME_WASTE_COLLECTION, COLUMN_NAME_WASTE_DISPOSAL, COLUMN_NAME_STORM_SEWER_URBAN, 
                                COLUMN_NAME_PUBLIC_HEALTH, COLUMN_NAME_EMERGENCY_MEASURES, COLUMN_NAME_GENERAL_ASSISTANCE, COLUMN_NAME_ASSISTANCE_AGED, 
                                COLUMN_NAME_CHILD_CARE, COLUMN_NAME_SOCIAL_HOUSING, COLUMN_NAME_PARKS, COLUMN_NAME_RECREATION_PROGRAMS, COLUMN_NAME_GOLF_MARINA_SKI_HILL, 
                                COLUMN_NAME_REC_FACILITIES_OTHER, COLUMN_NAME_LIBRARY, COLUMN_NAME_MUSEUMS, COLUMN_NAME_CULTURAL, COLUMN_NAME_PLANNING, COLUMN_NAME_COMMERCIAL_AND_INDUSTRIAL, 
                                COLUMN_NAME_GENERAL_GOVERNMENT, COLUMN_NAME_CONSERVATION_AUTHORITY, COLUMN_NAME_AMBULANCE_SERVICES, COLUMN_NAME_CEMETERIES, COLUMN_NAME_AGRICULTURE_AND_REFORESTATION,
                                COLUMN_NAME_COURT_SECURITY, COLUMN_NAME_POLICE, COLUMN_NAME_PRISONER_TRANSPORT, COLUMN_NAME_PROTECTIVE_INSPECTION_AND_CONTROL,
                                COLUMN_NAME_PROVINCIAL_OFFENCES_ACT, COLUMN_NAME_ROADS_UNPAVED, COLUMN_NAME_TRANSIT_SERVICES_DISABLED, COLUMN_NAME_STREET_LIGHTING,
                                COLUMN_NAME_AIR_TRANSPORTATION, COLUMN_NAME_STORM_SEWER_RURAL, COLUMN_NAME_SOLID_WASTE_DIVERSION,COLUMN_NAME_HOSPITALS,
                                COLUMN_NAME_COVID_EXPENSES, COLUMN_NAME_BUILDING_PERMITS_INSPECTION_SERVICES)
