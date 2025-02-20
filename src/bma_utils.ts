import * as ExcelJS from 'exceljs';
import {
    kApiUrl,
    kLoginEndpoint,
    kAllMunicipalitiesEndpoint,
    kMunicipalityGroupsEndpoint,
    kDataEndpoint,
    kDataByYearsEndpoint,
    kNonNumericColumnsCount,
    kInfoNoMunicipalitySelection,
    kTabBuildingPermitByYear
} from './bma_constants';

interface DataFrame {
    [key: string]: any[];
}

interface ApiResponse {
    success: string;
    error_message?: string;
    data?: any;
}

// Get recent years based on selected year
export function getRecentYears(selectedYear: number): number[] {
    return Array.from({length: 3}, (_, i) => selectedYear - 3 + i);
}

// Get population years
export function getPopulationYears(selectedYear: number): number[] {
    const startYear = 2006;
    let populationYears: number[] = [];

    if (selectedYear <= startYear) {
        populationYears = [selectedYear];
    } else {
        for (let year = startYear; year <= selectedYear; year += 5) {
            populationYears.push(year);
        }
    }

    // Selected year must always be the last element
    if (populationYears[populationYears.length - 1] !== selectedYear) {
        populationYears.push(selectedYear);
    }

    return populationYears;
}

// Excel file handling functions
export async function excelSheetNames(filename: string): Promise<string[]> {
    const workbook = new ExcelJS.Workbook();
    await workbook.xlsx.readFile(filename);
    return workbook.worksheets.map(sheet => sheet.name);
}

export async function readExcelSheets(filename: string, sheets?: string[]): Promise<{ [key: string]: DataFrame }> {
    const workbook = new ExcelJS.Workbook();
    await workbook.xlsx.readFile(filename);
    
    const sheetsToRead = sheets || workbook.worksheets.map(sheet => sheet.name);
    
    const result: { [key: string]: DataFrame } = {};
    for (const sheetName of sheetsToRead) {
        const worksheet = workbook.getWorksheet(sheetName);
        if (worksheet) {
            result[sheetName] = {};
            worksheet.eachRow((row, rowNumber) => {
                const rowValues = row.values.slice(1); // slice(1) because ExcelJS row values are 1-based
                rowValues.forEach((value, columnIndex) => {
                    const columnName = worksheet.getRow(1).getCell(columnIndex + 1).value;
                    if (!result[sheetName][columnName]) {
                        result[sheetName][columnName] = [];
                    }
                    result[sheetName][columnName][rowNumber - 1] = value;
                });
            });
        }
    }
    
    return result;
}

// Data frame operations
export function mergeDataFramesVerticallyExport(df: DataFrame, dfStats: DataFrame): DataFrame {
    // Create empty row
    const emptyRow: { [key: string]: null } = {};
    Object.keys(df).forEach(key => emptyRow[key] = null);

    // Clean infinite and NaN values
    const cleanDf = Object.fromEntries(
        Object.entries(df).map(([key, values]) => [
            key,
            values.map((v: number) => isFinite(v) ? v : null)
        ])
    );

    // Merge vertically
    return {
        ...cleanDf,
        ...emptyRow,
        ...dfStats
    };
}

// Convert columns to numeric except first column
export function convertToNumeric(dataFrame: DataFrame): DataFrame {
    const result = { ...dataFrame };
    const keys = Object.keys(result);
    
    for (let i = kNonNumericColumnsCount; i < keys.length; i++) {
        const key = keys[i];
        result[key] = result[key].map((value: any) => 
            value === null || value === undefined ? null : Number(value)
        );
    }
    
    return result;
}

// API calls using Bun's native fetch
export async function callLoginEndpoint(userid: string, password: string): Promise<ApiResponse> {
    try {
        const url = `${kApiUrl}${kLoginEndpoint}?userid=${userid}&password=${password}`;
        const response = await fetch(url);
        return await response.json();
    } catch (error) {
        return {
            success: 'false',
            error_message: error.message
        };
    }
}

export async function callApiAllMunicipalitiesEndpoint(year: number): Promise<ApiResponse> {
    return callApiMunicipalitiesHelper(kAllMunicipalitiesEndpoint, year);
}

export async function callApiAllMunicipalityGroupsEndpoint(year: number): Promise<ApiResponse> {
    return callApiMunicipalitiesHelper(kMunicipalityGroupsEndpoint, year);
}

async function callApiMunicipalitiesHelper(endpoint: string, year: number): Promise<ApiResponse> {
    if (!year) {
        return {
            success: 'false',
            error_message: 'Attempt to call API municipalities endpoint using GET but no year selected'
        };
    }

    try {
        const url = `${kApiUrl}${endpoint}?year=${year}`;
        const response = await fetch(url);
        return await response.json();
    } catch (error) {
        return {
            success: 'false',
            error_message: error.message
        };
    }
}

export async function callApiColumnsByYearsEndpoint(
    municipalities: string[],
    years: number[],
    byYearColumns: string[]
): Promise<ApiResponse> {
    if (!municipalities?.length) {
        return {
            success: 'true',
            error_message: kInfoNoMunicipalitySelection,
            data: null
        };
    }

    try {
        const url = `${kApiUrl}${kDataByYearsEndpoint}`;
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                municipalities,
                years,
                columns: byYearColumns
            })
        });
        return await response.json();
    } catch (error) {
        return {
            success: 'false',
            error_message: error.message
        };
    }
}

export async function callApiDataEndpoint(
    municipalities?: string[],
    year?: number,
    dataFrames?: DataFrame
): Promise<ApiResponse> {
    if (!year) {
        return {
            success: 'false',
            error_message: 'Year parameter is required'
        };
    }

    if (!municipalities?.length && !dataFrames) {
        return {
            success: 'true',
            error_message: kInfoNoMunicipalitySelection,
            data: null
        };
    }

    try {
        const url = `${kApiUrl}${kDataEndpoint}?year=${year}`;
        const body = municipalities ? { municipalities } : { data: dataFrames };
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(body)
        });
        return await response.json();
    } catch (error) {
        return {
            success: 'false',
            error_message: error.message
        };
    }
}
