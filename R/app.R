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
  municipality_choices <- reactiveValues(all = list())
  municipality_groups <- reactiveValues(all = list(), group_mappings = list())
  
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
              return()
            }
            
            municipality_choices$all <- result$municipalities
            
            # Get list of Custom Municipality Groups
            result <- call_API_all_municipality_groups_endpoint(method = httr::GET)
            
            if (result$success == 'false') {
              showModal(modalDialog(
                title = "Failed to get list of municipality groups",
                result$error_message,
                easyClose = TRUE,
                footer = NULL))
              return()
            }

            municipality_groups$all <- get_all_group_names(result$groups)
            municipality_groups$group_mappings <- result$groups
            
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
                      label="All Municipalities",
                      choices = municipality_choices$all,
                      selected = municipality_choices$all,
                      multiple = TRUE,
                      selectize = FALSE,
                      size = 10),
          
          selectInput(inputId = "municipalityGroupSelector",
                      label="Custom Municipality Groups",
                      choices = municipality_groups$all,
                      selected = NULL,
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
                      label="All Municipalities",
                      choices = municipality_choices$all,
                      selected = municipality_choices$all,
                      multiple = TRUE,
                      selectize = FALSE,
                      size = 10),
          
          selectInput(inputId = "municipalityGroupSelector",
                      label="Custom Municipality Groups",
                      choices = municipality_groups$all,
                      selected = NULL,
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
          h3(textOutput("selected_data_info"), align = "center"),
          h3(textOutput("selected_municipality_group_info"), align = "center"),
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
  
  get_selected_municipalities <- function(selectorID = NULL) {
    if (!is.null(selectorID)) {
      if (selectorID == "municipalitySelector") {
        return(input$municipalitySelector)
      }
      else if (selectorID == "municipalityGroupSelector") {
        # find the list of municipalities in this group
        group_names <- input$municipalityGroupSelector
        group_mappings <- municipality_groups$group_mappings
        municipality_list <- get_municipality_list_for_groups(group_mappings, group_names)
        return(municipality_list)
      }
      else {
        return(NULL)
      }
    }
    
    # no explicit selector passed in. so try both
    full_selector_val <- input$municipalitySelector

    if (!is.null(full_selector_val)) {
      return(full_selector_val)
    }
    else if (!is.null(input$municipalityGroupSelector)) {
      # find the list of municipalities in this group
      group_names <- input$municipalityGroupSelector
      group_mappings <- municipality_groups$group_mappings
      municipality_list <- get_municipality_list_for_groups(group_mappings, group_names)
      return(municipality_list)
    }
    else {
      return(NULL)
    }
  }
  
  get_selected_data_info <- function(separator = " ") {
    selected_sub_tab <- input$sidebar_menu
    if (is.null(input$sidebar_menu)) {
      selected_sub_tab <- SUB_TAB_POPULATION
    }
    selected_data_info <- paste(input$data_display_year_selector, selected_sub_tab, sep = separator)
    selected_data_info
  }

  get_selected_municipality_group_info <- function(separator = " ") {
    if (!is.null(input$municipalityGroupSelector)) {
      selected_municipality_groups_info <- paste(input$municipalityGroupSelector, collapse=", ")
      selected_municipality_groups_info <- paste(selected_municipality_groups_info, "Municipalities")
      selected_municipality_groups_info
    }
  }
  
  output$selected_data_info <- renderText({ 
    get_selected_data_info()
  })
  
  output$selected_municipality_group_info <- renderText({ 
    get_selected_municipality_group_info()
  })
  
  get_all_group_names <- function(groups_info) {
    lapply(groups_info, function(group_info) {
      group_info$group_name
    })
  }
  
  get_municipality_list_for_group_type <- function(groups_info, names, group_type) {
    if (group_type == municipality_group_type_population) {
      municipality_list <- lapply(groups_info, function(group_info) {
        if (group_info$group_name %in% names && grepl(municipality_group_type_population, group_info$group_name, fixed = TRUE, ignore.case = TRUE)) {
          return(group_info$municipality_list)
        }
      })
      
      municipality_list <- unique(unlist(municipality_list, recursive=FALSE))
      return(municipality_list)
    }
    else if (group_type == municipality_group_type_tier) {
      municipality_list <- lapply(groups_info, function(group_info) {
        if (group_info$group_name %in% names && grepl(municipality_group_type_tier, group_info$group_name, fixed = TRUE, ignore.case = TRUE)) {
          return(group_info$municipality_list)
        }
      })
      
      municipality_list <- unique(unlist(municipality_list, recursive=FALSE))
      return(municipality_list)
      
    }
    else if (group_type == municipality_group_type_location) {
      municipality_list <- lapply(groups_info, function(group_info) {
        if (group_info$group_name %in% names 
            && !grepl(municipality_group_type_population, group_info$group_name, fixed = TRUE, ignore.case = TRUE)
            && !grepl(municipality_group_type_tier, group_info$group_name, fixed = TRUE, ignore.case = TRUE)) {
          return(group_info$municipality_list)
        }
      })
      
      municipality_list <- unique(unlist(municipality_list, recursive=FALSE))
      return(municipality_list)
    }
    else {
      return(list())
    }
  }
  
  get_municipality_list_for_groups <- function(groups_info, names) {
    if (is_single_string(names)) {
      names <- list(names)
    }
    
    location_groups_municipalities <- get_municipality_list_for_group_type(groups_info, names, municipality_group_type_location)

    population_groups_municipalities <- get_municipality_list_for_group_type(groups_info, names, municipality_group_type_population)

    tier_groups_municipalities <- get_municipality_list_for_group_type(groups_info, names, municipality_group_type_tier)

    municipality_list <- list()
    if (!is.null(location_groups_municipalities)) {
      municipality_list <- location_groups_municipalities
      if (!is.null(population_groups_municipalities)) {
        # need to find the common subset
        municipality_list <- intersect(municipality_list, population_groups_municipalities)
      }
      if (!is.null(tier_groups_municipalities)) {
        # need to find the common subset
        municipality_list <- intersect(municipality_list, tier_groups_municipalities)
      }
    }
    else if (!is.null(population_groups_municipalities)) {
      municipality_list <- population_groups_municipalities
      if (!is.null(tier_groups_municipalities)) {
        # need to find the common subset
        municipality_list <- intersect(municipality_list, tier_groups_municipalities)
      }
    }
    else if (!is.null(tier_groups_municipalities)) {
      # need to find the common subset
      municipality_list <- tier_groups_municipalities
    }
    
    municipality_list
  }
  
  
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
      data_frames_list <- refresh_data_display(output, input$sidebar_menu, municipalities = get_selected_municipalities(), year = input$data_display_year_selector)
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
  
  # All municipality Selector 
  observeEvent(input$municipalitySelector, {
    if (is.null(input$municipalitySelector)) {
      # got reset due to clicking on municipality group selector. nothing to do
      return() 
    }
    
    # reset the other municipality selector to null
    shinyjs::reset("municipalityGroupSelector")
    
    # Refresh data frame filtered to selected municipalities and selected year
    # Store data_frame so that it's accessible to the observeEvent code that is triggered 
    # when another sub-tab is selected in the UI
    selected_municipalities <- get_selected_municipalities(selector = "municipalitySelector")
    data_frames_list <- refresh_data_display(output, input$sidebar_menu, municipalities = selected_municipalities, year = input$data_display_year_selector)
    set_municipal_data(data_frames_list)
  })
  
  # Municipality group Selector 
  observeEvent(input$municipalityGroupSelector, {
    if (is.null(input$municipalityGroupSelector)) {
      # got reset due to clicking on all municipality selector. nothing to do
      return() 
    }
    
    # reset the other municipality selector to null
    shinyjs::reset("municipalitySelector")
    
    # Refresh data frame filtered to selected municipalities and selected year
    # Store data_frame so that it's accessible to the observeEvent code that is triggered 
    # when another sub-tab is selected in the UI
    selected_municipalities <- get_selected_municipalities(selector = "municipalityGroupSelector")
    data_frames_list <- refresh_data_display(output, input$sidebar_menu, municipalities = selected_municipalities, year = input$data_display_year_selector)
    set_municipal_data(data_frames_list)
  })
  
  # Year Selection
  observeEvent(input$data_display_year_selector, {
    # Refresh data frame filtered to selected municipalities and selected year
    # Store data_frame so that it's accessible to the observeEvent code that is triggered 
    # when another sub-tab is selected in the UI
    data_frames_list <- refresh_data_display(output, input$sidebar_menu, municipalities = get_selected_municipalities(), year = input$data_display_year_selector)
    set_municipal_data(data_frames_list)
  })
 
  # Sub-tab/Dataset Selection 
  observeEvent(input$sidebar_menu, {
    selected_sub_tab <- input$sidebar_menu
    
    data_frame_to_display <- municipal_data$data_frame_all_columns
    
    if (selected_sub_tab == SUB_TAB_BUILDING_PERMIT_ACTIVITY_BY_YEAR)
    {
      data_frame_to_display <- municipal_data$data_frame_building_permit_activity_by_year
    }

    data_frames_list <- filter_and_display(output, data_frame_to_display, selected_sub_tab, selected_year = input$data_display_year_selector,
                                           municipal_data$data_frame_population_by_year, municipal_data$data_frame_building_permit_activity_by_year)
    set_municipal_data(data_frames_list, only_filtered = T)
    
    shinyjs::runjs("window.scrollTo(0, 0)")
  })

  # Data Load
  output$exportToExcel <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), "-", get_selected_data_info(), ".xlsx", sep="")
    },
    contentType = "text/xlsx",
    content = function(file) {
      merged_df <- merge_data_frames_vertically_export(municipal_data$data_frame_filtered_columns, 
                                                       municipal_data$data_frame_filtered_columns_stats)
      df_list = list()
      selected_data_info = get_selected_data_info()
      df_list[[selected_data_info]] = merged_df
      
      write_xlsx(df_list, file)
    }
  )
}

# start our web app
shinyApp(ui = ui, server = server)