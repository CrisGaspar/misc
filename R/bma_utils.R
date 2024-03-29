source("bma_constants.R", local=TRUE)

# TODO: Add description
getRecentYears <- function(selected_year) {
  year <- as.numeric(selected_year)
  (year-3):(year-1)
}

# TODO: Add description
getPopulationYears <- function(selected_year) {
  year <- as.numeric(selected_year)

  # Census is every 5 years. Start from 2006
  start_year = 2006
  if (year <= start_year) {
    population_years <- list(year)
  }
  else {
    population_years <- seq(from = start_year, to = year, by = 5)
  }

  # selected year must always be the last element. add only if it is NOT already there
  if (tail(population_years, n = 1) != year) {
    population_years <- append(population_years, year)
  }
  population_years
}

excel_sheet_names <- function(filename) {
  readxl::excel_sheets(filename)
}

read_excel_sheets <- function(filename, sheets = NULL) {
  if (is.null(sheets)) {
    sheets <- readxl::excel_sheets(filename)
  }
  x <- lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
  names(x) <- sheets
  x
}

merge_data_frames_vertically_export <- function(df, df_stats) {
  # Create data_frame with 1 empty row
  empty_row_df <- data.frame(matrix(ncol = ncol(df), nrow = 1))
  colnames(empty_row_df) <- colnames(df)
  
  # In stats data_frame replace Inf and Nan values to NA
  clean_df_stats <- do.call(data.frame, lapply(df_stats, function(x) replace(x, is.infinite(x) || is.nan(x), NA)))
  colnames(clean_df_stats) <- colnames(df)

  # Merge vertically with the empty row beween the 2 data_frames
  final_df <-rbind(df, empty_row_df, clean_df_stats)
}

# Convert data_frame to numeric columns except the first 1 column which is the municipalities names
convert_to_numeric <- function(data_frame) {
  cols <- (kNonNumericColumnsCount+1):ncol(data_frame)
  data_frame[cols] <- lapply(data_frame[cols], as.numeric)
  data_frame
}

# NOTE: Caller must not call get_filter_columns if selected_sub_tab is one of the special by-year tabs like BuildingPermitByYear
get_filter_columns <- function(selected_sub_tab) {
  column_names <- column_names_per_sub_tab_selection[[selected_sub_tab]]
  column_names <- append(list(COLUMN_NAME_MUNICIPALITY), column_names) 
}

filter_data_frame <- function(data_frame, filter_columns) {
  filtered_data_frame <- data_frame[unlist(filter_columns, use.name=FALSE)]
}

# Create stats data frame for given data frame with min, max, average, and median for each numeric column in given data frame
get_stats <- function(data_frame) {
  data_frame_only_numeric <- data_frame[,-kNonNumericColumnsCount]
  
  # Create empty data frame that will store the stats
  num_columns <- ncol(data_frame)
  df <- data.frame(matrix(ncol = num_columns, nrow = 0))
  colnames(df) <- colnames(data_frame)
  
  df[1,1] <- "Min"
  df[1,2:num_columns] <- colMins(data_frame_only_numeric, na.rm = TRUE)
  df[2,1] <- "Max"
  df[2,2:num_columns] <- colMaxs(data_frame_only_numeric, na.rm = TRUE)
  df[3,1] <- "Average"
  if (is.vector(data_frame_only_numeric)) {
    df[3,2:num_columns] <- mean(data_frame_only_numeric, na.rm = TRUE)
  }
  else {
    # colMeans does not work for vectors. use mean instead
    df[3,2:num_columns] <- colMeans(data_frame_only_numeric, na.rm = TRUE)
  }
  # Note: using colMedians from miscTools package because splus2R package implementation does not work with NA values
  df[4,1] <- "Median"
  df[4,2:num_columns] <- splus2R::colMedians(data_frame_only_numeric, na.rm = TRUE)
  df
}

