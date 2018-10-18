source("bma_constants.R", local=TRUE)

excel_sheet_names <- function(filename) {
  readxl::excel_sheets(filename)
}

read_excel_allsheets <- function(filename) {
  sheets <- readxl::excel_sheets(filename)
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

get_filter_columns <- function(selected_sub_tab) {
  subtab_constant <- subtab_name_to_constant_name[[selected_sub_tab]]
  column_names <- column_names_per_sub_tab_selection[[subtab_constant]]
  column_names <- append(list(COLUMN_NAME_MUNICIPALITY, COLUMN_NAME_YEAR), column_names) 
}

filter_data_frame <- function(data_frame, filter_columns) {
  filtered_data_frame <- data_frame[unlist(filter_columns, use.name=FALSE)]
}

# Create stats data frame for given data frame with min, max, average, and median for each numeric column in given data frame
get_stats <- function(data_frame) {
  data_frame_only_numeric <- data_frame[,-non_numeric_cols_count]
  
  # Create empty data frame that will store the stats
  df <- data.frame(matrix(ncol = ncol(data_frame), nrow = 0))
  colnames(df) <- colnames(data_frame)
  
  ncol <- ncol(df)
  df[1,1] <- "Min"
  df[1,2:ncol] <- colMins(data_frame_only_numeric, na.rm = TRUE)
  df[2,1] <- "Max"
  df[2,2:ncol] <- colMaxs(data_frame_only_numeric, na.rm = TRUE)
  df[3,1] <- "Average"
  df[3,2:ncol] <- colMeans(data_frame_only_numeric, na.rm = TRUE)
  # Note: using colMedians from miscTools package because splus2R package implementation does not work with NA values
  df[4,1] <- "Median"
  df[4,2:ncol] <- splus2R::colMedians(data_frame_only_numeric, na.rm = TRUE)
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
    list(filtered_data_frame, filtered_data_frame_stats)
  }
} 

get_empty_data_frame <- function() {
  df <- data.frame(matrix(ncol = length(ALL_COLUMN_NAMES_LIST), nrow = 0))
  colnames(df) <- ALL_COLUMN_NAMES_LIST
  df
}

refresh_data_display <- function(output, selected_sub_tab, municipalities=list(), year=default_selected_year) {
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
  
  data_frames_list <- filter_and_display(output, data_frame, selected_sub_tab)
  filtered_data_frame <- data_frames_list[[1]]
  filtered_data_frame_stats <- data_frames_list[[2]]
  
  list(data_frame, filtered_data_frame, filtered_data_frame_stats)
}
