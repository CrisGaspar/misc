source("bma_constants.R", local=TRUE)

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
  cols <- (non_numeric_cols_count+1):ncol(data_frame)
  data_frame[cols] <- lapply(data_frame[cols], as.numeric)
  data_frame
}

# NOTE: Caller must not call get_filter_columns if selected_sub_tab is one of the special by-year tabs like SUB_TAB_POPULATION_BY_YEAR 
# or SUB_TAB_BUILDING_PERMIT_ACTIVITY_BY_YEAR
get_filter_columns <- function(selected_sub_tab) {
  column_names <- column_names_per_sub_tab_selection[[selected_sub_tab]]
  column_names <- append(list(COLUMN_NAME_MUNICIPALITY), column_names) 
}

filter_data_frame <- function(data_frame, filter_columns) {
  print(filter_columns)
  print(colnames(data_frame))
  filtered_data_frame <- data_frame[unlist(filter_columns, use.name=FALSE)]
}

# Create stats data frame for given data frame with min, max, average, and median for each numeric column in given data frame
get_stats <- function(data_frame) {
  data_frame_only_numeric <- data_frame[,-non_numeric_cols_count]
  
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

call_API_columns_by_years_endpoint <- function(municipalities, years, by_year_columns) {
  url <-paste(api_server_url, columns_by_years_endpoint, sep="")
  method <- httr::POST
  
  # To get data: 3 lists of municipalities, years and by_year_columns are passed in body in JSON format
  requestBody <- paste('{"municipalities":', toJSON(municipalities), ',"years":', toJSON(years), ',"columns":', toJSON(by_year_columns), '}')
  
  call_success <- method(url, body=requestBody)
  call_success_text <- content(call_success, "text")
  print(call_success_text)
  
  # Get API response (succesful or unsuccesful)
  call_success_final <- jsonlite::fromJSON(call_success_text)
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

filter_column_names <- function(column_names, filtering_list) {
  filtered_colums <- column_names[unlist(lapply(column_names, function(column_name) {
    # default value is the original column name
    extracted_column_name <- column_name
    
    first_4_chars <- substr(column_name, 1, 4)
    fifth_char <- substr(column_name, 5, 5)
    
    if (fifth_char == ' ') {
      possible_year <- strtoi(first_4_chars, base = 10)
      if (!is.na(possible_year)) {
        extracted_column_name <- substr(column_name, 6, nchar(column_name))
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
             formatCurrency(filter_column_names(column_names, COLUMNS_CURRENCY_0_DECIMALS), currency = FORMAT_SETTINGS_CURRENCY_DEFAULT$SYMBOL, mark = FORMAT_SETTINGS_CURRENCY_DEFAULT$SEPARATOR, 
                            digits = FORMAT_SETTINGS_CURRENCY_DEFAULT$DECIMALS) %>% 
             formatCurrency(filter_column_names(column_names, COLUMNS_CURRENCY_2_DECIMALS), currency = FORMAT_SETTINGS_CURRENCY_2_DECIMALS$SYMBOL, mark = FORMAT_SETTINGS_CURRENCY_2_DECIMALS$SEPARATOR, 
                            digits = FORMAT_SETTINGS_CURRENCY_2_DECIMALS$DECIMALS) %>% 
             formatCurrency(filter_column_names(column_names, COLUMNS_PERCENT_1_DECIMAL), currency = FORMAT_SETTINGS_PERCENT_1_DECIMAL$SYMBOL, mark = FORMAT_SETTINGS_PERCENT_1_DECIMAL$SEPARATOR, 
                            digits = FORMAT_SETTINGS_PERCENT_1_DECIMAL$DECIMALS) %>% 
             formatCurrency(filter_column_names(column_names, COLUMNS_PERCENT_2_DECIMALS), currency = FORMAT_SETTINGS_PERCENT_2_DECIMALS$SYMBOL, mark = FORMAT_SETTINGS_PERCENT_2_DECIMALS$SEPARATOR, 
                            digits = FORMAT_SETTINGS_PERCENT_2_DECIMALS$DECIMALS) %>% 
             formatCurrency(filter_column_names(column_names, COLUMNS_PERCENT_4_DECIMALS), currency = FORMAT_SETTINGS_PERCENT_4_DECIMALS$SYMBOL, mark = FORMAT_SETTINGS_PERCENT_4_DECIMALS$SEPARATOR, 
                            digits = FORMAT_SETTINGS_PERCENT_4_DECIMALS$DECIMALS) %>% 
             formatCurrency(filter_column_names(column_names, COLUMNS_PERCENT_5_DECIMALS), currency = FORMAT_SETTINGS_PERCENT_5_DECIMALS$SYMBOL, mark = FORMAT_SETTINGS_PERCENT_5_DECIMALS$SEPARATOR, 
                            digits = FORMAT_SETTINGS_PERCENT_5_DECIMALS$DECIMALS) %>% 
             formatCurrency(filter_column_names(column_names, COLUMNS_PERCENT_6_DECIMALS), currency = FORMAT_SETTINGS_PERCENT_6_DECIMALS$SYMBOL, mark = FORMAT_SETTINGS_PERCENT_6_DECIMALS$SEPARATOR, 
                            digits = FORMAT_SETTINGS_PERCENT_6_DECIMALS$DECIMALS) %>%
             formatStyle(columns = column_names, width='5px'), 
           selection = 'none', server = F)
}

filter_and_display <- function(output, data_frame, selected_sub_tab) {
  if (!is.null(data_frame)) {
    if (selected_sub_tab == SUB_TAB_POPULATION_BY_YEAR 
        || selected_sub_tab == SUB_TAB_BUILDING_PERMIT_ACTIVITY_BY_YEAR) {
      # no need to filter. use all columns
      filtered_data_frame <- data_frame
    }
    else {
      filter_columns <- get_filter_columns(selected_sub_tab)
      filtered_data_frame <- filter_data_frame(data_frame, filter_columns)
    }
    print(filtered_data_frame)
    
    # Render data and stats tables in UI
    output$data <- renderDT_formatted(filtered_data_frame)
    filtered_data_frame_stats <- get_stats(filtered_data_frame)
    output$data_stats <- renderDT_formatted(filtered_data_frame_stats)
    
    # return the filtered_data_frame
    list(filtered_data_frame, filtered_data_frame_stats)
  }
} 

get_empty_data_frame <- function(years = NULL, by_year_columns = NULL) {
  if (!is.null(years) && !is.null(by_year_columns)) {
    # empty dataframes with columns having all years and by_year_columns combinations. Plus Municipality as the 1st column
    num_columns <- length(years) * length(by_year_columns) + 1
    print(paste("get_empty_data_frame: length(years) = ", length(years), " length(by_year_columns)  = ", length(by_year_columns)))
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

get_municipality_data <- function(municipalities, year, population_by_year = F, by_year_columns = NULL) {
  if (is.null(by_year_columns) && !population_by_year) {
    # Get data frame filtered to selected municipalities and selected year
    result <- call_API_data_endpoint(municipalities = municipalities, year = year)
    years = NULL
  }
  else {
    years = list()
    if (population_by_year) {
      years = get_population_years(year)
    }
    else if (!is.null(by_year_columns)){
      years = get_recent_years(year)
    }

    # Get by-year data for selected municipalities, specific years and specified colum name 
    result <- call_API_columns_by_years_endpoint(municipalities = municipalities, years = years, by_year_columns = by_year_columns)  
  }
    
  if (result$success == "false") {
    data_frame <- get_empty_data_frame(years = years, by_year_columns = by_year_columns)
    
    showModal(modalDialog(
      title = "Failed to Get Data",
      result$error_message,
      easyClose = TRUE,
      footer = NULL))
  }
  else if (is.null(result$data) || length(result$data) == 0 || result$data == "[]") {
    print(paste("No Data Found For Selected Year:", year, "or Years: ", years, "and Selected Municipalities: ", municipalities, 
                " Error message from data server: ", result$error_message))
    data_frame <- get_empty_data_frame(years = years, by_year_columns = by_year_columns)
  }
  else {
    data_frame <- result$data
  }
  data_frame <- convert_to_numeric(data_frame)
}


refresh_data_display <- function(output, selected_sub_tab, municipalities=list(), year=default_selected_year) {
  if (is.null(selected_sub_tab)) {
    selected_sub_tab <- SUB_TAB_POPULATION
  }

  # Refresh data frame filtered to selected municipalities and selected year
  data_frame <- get_municipality_data(municipalities = municipalities, year = year, population_by_year = F, by_year_columns = NULL)

  data_frame_population_by_year <- get_municipality_data(municipalities = municipalities, year = year, population_by_year = T, by_year_columns = list(COLUMN_NAME_POPULATION))
  data_frame_building_permit_activity_by_year <- get_municipality_data(municipalities = municipalities, year = year, population_by_year = F, 
                                                                       by_year_columns = list(COLUMN_NAME_BUILDING_CONSTRUCTION_VALUE, 
                                                                                              COLUMN_NAME_BUILDING_CONSTRUCTION_PER_CAPITA_WITH_YEAR_PREFIX))
  data_frame_to_display <- data_frame
  if (selected_sub_tab == SUB_TAB_POPULATION_BY_YEAR) {
    data_frame_to_display <- data_frame_population_by_year
  }
  else if (selected_sub_tab == SUB_TAB_BUILDING_PERMIT_ACTIVITY_BY_YEAR)
  {
    data_frame_to_display <- data_frame_building_permit_activity_by_year
  }

  data_frames_list <- filter_and_display(output, data_frame_to_display, selected_sub_tab)
  filtered_data_frame <- data_frames_list[[1]]
  filtered_data_frame_stats <- data_frames_list[[2]]
  
  list(filtered_data_frame, filtered_data_frame_stats, data_frame, data_frame_population_by_year, data_frame_building_permit_activity_by_year)
}