# Call API login endpoint with given credentials to authenticate user
call_login_endpoint <- function(userid, password) {
  url <- paste(kApiUrl, kLoginEndpoint, "?", "userid", "=", userid, "&", "password", "=", password, sep="")
  call_success <- httr::GET(url)
  call_success_text <- content(call_success, "text")
  call_success_final <- fromJSON(call_success_text)
}

call_API_all_municipalities_endpoint <- function(year) {
  call_API_municipalities_helper(kAllMunicipalitiesEndpoint, year = year)
}

call_API_all_municipality_groups_endpoint <- function(year) {
  call_API_municipalities_helper(kMunicipalityGroupsEndpoint, year = year)
}

call_API_municipalities_helper <- function(endpoint, year) {
  url <-paste(kApiUrl, endpoint, "?year=", year, sep="")
  method <- httr::GET
  
  error <- NULL
  if (is.null(year)) {
    error <- "Attempt to call API municipalities endpoint using GET but no year selected"
  }
  else {
    # Valid parameters. No request body needed
    requestBody <- NULL  
  }

  if (!is.null(error)) {
    result <- list(success = "false", error_message = error)
    print(result)
    return(result)
  }
  
  call_success <- method(url, body=requestBody)
  call_success_text <- content(call_success, "text")
  
  # Get API response (succesful or unsuccesful)
  call_success_final <- fromJSON(call_success_text)
}

call_API_columns_by_years_endpoint <- function(municipalities, years, by_year_columns) {
  if (is.null(municipalities)) {
    result <- list(success = 'true', error_message = kInfoNoMunicipalitySelection, data = NULL)
    print(result)
    return(result)
  }
  
  url <-paste(kApiUrl, kDataByYearsEndpoint, sep="")
  method <- httr::POST
  
  # To get data: 3 lists of municipalities, years and by_year_columns are passed in body in JSON format
  requestBody <- paste('{"municipalities":', toJSON(municipalities), ',"years":', toJSON(years), ',"columns":', toJSON(by_year_columns), '}')
  
  call_success <- method(url, body=requestBody)
  call_success_text <- content(call_success, "text")

  # Get API response (succesful or unsuccesful)
  call_success_final <- jsonlite::fromJSON(call_success_text)
}

# Call data read/write endpoint
call_API_data_endpoint <- function(municipalities = NULL, year = NULL, data_frames = NULL) {
  url <-paste(kApiUrl, kDataEndpoint, "?year=", year, sep="")
  method <- httr::POST
  
  # To get data a year parameter and a list of municipalities is passed as JSON body
  if ((!is.null(municipalities)) && (length(municipalities) >= 1) && (!is.null(year))) {
    requestBody <- paste('{"municipalities":', toJSON(municipalities),'}')
  }
  else if ((!is.null(data_frames)) && (!is.null(year))) {
    # POST is called with list of data_frames in JSON format in body
    requestBody <- paste('{"data":',  rjson::toJSON(data_frames), '}')
  }
  else if (is.null(municipalities)) {
    result <- list(success = 'true', error_message = kInfoNoMunicipalitySelection, data = NULL)
    print(result)
    return(result)
  }
  else {
    err <- paste("Cannot call API data endpoint because one of the parameters is not valid: year = ",  year, 
                 " no municipalities = ", is.null(municipalities) || length(municipalities) == 0, 
                 " data_frames is NULL = ", is.null(data_frames))
    result <- list(success = 'false', error_message = err)
    print(result)
    return(result)
  }
  
  call_success <- method(url, body=requestBody)
  call_success_text <- content(call_success, "text")

  # Get API response (succesful or unsuccesful)
  call_success_final <- jsonlite::fromJSON(call_success_text)
}

