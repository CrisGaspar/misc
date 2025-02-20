// Configuration
export const kApiUrl = 'http://localhost:8000/bmaapp/';
export const kLoginEndpoint = 'login';
export const kAllMunicipalitiesEndpoint = 'all_municipalities';
export const kMunicipalityGroupsEndpoint = 'municipality_groups';
export const kDataEndpoint = 'data';
export const kDataByYearsEndpoint = 'data_subset_by_years';

// Only Municipality column (1st one) is non-numeric
export const kNonNumericColumnsCount = 1;

// Errors
export const kErrorFailedToLoadData = 'Failed to Load from Excel File';
export const kInfoNoMunicipalitySelection = 'No Initial Municipality Selection';

// Defaults to most recent year we have data for
// TODO: Get it from API instead of hard-coded value
export const kMostRecentYear = 2023;
// 2014 is the oldest year
export const kAllYears = Array.from({length: kMostRecentYear - 2014 + 1}, (_, i) => 2014 + i);

// TypeScript enums for what were string constants in R
export enum GroupType {
    Population = "Population",
    Tier = "Tier",
    Location = "Location"
}

// Labels and selectors
export const kAllMunicipalitiesLabel = "All Municipalities";
export const kCustomMunicipalityGroupsLabel = "Custom Groups";
export const kAllMunicipalitySelector = "municipalitySelector";
export const kCustomMunicipalityGroupSelector = "municipalityGroupSelector";

// Special sheet name used in more than 1 place hence made constant
export const kSheetNetExpendituresPerCapita = "Net Expenditures per Capita";

// Tab names
export const kTabPopulation = "Population";
export const kTabDensityLandArea = "Density and Land Area";
export const kTabAssessmentInfo = "Assessment Information";
export const kTabAssessmentComposition = "Assessment Composition";
export const kTabBuildingPermitByYear = "Building Permit Activity";
export const kTabTotalLevy = "Total Levy";
export const kTabUpperTierLevy = "Upper Tier Levy";
export const kTabLowerTierLevy = "Lower Tier Levy";
export const kTabTaxAssetConsumptionRatio = "Tax Asset Consumption Ratio";
export const kTabFinancialPositionPerCapita = "Financial Position per Capita";
export const kTabTaxDisResPercentOSR = "Tax Dis Res as Percent OSR";
export const kTabTaxReservesPercentTaxation = "Tax Reserves as Percent of Taxation";
export const kTabTaxResPerCapita = "Tax Res per Capita";
export const kTabTaxDebtIntPercentOSR = "Tax Debt Int Percent OSR";
export const kTabTaxDebtChargesPercentOSR = "Tax Debt Charges as Percent OSR";
export const kTabTotalTaxDebtOutPerCapita = "Total Debt Out per Capita";
export const kTabTaxDebtOutPerCapita = "Tax Debt Out per Capita";
export const kTabDebtToReserveRatio = "Debt to Reserve Ratio";
export const kTabTaxReceivablePercentTax = "Tax Receivable as Percent Tax";
export const kTabRatesCoverageRatio = "Rates Coverage Ratio";
export const kTabNetFinLiabRatio = "Net Fin Liab Ratio";
export const kTabDevelopmentCharges = "Development Charges";
export const kTabBuildingPermitFees = "Building Permit Fees";
export const kTabTaxRatios = "Tax Ratios";
export const kTabOptionalClass = "Optional Class";
export const kTabTotalTaxRates = "Total Tax Rates";
export const kTabMunicipalTaxRates = "Municipal Tax Rates";
export const kTabEducationalTaxRates = "Education Tax Rates";
export const kTabResidential = "Residential";
export const kTabMultiResidential = "Multi-Residential";
export const kTabCommercial = "Commercial";
export const kTabIndustrial = "Industrial";
export const kTabWaterAndSewerCosts = "Water and Sewer Costs";

// Net Expenditures per Capita tabs
export const kTabNetExpendituresPerCapitaFireServices = "Fire Services";
export const kTabNetExpendituresPerCapitaRoadsPaved = "Roadways - Paved";
export const kTabNetExpendituresPerCapitaBridgesCulverts = "Roadways - Bridges and Culverts";
export const kTabNetExpendituresPerCapitaTraffic = "Roadways - Traffic Control";
export const kTabNetExpendituresPerCapitaWinterRoads = "Winter Control - Roads";
export const kTabNetExpendituresPerCapitaWinterSidewalks = "Winter Control - Sidewalks";
export const kTabNetExpendituresPerCapitaTransit = "Transit Services";
export const kTabNetExpendituresPerCapitaParking = "Parking";
export const kTabNetExpendituresPerCapitaWasteCollection = "Waste Collection";
export const kTabNetExpendituresPerCapitaWasteDisposal = "Waste Disposal";

// Column names
export const COLUMN_NAME_MUNICIPALITY = 'Municipality';
export const COLUMN_NAME_POPULATION = 'Population';
export const COLUMN_NAME_POPULATION_DENSITY = 'Population Density per sq. km.';
export const COLUMN_NAME_ANNUAL_POPULATION_INCREASE = 'Annual Population Increase';
export const COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA = 'Building Construction Value per Capita';
export const COLUMN_NAME_ESTIMATED_AVG_HOUSEHOLD_INCOME = 'Estimated Average Household Income';
export const COLUMN_NAME_WEIGHTED_MEDIAN_VAL_DWELLING = 'Weighted Median Value of Dwelling';
export const COLUMN_NAME_UNWEIGHTED_ASSESSMENT_PER_CAPITA = 'Unweighted Assessment per Capita';
export const COLUMN_NAME_WEIGHTED_ASSESSMENT_PER_CAPITA = 'Weighted Assessment per Capita';
export const COLUMN_NAME_LAND_AREA = 'Land Area km2';
export const COLUMN_NAME_TOTAL_UNWEIGHTED_ASSESSMENT = 'Total Unweighted Assessment';
export const COLUMN_NAME_TOTAL_WEIGHTED_ASSESSMENT = 'Total Weighted Assessment';

// Menu sub tabs configuration
export const menu_sub_tabs_text: { [key: string]: string[] } = {
    [kSheetNetExpendituresPerCapita]: [
        kTabNetExpendituresPerCapitaFireServices,
        kTabNetExpendituresPerCapitaRoadsPaved,
        kTabNetExpendituresPerCapitaBridgesCulverts,
        kTabNetExpendituresPerCapitaTraffic,
        kTabNetExpendituresPerCapitaWinterRoads,
        kTabNetExpendituresPerCapitaWinterSidewalks,
        kTabNetExpendituresPerCapitaTransit,
        kTabNetExpendituresPerCapitaParking,
        kTabNetExpendituresPerCapitaWasteCollection,
        kTabNetExpendituresPerCapitaWasteDisposal
    ]
};

// Column mappings for sub tabs
export const column_names_per_sub_tab_selection: { [key: string]: string[] } = {
    [kTabTaxAssetConsumptionRatio]: [COLUMN_NAME_MUNICIPALITY],
    [kTabFinancialPositionPerCapita]: [COLUMN_NAME_MUNICIPALITY],
    [kTabPopulation]: [COLUMN_NAME_MUNICIPALITY, COLUMN_NAME_POPULATION],
    [kTabDensityLandArea]: [COLUMN_NAME_MUNICIPALITY, COLUMN_NAME_POPULATION_DENSITY, COLUMN_NAME_LAND_AREA]
};
