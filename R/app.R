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
library(shinydashboard)

# TODO: 
# -2: Fix missing 'per Capita' coluumn
# -1. Make sure the superuser and regular user UI branches are the same for their common elements
# 0. Login HTTP POST should have hashed password
# 1. Fix columns like Year + Metric e.g.: 2011 Population etc
# 2. Fix length of columns to be the same for both data and summary tables.
# 4. Save full list of municipalities in DB via all_municipalities endpoint
# 5. Save user groupings
# 6. Color stats row differently to stand out

# Nice to have:
# 4. Add more resiliancy and error checing. Add try/catch like blocks as necessary

# Data load spreadsheeet issues
# -2: Fix 2016 Building COnstruction Value per Capita and 2017 Weigthed Median Value Dwelling - values don't match.

# Load constants
source("bma_constants.R", local=TRUE)
source("bma_utils.R", local=TRUE)

#
# UI definition
#
ui = dashboardPage(
  dashboardHeader(title = "Login Page"),
  dashboardSidebar(disable = F),
  dashboardBody(uiOutput("ui"))
)

#
# Server function sets up how the UI works
#
server <- function(input, output, session) {
  municipality_choices <- reactiveValues(all = list(), selected = list())

  #### UI code --------------------------------------------------------------
  output$ui <- renderUI({
    if (user_input$authenticated == FALSE) {
      ##### UI code for login page
          column(width = 2, offset = 5,
                 br(), br(), br(), br(),
                 uiOutput("uiLogin"),
                 uiOutput("pass")
          )
    } 
    else if (user_input$is_superuser) {
      #### App's UI code goes here!
      dashboardPage(
        dashboardHeader(title = "Basic dashboard"),
        dashboardSidebar(
            collapsed = FALSE,
            selectInput(inputId = "municipalitySelector",
                        label="Custom Grouping",
                        choices = municipality_choices$all,
                        selected = municipality_choices$all,
                        multiple = TRUE,
                        selectize = FALSE,
                        size = 10),
            
            selectInput(inputId = "data_display_year_selector",
                        label="Year",
                        choices = years_all_options,
                        selected = default_selected_year,
                        selectize = TRUE),

            # Horizontal line ----
            tags$hr(),
            
            selectInput(inputId = "data_load_year_selector",
                        label="Year for Data Import",
                        choices = years_all_options,
                        selected = default_selected_year,
                        selectize = TRUE),

            # Input: Select a file ----
            fileInput(inputId = "load_file", "Choose Excel File",
                      multiple = FALSE,
                      accept = c("text/xls","text/xlsx")),
            
            # Generate the navigation menu
            # Create menu tab i it's subtabs use menu_sub_tabs_text[[i]] for titles
            do.call(sidebarMenu, c(id='sidebar_menu', lapply(names(menu_sub_tabs_text), function(tab_name) {
              do.call(menuItem, c(tab_name, tabName=tab_name, lapply(1:length(menu_sub_tabs_text[[tab_name]]), function(j) {
                if ((j == 1) && (tab_name == 'Socio Economic Indicators')) {
                  # this is the Population sub-tab in Socio Economic Indicators tab. Set this as the initial selection
                  select = TRUE
                }
                else {
                  select = FALSE
                }
                menuSubItem(menu_sub_tabs_text[[tab_name]][j], tabName=menu_sub_tabs_text[[tab_name]][j], selected = select)
              })))
            })))
        ),
        dashboardBody(
          fluidRow(
            box(
              downloadButton("downloadData", "Download"),
              DTOutput("data"),
              DTOutput("data_stats")
              # actionButton(inputId="saveUserSelectionButton", label ="Save"),
              #  actionButton(inputId = "save", label = "Save"),
              
              # Output: Tabset w/ plot, summary, and table ----
              #          tabsetPanel(type = "tabs",
              #                      tabPanel("Data",
              #                        DTOutput("data"),
              #                        DTOutput("data_stats")
              # Button
              #downloadButton(export_filename, "Download"),
              #                      ),
              #                      tabPanel("Summary", verbatimTextOutput("summary"))
              #          )
            )
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
                    selected = default_selected_year,
                    selectize = TRUE),
        
        tags$hr(),
        DTOutput("data"),
        DTOutput("data_stats"),
        downloadButton(export_filename, "Download"),
        
        # Main panel for displaying outputs ----
        mainPanel(
          do.call(navbarPage, c(title = "Data Sets", id='navbar_page', lapply(names(menu_sub_tabs_text), function(sub_tab_name) {
            do.call(navbarMenu, c(title = sub_tab_name, lapply(1:length(menu_sub_tabs_text[[sub_tab_name]]), function(j) {
              tabPanel(menu_sub_tabs_text[[sub_tab_name]][j], menu_sub_tabs_text[[sub_tab_name]][j])
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
      err <- paste("Missing sheets in uploaded file: ", paste(missing_sheets, collapse=", "))

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
      info <- paste("Ignoring new sheets in uploaded file: ", paste(new_sheets, collapse=", "))
      print(info)
    }

    # Read only datasheets we wanted/expected and send to API to save
    data_sheets <- read_excel_sheets(filename, data_set_names)
    result <- call_API_data_endpoint(data_frames = data_sheets, year = input$data_load_year_selector)

    # TODO: Add error handling for the REST endpoint connection fails
    if (result$success == "true") {
      print("Data loading successful")
      
      # Refresh data frame filtered to selected municipalities and selected year
      # Store data_frame so that it's accessible to the observeEvent code that is triggered 
      # when another sub-tab is selected in the UI
      data_frames_list <- refresh_data_display(output, input$sidebar_menu, municipalities = input$municipalitySelector, year = input$data_display_year_selector)
      municipal_data$data_frame_all_columns <- data_frames_list[[1]]
      municipal_data$data_frame_filtered_columns <- data_frames_list[[2]]
      municipal_data$data_frame_filtered_columns_stats <- data_frames_list[[3]]
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

  municipal_data <- reactiveValues(data_frame_all_columns = NULL, data_frame_filtered_columns = NULL, 
                                   data_frame_filtered_columns_stats = NULL)
  
  # Municipality Selection
  observeEvent(input$municipalitySelector, {
    # Refresh data frame filtered to selected municipalities and selected year
    # Store data_frame so that it's accessible to the observeEvent code that is triggered 
    # when another sub-tab is selected in the UI
    data_frames_list <- refresh_data_display(output, input$sidebar_menu, municipalities = input$municipalitySelector, year = input$data_display_year_selector)
    municipal_data$data_frame_all_columns <- data_frames_list[[1]]
    municipal_data$data_frame_filtered_columns <- data_frames_list[[2]]
    municipal_data$data_frame_filtered_columns_stats <- data_frames_list[[3]]
    
  })
  
  # Year Selection
  observeEvent(input$data_display_year_selector, {
    # Refresh data frame filtered to selected municipalities and selected year
    # Store data_frame so that it's accessible to the observeEvent code that is triggered 
    # when another sub-tab is selected in the UI
    data_frames_list <- refresh_data_display(output, input$sidebar_menu, municipalities = input$municipalitySelector, year = input$data_display_year_selector)
    municipal_data$data_frame_all_columns <- data_frames_list[[1]]
    municipal_data$data_frame_filtered_columns <- data_frames_list[[2]]
    municipal_data$data_frame_filtered_columns_stats <- data_frames_list[[3]]
  })
 
  # Sub-tab/Dataset Selection 
  observeEvent(input$sidebar_menu, {
    selected_sub_tab <- input$sidebar_menu
    data_frames_list <- filter_and_display(output, municipal_data$data_frame_all_columns, selected_sub_tab)
    municipal_data$data_frame_filtered_columns <- data_frames_list[[1]]
    municipal_data$data_frame_filtered_columns_stats <- data_frames_list[[2]]
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

  # Data Load
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("data-", Sys.time(), ".xlsx", sep="")
    },
    contentType = "text/xlsx",
    content = function(file) {
      merged_df <- merge_data_frames_vertically_export(municipal_data$data_frame_filtered_columns, 
                                                       municipal_data$data_frame_filtered_columns_stats)
      write_xlsx(merged_df, file)
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
      user_input$error_message <- NULL
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