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
# 1. Add more resiliancy and error checing. Add try/catch like blocks as necessary
# 2. Login HTTP POST should have hashed password
# 3. REFACTOR API CALLS TO BE PRIVATE !!!!
#    Have separate public get/set data methods for all endpoints instead of so many call_API* methods

setwd("~/Downloads/")
source_filename <-"bmaDataSample.xls"

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
  list("Population", "Density and Land Area", "Assessment Information", "Assessment Composition", "Building Permit Activity"),

  list("Total Levy", "Upper Tier Levy", "Lower Tier Levy", "Tax Asset Consumption Ratio", "Financial Position per Capita",
       "Tax Dis Res as % OSR", "Tax Reserves as % of Taxation", "Tax Res per Capita", "Tax Debt Int % OSR",
       "Tax Debt Charges as % OSR", "Total Debt Out per Capita", "Tax Debt Out per Capita", "Debt to Reserve Ratio",
       "Tax Receivable as % Tax", "Rates Coverage Ratio", "Net Fin Liab Ratio"),

  list("Development Charges", "Building Permit Fees"),

  list("Tax Ratios", "Optional Class"),

  list("Total Tax Rates", "Municipal Tax Rates", "Education Tax Rates", "Residential", "Multi-Residential",
       "Commercial", "Industrial"),

  list("Water&Sewer Costs", "Water Asset Consumption", "Wastewater Asset Consumption", "Water Res as % OSR",
       "Wastewater Res as % OSR", "Water Res as % Acum Amort", "Wastewater Res as % Acum Amort", "Water Debt Int Cover",
       "Wastewater Debt Int Cover", "Water Net Fin Liab", "Wastewater Net Fin Liab"),

  list("Average Household Income", "Average Value of Dwelling", "Combined costs", "Taxes as a % of Income"),
  list("Net Expenditures per Capita")
)

data_set_names <- list.flatten(menu_sub_tabs_text)

get_data <- function(filename, municipalities = NULL) {
  ##### TODO: FIX to read from API instead of xls file
  data_frame <- read_excel(filename)
  if (!is.null(municipalities)) {
    data_frame <- data_frame[data_frame$Municipality %in% municipalities, ]
  }
  data_frame
}

excel_sheet_names <- function(filename) {
  readxl::excel_sheets(filename)
}

read_excel_allsheets <- function(filename) {
  sheets <- readxl::excel_sheets(filename)
  x <- lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
  names(x) <- sheets
  x
}