filter_column_names <- function(column_names, filtering_list) {
  filtered_colums <- column_names[unlist(lapply(column_names, function(column_name) {
    # default value is the original column name
    extracted_column_name <- column_name
    
    first_4_chars <- substr(column_name, 1, 4)
    fifth_char <- substr(column_name, 5, 5)
    
    if (fifth_char == ' ') {
      possible_year <- strtoi(first_4_chars, base = 10)
      if (!is.na(possible_year)) {
        # the real name is the part after '<year> '
        extracted_column_name <- substr(column_name, 6, nchar(column_name))
      }
    }
    else if (fifth_char == '-') {
      # the format is '<startYear>-<endYear> <columnName>'
      possible_year_range_start <- strtoi(first_4_chars, base = 10)
      possible_year_range_end <- strtoi(substr(column_name, 6, 9), base = 10)
 
      if ((!is.na(possible_year_range_start)) && (!is.na(possible_year_range_end))) {
        extracted_column_name <- substr(column_name, 11, nchar(column_name))
      }
    }
    
    extracted_column_name %in% filtering_list
  }))]
  
  filtered_colums
}


# UI rendering of data frame as a data table
renderDT_formatted <- function(data_frame) {
  column_names <- colnames(data_frame)
  width_options = list(
    autoWidth = FALSE,
    columnDefs = list(list(width = '200px', targets = "_all"))
  )

  # Full header row but do not show search box
  options_list = list(searching = FALSE, info = F, scrollX = T, bPaginate = F)
  display_column_names <- column_names

  options_list <- append(options_list, width_options)
  
  # Before rendering: format the numbers for display
  renderDT(datatable(data_frame, rownames= FALSE, options = options_list, colnames = display_column_names) %>% 
             formatCurrency(filter_column_names(column_names, COLUMNS_COUNTER), currency = FORMAT_SETTINGS_COUNTER$SYMBOL, mark = FORMAT_SETTINGS_COUNTER$SEPARATOR, digits = FORMAT_SETTINGS_COUNTER$DECIMALS) %>% 
             formatCurrency(filter_column_names(column_names, kColumnsNumber1Decimal), currency = FORMAT_SETTINGS_NUMBER_1_DECIMAL$SYMBOL, before = F, 
                            mark = FORMAT_SETTINGS_NUMBER_1_DECIMAL$SEPARATOR, digits = FORMAT_SETTINGS_NUMBER_1_DECIMAL$DECIMALS) %>% 
             formatCurrency(filter_column_names(column_names, COLUMNS_CURRENCY_0_DECIMALS), currency = FORMAT_SETTINGS_CURRENCY_DEFAULT$SYMBOL, mark = FORMAT_SETTINGS_CURRENCY_DEFAULT$SEPARATOR, 
                            digits = FORMAT_SETTINGS_CURRENCY_DEFAULT$DECIMALS) %>% 
             formatCurrency(filter_column_names(column_names, COLUMNS_CURRENCY_2_DECIMALS), currency = FORMAT_SETTINGS_CURRENCY_2_DECIMALS$SYMBOL, mark = FORMAT_SETTINGS_CURRENCY_2_DECIMALS$SEPARATOR, 
                            digits = FORMAT_SETTINGS_CURRENCY_2_DECIMALS$DECIMALS) %>% 
             formatCurrency(filter_column_names(column_names, COLUMNS_PERCENT_2_DECIMALS), currency = FORMAT_SETTINGS_PERCENT_2_DECIMALS$SYMBOL, before = F,
                            mark = FORMAT_SETTINGS_PERCENT_2_DECIMALS$SEPARATOR, digits = FORMAT_SETTINGS_PERCENT_2_DECIMALS$DECIMALS) %>% 
             formatCurrency(filter_column_names(column_names, COLUMNS_PERCENT_4_DECIMALS), currency = FORMAT_SETTINGS_PERCENT_4_DECIMALS$SYMBOL, before = F,
                            mark = FORMAT_SETTINGS_PERCENT_4_DECIMALS$SEPARATOR, digits = FORMAT_SETTINGS_PERCENT_4_DECIMALS$DECIMALS) %>% 
             formatCurrency(filter_column_names(column_names, COLUMNS_PERCENT_6_DECIMALS), currency = FORMAT_SETTINGS_PERCENT_6_DECIMALS$SYMBOL, before = F,
                            mark = FORMAT_SETTINGS_PERCENT_6_DECIMALS$SEPARATOR, digits = FORMAT_SETTINGS_PERCENT_6_DECIMALS$DECIMALS) %>%
             formatStyle(columns = column_names, width='5px'), 
           selection = 'none', server = F)
}

