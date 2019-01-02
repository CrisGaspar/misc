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
library(shinyjs)

# Load constants
source("bma_constants.R", local=TRUE)
source("bma_utils.R", local=TRUE)

#
# UI definition
#
ui <- dashboardPage(
  dashboardHeader(title = "BMA Municipal Study", titleWidth = 275),
  dashboardSidebar(width = 275, useShinyjs(), uiOutput("sidebarpanel")),
  dashboardBody(tags$head(tags$style(
    HTML('.wrapper {height: auto !important; position:relative; overflow-x:hidden; overflow-y:hidden}')
  )), uiOutput("body"))
)

login <- box(
  width = 5,
  title = "Login",
  textInput("userName", "Username"),
  passwordInput("passwd", "Password"),
  br(),
  actionButton("Login", "Log in")
)

#
# Server function sets up how the UI works
#
server <- function(input, output, session) {
  municipality_choices <- reactiveValues(all = list(), selected = list())
  
  # To logout back to login page
  login.page = paste(
    isolate(session$clientData$url_protocol),
    "//",
    isolate(session$clientData$url_hostname),
    ":",
    isolate(session$clientData$url_port),
    sep = ""
  )
  
  # reactive value containing user's authentication status
  user_input <- reactiveValues(authenticated = FALSE, error_message = NULL, is_superuser = F)
  
  observe({
    if (user_input$authenticated == FALSE) {
      if (!is.null(input$Login)) {
        if (input$Login > 0) {
          Username <- isolate(input$userName)
          Password <- isolate(input$passwd)
          
          login_result <- call_login_endpoint(Username, Password)
          
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
            
            if (!is.null(user_input$error_message)) {
              showModal(modalDialog(
                title = "Failed to login!",
                div(tags$b("Incorrect username or password", style = "color: red;")),
                size = "s",
                easyClose = TRUE,
                footer = NULL))
            } 
            else {
              ""
            }            
          }
        }
      }
    }
  })

  
  #### UI code --------------------------------------------------------------
  output$sidebarpanel <- renderUI({
    if (user_input$authenticated == TRUE) {
      if (user_input$is_superuser) {
        div(
          sidebarUserPanel(
            isolate(input$userName),
            subtitle = a(icon("usr"), "Logout", href = login.page)
          ),
          
          selectInput(inputId = "data_display_year_selector",
                      label="Year",
                      choices = years_all_options,
                      selected = default_selected_year,
                      selectize = TRUE),
          
          selectInput(inputId = "municipalitySelector",
                      label="Custom Grouping",
                      choices = municipality_choices$all,
                      selected = municipality_choices$all,
                      multiple = TRUE,
                      selectize = FALSE,
                      size = 10),
          
          # Generate the navigation menu
          # Create menu tab i it's subtabs use menu_sub_tabs_text[[i]] for titles
          do.call(sidebarMenu, c(id='sidebar_menu',
            lapply(names(menu_sub_tabs_text), function(tab_name) {
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
          }))),
          
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
                    accept = c("text/xls","text/xlsx"))
        )
      }
      else {
        div(
          sidebarUserPanel(
            isolate(input$userName),
            subtitle = a(icon("usr"), "Logout", href = login.page)
          ),
          
          selectInput(inputId = "data_display_year_selector",
                      label="Year",
                      choices = years_all_options,
                      selected = default_selected_year,
                      selectize = TRUE),
          
          selectInput(inputId = "municipalitySelector",
                      label="Custom Grouping",
                      choices = municipality_choices$all,
                      selected = municipality_choices$all,
                      multiple = TRUE,
                      selectize = FALSE,
                      size = 10),
          
          # Generate the navigation menu
          # Create menu tab i it's subtabs use menu_sub_tabs_text[[i]] for titles
          do.call(sidebarMenu, c(id='sidebar_menu',
                                 lapply(names(menu_sub_tabs_text), function(tab_name) {
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
        )
      }
    }
  })
  output$body <- renderUI({
    if (user_input$authenticated == TRUE) {
      fluidRow(
          h2(textOutput("selected_data_info"), align = "center"),
          downloadButton("exportToExcel", "View in Excel"),
          DTOutput("data"),
          DTOutput("data_stats")
          # actionButton(inputId="saveUserSelectionButton", label ="Save"),
          #  actionButton(inputId = "save", label = "Save")
      )
    } 
    else {
      login
    }
  })

  ################### APP SERVER CODE #####################################################

  set_municipal_data <- function(data_frames_list, only_filtered = F) {
    municipal_data$data_frame_filtered_columns <- data_frames_list[[1]]
    municipal_data$data_frame_filtered_columns_stats <- data_frames_list[[2]]    
    
    if (!only_filtered) {
      municipal_data$data_frame_all_columns <- data_frames_list[[3]]
      municipal_data$data_frame_population_by_year <- data_frames_list[[4]]
      municipal_data$data_frame_building_permit_activity_by_year <- data_frames_list[[5]]
    }
  }
  
  get_selected_data_info <- function() {
    selected_sub_tab <- input$sidebar_menu
    if (is.null(input$sidebar_menu)) {
      selected_sub_tab <- SUB_TAB_POPULATION
    }
    paste(input$data_display_year_selector, selected_sub_tab)
  }
  
  output$selected_data_info <- renderText({ 
    get_selected_data_info()
  })
  
  #
  # UI event handling
  #
  # Loading data from file
  observeEvent(input$load_file, {
    filename = input$load_file$datapath
    sheet_names_read <- excel_sheet_names(filename)

    # We check for missing sheets.
    missing_sheets <- setdiff(data_set_names, sheet_names_read)

    if (length(missing_sheets) > 0) {
      err <- paste("Missing sheets in uploaded file: ", paste(missing_sheets, collapse=", "))

      showModal(modalDialog(
        title = kErrorTitleFailedToLoadData,
        err,
        easyClose = TRUE,
        footer = NULL))

      return()
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
    
    if (result$success == "true") {
      showModal(modalDialog(
        title = "Successfully Uploaded Data to Server",
        easyClose = TRUE,
        footer = NULL))
    
      # Refresh data frame filtered to selected municipalities and selected year
      # Store data_frame so that it's accessible to the observeEvent code that is triggered 
      # when another sub-tab is selected in the UI
      data_frames_list <- refresh_data_display(output, input$sidebar_menu, municipalities = input$municipalitySelector, year = input$data_display_year_selector)
      set_municipal_data(data_frames_list)
    }
    else {
      # Handle error
      showModal(modalDialog(
        title = kErrorTitleFailedToLoadData,
        result$error_message,
        easyClose = TRUE,
        footer = NULL))
    }
  })

  municipal_data <- reactiveValues(data_frame_all_columns = NULL, data_frame_filtered_columns = NULL, data_frame_filtered_columns_stats = NULL, 
                                   data_frame_population_by_year = NULL, data_frame_building_permit_activity_by_year = NULL)
  
  # Municipality Selection
  observeEvent(input$municipalitySelector, {
    # Refresh data frame filtered to selected municipalities and selected year
    # Store data_frame so that it's accessible to the observeEvent code that is triggered 
    # when another sub-tab is selected in the UI
    data_frames_list <- refresh_data_display(output, input$sidebar_menu, municipalities = input$municipalitySelector, year = input$data_display_year_selector)
    set_municipal_data(data_frames_list)
  })
  
  # Year Selection
  observeEvent(input$data_display_year_selector, {
    # Refresh data frame filtered to selected municipalities and selected year
    # Store data_frame so that it's accessible to the observeEvent code that is triggered 
    # when another sub-tab is selected in the UI
    data_frames_list <- refresh_data_display(output, input$sidebar_menu, municipalities = input$municipalitySelector, year = input$data_display_year_selector)
    set_municipal_data(data_frames_list)
  })
 
  # Sub-tab/Dataset Selection 
  observeEvent(input$sidebar_menu, {
    selected_sub_tab <- input$sidebar_menu
    
    data_frame_to_display <- municipal_data$data_frame_all_columns
    if (selected_sub_tab == SUB_TAB_POPULATION_BY_YEAR) {
      data_frame_to_display <- municipal_data$data_frame_population_by_year
    }
    else if (selected_sub_tab == SUB_TAB_BUILDING_PERMIT_ACTIVITY_BY_YEAR)
    {
      data_frame_to_display <- municipal_data$data_frame_building_permit_activity_by_year
    }
    data_frames_list <- filter_and_display(output, data_frame_to_display, selected_sub_tab, selected_year = input$data_load_year_selector)
    set_municipal_data(data_frames_list, only_filtered = T)
    
    shinyjs::runjs("window.scrollTo(0, 0)")
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
  output$exportToExcel <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".xlsx", sep="")
    },
    contentType = "text/xlsx",
    content = function(file) {
      merged_df <- merge_data_frames_vertically_export(municipal_data$data_frame_filtered_columns, 
                                                       municipal_data$data_frame_filtered_columns_stats)
      df_list = list()
      display_year = input$data_display_year_selector
      df_list[[display_year]] = merged_df
      
      write_xlsx(df_list, file)
    }
  )
}

# start our web app
shinyApp(ui = ui, server = server)