load_data <- function(filename, year) {
#  lapply(1:length(data_set_names), function(i) {
#  })
  data_frame <- read_excel(filename, sheet = "Sheet1")
  print(data_frame)
  data_frame
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
call_API_data_endpoint <- function(method = httr::GET, municipalities = NULL, year = NULL, data_frames = NULL) {
  if (identical(method, httr::GET)) {
    # GET is called for data read with a year parameter and a list of municipalities as JSON body

    if ((!is.null(municipalities)) && (!is.null(year))) {
      url <-paste(api_server_url, data_endpoint, "?year=", year, sep="")
      requestBody <- paste('{"municipalities":', toJSON(municipalities),'}')
    }
    else {
      err <- paste("Cannot call API data endpoint with GET because either municipalities: ", municipalities, " or year: ", year, " are NULL");
      print(err)
      return
    }
  }
  else if (identical(method, httr:POST)) {
    # POST is called with list of data_frames in JSON format in body
    
    if ((!is.null(data_frames)) && (!is.null(year))) {
      url <-paste(api_server_url, data_endpoint, "?year=", year, sep="")
      print(rjson::toJSON(data_frames))
      requestBody <- paste('{"data":',  rjson::toJSON(data_frames), '}')
    }
    else {
      err <- paste("Cannot call API data endpoint with POST because either data_frames is NULL or year ", year, " is NULL")
      print(err)
      return
    }
  }
  else {
    print("API data endpoint called with unsupported HTTP method")
    return
  }
  
  print(url)
  
  call_success <- method(url, body=requestBody)
  call_success_text <- content(call_success, "text")
  
  # Get API response (succesful or unsuccesful)
  call_success_final <- fromJSON(call_success_text)
  print(call_success_final)
}


# UI rendering of data frame as a data table
renderDT_formatted <- function(data_frame, no_table_header = F) {
  # TODO: handle percent and other non-currency columns

  if (no_table_header) {
    # show only table (no column sorting)
    # Before rendering format the numbers to display in currency format
    renderDT(datatable(data_frame, options = list(dom = 't', bSort = FALSE), colnames = NULL) %>% formatCurrency(1:ncol(data_frame)), selection = 'none', server = F)
  }
  else {
    # Do not show search box
    # Before rendering format the numbers to display in currency format
    renderDT(datatable(data_frame, options = list(searching = FALSE)) %>% formatCurrency(1:ncol(data_frame)), selection = 'none', server = F)
  }
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
    } else if (user_input$is_superuser) {
      #### App's UI code goes here!
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
        
        selectInput(inputId = "data_load_year_selector",
                    label="Select Year for Data Load",
                    choices = years_all_options,
                    selected = current_year,
                    selectize = TRUE),

        # Horizontal line ----
        tags$hr(),

        # Input: Select a file ----
        fileInput(inputId = "load_file", "Choose Excel File",
                  multiple = FALSE,
                  accept = c("text/xls")),

        # actionButton(inputId="saveMunicipalitiesButton", label ="Save"),
        #  actionButton(inputId = "save", label = "Save"),

        # Main panel for displaying outputs ----
        mainPanel(
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
          # Generate the navigation menu
          # Create menu tabs using menu_tabs_text for titles
          # Create menu tab i it's subtabs use menu_sub_tabs_text[[i]] for titles
          do.call(navbarPage, c(title = "Datasets", id='navbar_page', lapply(1:length(menu_sub_tabs_text), function(i) {
            do.call(navbarMenu, c(title = menu_tabs_text[[i]], lapply(1:length(menu_sub_tabs_text[[i]]), function(j) {
                  tabPanel(menu_sub_tabs_text[[i]][j], menu_sub_tabs_text[[i]][j])
            })))
          })))
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
        
        # actionButton(inputId="saveMunicipalitiesButton", label ="Save"),
        #  actionButton(inputId = "save", label = "Save"),
        
        # Main panel for displaying outputs ----
        mainPanel(
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
          # Generate the navigation menu
          # Create menu tabs using menu_tabs_text for titles
          # Create menu tab i it's subtabs use menu_sub_tabs_text[[i]] for titles
          do.call(navbarPage, c(title = "Datasets", id='navbar_page', lapply(1:length(menu_sub_tabs_text), function(i) {
            do.call(navbarMenu, c(title = menu_tabs_text[[i]], lapply(1:length(menu_sub_tabs_text[[i]]), function(j) {
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
    result <- call_API_data_endpoint(method = httr::POST, data_frames = data_sheets, year = input$data_load_year_selector)

    print(result)

    # TODO: Add error handling for the REST endpoint connection fails
    if (result$success == "true") {
      print("Data loading successful")
    }
    else {
      # Handle error
      print("Data loading failed!")
      showModal(modalDialog(
        title = kErrorTitleFailedToLoadData,
        result$error_message,
        easyClose = TRUE,
        footer = NULL))

      return
    }
  })

  #
  # Municipality Selection
  observeEvent(input$municipalitySelector, {
    # Refresh data frame filtered to selected municipalities and selected year
    data_frame <- get_data(source_filename, input$municipalitySelector)

    # Render data and stats tables in UI
    output$data <- renderDT_formatted(data_frame)
    data_frame_stats <- get_stats(data_frame)
    output$data_stats <- renderDT_formatted(data_frame_stats, no_table_header = T)
  })
  
  # Year Selection
  observeEvent(input$data_display_year_selector, {
    # Refresh data frame filtered to selected municipalities and selected year
    result <- call_API_data_endpoint(method = httr::GET, municipalities = input$municipalitySelector, year = input$data_display_year_selector)
    print (result)
    # TODO CHECK RESULT for errors
    #TODO: Uncomment!!
    #data_frame <- result$data
    
    # Render data and stats tables in UI
    #output$data <- renderDT_formatted(data_frame)
    #data_frame_stats <- get_stats(data_frame)
    #output$data_stats <- renderDT_formatted(data_frame_stats, no_table_header = T)
  })

  # Button to save currently selected municipalities
  observeEvent(input$saveMunicipalitiesButton, {
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

  # Export button behaviour
  observeEvent(input$exportButton, {
    write_xlsx(data_frame, export_filename)

    showModal(modalDialog(
      title = paste("Exported to file: ", export_filename),
      easyClose = TRUE,
      footer = NULL))
  })

  # Download button behaviour
  output$bmaExport.xls <- downloadHandler(
    filename = export_filename,
    contentType = "text/xls",
    content = function(file) {
      print(file)
      write_xlsx(data_frame, file)
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