prepend_year <- function(column_name, year) {
  if (column_name != COLUMN_NAME_MUNICIPALITY) {
    paste(year, column_name)
  }
  else {
    column_name
  }
}

# get the nearest preceding census year before given year
getPreviousCensusYear <- function(year) {
  # census years: start with 2011. every 5 years. stop at 2100
  censusYears <- seq(2011, 2100, by=5)
  maxless <- max(censusYears[censusYears < year])
  maxless
}

filter_and_display <- function(output, data_frame, selected_sub_tab, selected_year, population_data_frame = NULL, building_construction_data_frame = NULL) {
  if (!is.null(data_frame)) {
    if (selected_sub_tab == kTabBuildingPermitByYear) {
      # no need to filter. use all columns
      filtered_data_frame <- data_frame
    }
    else {
      filter_columns <- get_filter_columns(selected_sub_tab)
      filtered_data_frame <- filter_data_frame(data_frame, filter_columns)
      
      # prepend-year in front of column names
      colnames(filtered_data_frame) <- lapply(colnames(filtered_data_frame), prepend_year, year = selected_year)
      
      if (selected_sub_tab == kTabPopulation) {
        # prepend population-by-year columns
        filtered_data_frame <- merge(population_data_frame, filtered_data_frame, by = "Municipality", all.y = TRUE)
       
        # get previous year columns
        previous_year_columns_data_frame <- get_municipality_data(municipalities = as.list(filtered_data_frame[[COLUMN_NAME_MUNICIPALITY]]),
                                                                  year = selected_year, population_by_year = F, 
                                                                  by_year_columns = list(COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA), 
                                                                  previous_year = T)
      
        filtered_data_frame <- merge(filtered_data_frame, previous_year_columns_data_frame, by = "Municipality", all.x = TRUE)
        
        # update annual population increase column name
        # display name is: '<startYear>-<endYear> Annual Population Increase'
        population_increase_api_name <- paste(selected_year, COLUMN_NAME_ANNUAL_POPULATION_INCREASE)
        start_year <- getPreviousCensusYear(selected_year)
        yearRange <- paste(start_year, "-", selected_year, sep = "")
        population_increase_display_name <- paste(yearRange, COLUMN_NAME_ANNUAL_POPULATION_INCREASE, sep = " ")
        # update dataframe to new display name
        colnames(filtered_data_frame)[colnames(filtered_data_frame) == population_increase_api_name] <- population_increase_display_name
      }
      else if (selected_sub_tab == kTabAvgHouseholdIncome) {
        filtered_data_frame <- get_municipality_data(municipalities = as.list(filtered_data_frame[[COLUMN_NAME_MUNICIPALITY]]), 
                                                     year = selected_year, population_by_year = F,
                                                     by_year_columns = list(COLUMN_NAME_EST_AVG_HOUSEHOLD_INCOME),
                                                     previous_year = F, recent_years = F)
      }
    }

    # Render data and stats tables in UI
    output$data <- renderDT_formatted(filtered_data_frame)
    filtered_data_frame_stats <- get_stats(filtered_data_frame)
    output$data_stats <- renderDT_formatted(filtered_data_frame_stats)
    
    # return the filtered_data_frame
    list(filtered_data_frame, filtered_data_frame_stats)
  }
} 

create_empty_data_frame <- function(years = NULL, by_year_columns = NULL) {
  if (!is.null(years) && !is.null(by_year_columns)) {
    # empty dataframes with columns having all years and by_year_columns combinations. Plus Municipality as the 1st column
    num_columns <- length(years) * length(by_year_columns) + 1
    df <- data.frame(matrix(ncol = num_columns, nrow = 0))
    column_names <- lapply(by_year_columns, function(column_name) {
      lapply(years, function(year) {
        paste(year, column_name)
      })
    })
    column_names <- list.flatten(append(list(COLUMN_NAME_MUNICIPALITY), column_names))
    colnames(df) <- column_names
  }
  else {
    # empty dataframe with all column names
    df <- data.frame(matrix(ncol = length(ALL_COLUMN_NAMES_LIST), nrow = 0))
    colnames(df) <- ALL_COLUMN_NAMES_LIST
  }
  df
}

get_municipality_data <- function(municipalities, year, population_by_year = F, by_year_columns = NULL, previous_year = F, recent_years = F) {

  if (is.null(by_year_columns) && !population_by_year) {
    # Get data frame filtered to selected municipalities and selected year
    result <- call_API_data_endpoint(municipalities = municipalities, year = year)
    years <- NULL
  }
  else {
    years <- list()
    if (previous_year) {
      year_num <- as.numeric(year)
      years <- list(as.character(year_num - 1))
    }
    else if (population_by_year) {
      years <- getPopulationYears(year)
    }
    else if (recent_years){
      years <- getRecentYears(year)
    } else {
      # use current selected year
      years <- list(year)
    }

    # Get by-year data for selected municipalities, specific years and specified colum name 
    result <- call_API_columns_by_years_endpoint(municipalities = municipalities, years = years, by_year_columns = by_year_columns)  
  }
    
  if (result$success == "false") {
    data_frame <- create_empty_data_frame(years = years, by_year_columns = by_year_columns)
    
    showModal(modalDialog(
      title = "Failed to Get Data",
      result$error_message,
      easyClose = TRUE,
      footer = NULL))
  }
  else if (is.null(result$data) || length(result$data) == 0 || result$data == "[]") {
    print(paste("No data found for selected year:", year, "or years: ", years, "and selected municipalities: ", municipalities, 
                "\nError message from data server: ", result$error_message))
    data_frame <- create_empty_data_frame(years = years, by_year_columns = by_year_columns)
  }
  else {
    data_frame <- result$data
  }
  data_frame <- convert_to_numeric(data_frame)
}


is_single_string <- function(input) {
  is.character(input) & length(input) == 1
}

refresh_data_display <- function(output, selected_sub_tab, municipalities, year) {
  if (is.null(selected_sub_tab)) {
    selected_sub_tab <- kTabPopulation
  }
  
  if (is_single_string(municipalities)) {
    municipalities <- list(municipalities)
  }

  # Refresh data frame filtered to selected municipalities and selected year
  data_frame <- get_municipality_data(municipalities = municipalities, year = year, population_by_year = F, by_year_columns = NULL)

  data_frame_population_by_year <- get_municipality_data(municipalities = municipalities, year = year, population_by_year = T, by_year_columns = list(COLUMN_NAME_POPULATION))
  data_frame_building_permit_activity_by_year <- get_municipality_data(municipalities = municipalities, year = year, population_by_year = F, 
                                                                       by_year_columns = list(COLUMN_NAME_BUILDING_CONSTRUCTION_VALUE, 
                                                                                              COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA_WITH_YEAR_PREFIX),
                                                                       recent_years = T)
  data_frame_to_display <- data_frame
  if (selected_sub_tab == kTabBuildingPermitByYear)
  {
    data_frame_to_display <- data_frame_building_permit_activity_by_year
  }

  data_frames_list <- filter_and_display(output, data_frame_to_display, selected_sub_tab, year, data_frame_population_by_year, 
                                         data_frame_building_permit_activity_by_year)
  filtered_data_frame <- data_frames_list[[1]]
  filtered_data_frame_stats <- data_frames_list[[2]]
  
  list(filtered_data_frame, filtered_data_frame_stats, data_frame, data_frame_population_by_year, data_frame_building_permit_activity_by_year)
}
