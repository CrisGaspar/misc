# Load libraries used by app
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

# Load constants and utils
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
  municipality_groups <- reactiveValues(group_mappings = list())
  
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
            
            refresh_municipalities_and_groups(year = kMostRecentYear, is_initial_refresh = T)
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
                      choices = kAllYears,
                      selected = kMostRecentYear,
                      selectize = TRUE),
          
          selectInput(inputId = kAllMunicipalitySelector,
                      label = kAllMunicipalitiesLabel,
                      choices = NULL,
                      selected = NULL,
                      multiple = TRUE,
                      selectize = FALSE,
                      size = 10),
          
          selectInput(inputId = kCustomMunicipalityGroupSelector,
                      label = kCustomMunicipalityGroupsLabel,
                      choices = NULL,
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
                      choices = kAllYears,
                      selected = kMostRecentYear,
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
                      choices = kAllYears,
                      selected = kMostRecentYear,
                      selectize = TRUE),
          
          selectInput(inputId = kAllMunicipalitySelector,
                      label = kAllMunicipalitiesLabel,
                      choices = NULL,
                      selected = NULL,
                      multiple = TRUE,
                      selectize = FALSE,
                      size = 10),
          
          selectInput(inputId = kCustomMunicipalityGroupSelector,
                      label = kCustomMunicipalityGroupsLabel,
                      choices = NULL,
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
  deselect_selector <- function(selector_id, all_choices) {
    new_selected <- NULL
    label <- NULL
    if (selector_id == kAllMunicipalitySelector) {
      label <- kAllMunicipalitiesLabel
    }
    else if (selector_id == kCustomMunicipalityGroupSelector) {
      label <- kCustomMunicipalityGroupsLabel
    }
    
    new_label <- paste(label, selected_count_status(new_selected, all_choices))
    
    updateSelectInput(session, selector_id, label = new_label, choices = all_choices, selected = new_selected)
  }
  
  update_selector <- function(selector_id, all_choices, is_initial_update) {
    # new selection is the intersection of currently selected and full active list
    selected_choices <- intersect(input[[selector_id]], all_choices)
    
    if (!is.null(is_initial_update) && is_initial_update) {
      selected_choices <- all_choices
    }
    
    if (length(selected_choices) == 0) {
      selected_choices <- NULL
    }
    
    label <- NULL
    if (selector_id == kAllMunicipalitySelector) {
      label <- kAllMunicipalitiesLabel
    }
    else if (selector_id == kCustomMunicipalityGroupSelector) {
      label <- kCustomMunicipalityGroupsLabel
    }
    
    new_label <- paste(label, selected_count_status(selected_choices, all_choices))
    
    updateSelectInput(session, selector_id, label = new_label, choices = all_choices, selected = selected_choices)
    selected_choices
  }
  
  get_all_group_names <- function() {
    get_all_group_names_helper(municipality_groups$group_mappings)
  }
  
  get_all_municipalities <- function() {
    get_all_municipalities_helper(municipality_groups$group_mappings)
  }
  
  
  refresh_municipalities_and_groups <- function(year, is_initial_refresh) {
    # Get list of Municipality Groups
    result <- call_API_all_municipality_groups_endpoint(year = year)
    
    if (result$success == 'false') {
      showModal(modalDialog(
        title = "Failed to get list of municipality groups",
        result$error_message,
        easyClose = TRUE,
        footer = NULL))
      return()
    }
    
    municipality_groups$group_mappings <- result$groups
    
    # Full list of groups active for given year
    all_choices <- get_all_group_names()

    # update UI selector. for groups we don't care if it's initial update or not.
    selected_choices_groups <- update_selector(kCustomMunicipalityGroupSelector, all_choices, is_initial_update = NULL)
    
    # Full list of municipalities active for given year
    all_choices <- get_all_municipalities()
    
    # update UI selector
    selected_choices_municipalities <- update_selector(kAllMunicipalitySelector, all_choices, is_initial_update = is_initial_refresh)

    selected_municipalities <- get_selected_municipalities_explicitly(selected_choices_groups, selected_choices_municipalities)
    selected_municipalities
  }
  
  set_municipal_data <- function(data_frames_list, only_filtered = F) {
    municipal_data$data_frame_filtered_columns <- data_frames_list[[1]]
    municipal_data$data_frame_filtered_columns_stats <- data_frames_list[[2]]    
    
    if (!only_filtered) {
      municipal_data$data_frame_all_columns <- data_frames_list[[3]]
      municipal_data$data_frame_population_by_year <- data_frames_list[[4]]
      municipal_data$data_frame_building_permit_activity_by_year <- data_frames_list[[5]]
    }
  }
  
  selected_count_status <- function(selected_choices, all_choices) {
    status <- paste(length(selected_choices), length(all_choices), sep =" / ")
    status <- paste("- Showing ", status, sep = "")
    status
  }
  
  get_selected_municipalities_explicitly <- function(selected_choices_groups, selected_choices_municipalities) {
    if (!is.null(selected_choices_groups) && length(selected_choices_groups) > 0) {
      municipality_list <- get_municipality_list_for_groups(municipality_groups$group_mappings, filter_names = selected_choices_groups)
    }
    else if (!is.null(selected_choices_municipalities) && length(selected_choices_municipalities) > 0) {
      municipality_list <- selected_choices_municipalities
    }
    else {
      municipality_list <- NULL
    }
    municipality_list
  }
  
  get_selected_municipalities <- function(selectorID = NULL) {
    if (!is.null(selectorID)) {
      if (selectorID == kAllMunicipalitySelector) {
        return(input[[kAllMunicipalitySelector]])
      }
      else if (selectorID == kCustomMunicipalityGroupSelector) {
        # find the list of municipalities in this group
        group_names <- input[[kCustomMunicipalityGroupSelector]]
        group_mappings <- municipality_groups$group_mappings
        municipality_list <- get_municipality_list_for_groups(group_mappings, filter_names = group_names)
        return(municipality_list)
      }
      else {
        return(NULL)
      }
    }
    
    # no explicit selector passed in. so try both
    full_selector_val <- input[[kAllMunicipalitySelector]]

    if (!is.null(full_selector_val)) {
      return(full_selector_val)
    }
    else if (!is.null(input[[kCustomMunicipalityGroupSelector]])) {
      # find the list of municipalities in this group
      group_names <- input[[kCustomMunicipalityGroupSelector]]
      group_mappings <- municipality_groups$group_mappings
      municipality_list <- get_municipality_list_for_groups(group_mappings, filter_names = group_names)
      return(municipality_list)
    }
    else {
      return(NULL)
    }
  }
  
  get_selected_data_info <- function(separator = " ") {
    selected_sub_tab <- input$sidebar_menu
    if (is.null(input$sidebar_menu)) {
      selected_sub_tab <- kTabPopulation
    }
    selected_data_info <- paste(input$data_display_year_selector, selected_sub_tab, sep = separator)
    selected_data_info
  }

  get_selected_municipality_group_info <- function(separator = " ") {
    if (!is.null(input[[kCustomMunicipalityGroupSelector]])) {
      selected_municipality_groups_info <- paste(input[[kCustomMunicipalityGroupSelector]], collapse=", ")
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
  
  get_all_group_names_helper <- function(groups_info) {
    lapply(groups_info, function(group_info) {
      group_info$group_name
    })
  }
  
  get_all_municipalities_helper <- function(groups_info) {
    get_municipality_list_for_group_type(groups_info, filter_names = NULL, kTierGroup)
  }
  
  get_municipality_list_for_group_type <- function(groups_info, filter_names, group_type) {
    municipality_list <- list()
    if (group_type == kPopulationGroup) {
      municipality_list <- lapply(groups_info, function(group_info) {
        if ((is.null(filter_names) || group_info$group_name %in% filter_names) 
            && grepl(kPopulationGroup, group_info$group_name, fixed = TRUE, ignore.case = TRUE)) {
          return(group_info$municipality_list)
        }
      })
    }
    else if (group_type == kTierGroup) {
      municipality_list <- lapply(groups_info, function(group_info) {
        if ((is.null(filter_names) || group_info$group_name %in% filter_names) 
            && grepl(kTierGroup, group_info$group_name, fixed = TRUE, ignore.case = TRUE)) {
          return(group_info$municipality_list)
        }
      })
    }
    else if (group_type == kLocationGroup) {
      municipality_list <- lapply(groups_info, function(group_info) {
        if ((is.null(filter_names) || group_info$group_name %in% filter_names) 
            && !grepl(kPopulationGroup, group_info$group_name, fixed = TRUE, ignore.case = TRUE)
            && !grepl(kTierGroup, group_info$group_name, fixed = TRUE, ignore.case = TRUE)) {
          return(group_info$municipality_list)
        }
      })
    }
    
    municipality_list <- sort(unique(unlist(municipality_list, recursive=FALSE)))
    return(municipality_list)
  }
  
  get_municipality_list_for_groups <- function(groups_info, filter_names) {
    if (is_single_string(filter_names)) {
      filter_names <- list(filter_names)
    }
    
    location_groups_municipalities <- get_municipality_list_for_group_type(groups_info, filter_names, kLocationGroup)

    population_groups_municipalities <- get_municipality_list_for_group_type(groups_info, filter_names, kPopulationGroup)

    tier_groups_municipalities <- get_municipality_list_for_group_type(groups_info, filter_names, kTierGroup)

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
    missing_sheets <- setdiff(kExpectedSheets, sheet_names_read)

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
    new_sheets <- setdiff(sheet_names_read, kExpectedSheets)
    if (length(new_sheets) > 0) {
      info <- paste("Ignoring new sheets in uploaded file: ", paste(new_sheets, collapse=", "))
      print(info)
    }

    # Read only datasheets we wanted/expected and send to API to save
    data_sheets <- read_excel_sheets(filename, kExpectedSheets)
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
                                   data_frame_population_by_year = NULL, data_frame_building_permit_activity_by_year = NULL,
                                   custom_groups_selection_changed_by_user = F)
  
  # All municipality Selector 
  observeEvent(input[[kAllMunicipalitySelector]], {
    if (is.null(input[[kAllMunicipalitySelector]])) {
      # got reset due to clicking on municipality group selector. nothing to do
      return() 
    }
    
    if (!municipal_data$custom_groups_selection_changed_by_user) {
      # custom groups was not changed by user. the user changed the all municipality selector
      # deselect the other municipality selector
      deselect_selector(kCustomMunicipalityGroupSelector, all_choices = get_all_group_names())
    }
    # reset this flag to default of false so that a transition from user changed custom group selection to user 
    # changed all municipalities selection can still work property to unselect that previous custom group selection
    municipal_data$custom_groups_selection_changed_by_user = F
    
    # update label with updated selected count
    new_label <- paste(kAllMunicipalitiesLabel,
                       selected_count_status(input[[kAllMunicipalitySelector]],
                                             get_all_municipalities()))
    updateSelectInput(session, kAllMunicipalitySelector, label = new_label)
        
    # Refresh data frame filtered to selected municipalities and selected year
    # Store data_frame so that it's accessible to the observeEvent code that is triggered 
    # when another sub-tab is selected in the UI
    selected_municipalities <- get_selected_municipalities(selector = kAllMunicipalitySelector)

    data_frames_list <- refresh_data_display(output, input$sidebar_menu, municipalities = selected_municipalities, year = input$data_display_year_selector)
    set_municipal_data(data_frames_list)
  })
  
  # Municipality group Selector 
  observeEvent(input[[kCustomMunicipalityGroupSelector]], {
    if (is.null(input[[kCustomMunicipalityGroupSelector]])) {
      # got reset due to clicking on all municipality selector. nothing to do
      return() 
    }
    
    municipal_data$custom_groups_selection_changed_by_user <- T
    
    # deselect the other municipality selector
    deselect_selector(kAllMunicipalitySelector, all_choices = get_all_municipalities())
    
    # update label with updated selected count
    new_label <- paste(kCustomMunicipalityGroupsLabel,
                       selected_count_status(input[[kCustomMunicipalityGroupSelector]],
                                             get_all_group_names()))
    updateSelectInput(session, kCustomMunicipalityGroupSelector, label = new_label)
    
    # Refresh data frame filtered to selected municipalities and selected year
    # Store data_frame so that it's accessible to the observeEvent code that is triggered 
    # when another sub-tab is selected in the UI
    selected_municipalities <- get_selected_municipalities(selector = kCustomMunicipalityGroupSelector)

    # create new label and update all municipalities selector selector to match what's selected by current groups selection
    all_municipalities <- get_all_municipalities()
    new_label <- paste(kAllMunicipalitiesLabel,
                       selected_count_status(selected_municipalities,
                                             all_municipalities))    
    updateSelectInput(session, kAllMunicipalitySelector, label = new_label, choices = all_municipalities, selected = selected_municipalities)

    data_frames_list <- refresh_data_display(output, input$sidebar_menu, municipalities = selected_municipalities, year = input$data_display_year_selector)
    set_municipal_data(data_frames_list)
  })
  
  # Year Selector change
  observeEvent(input$data_display_year_selector, {
    selected_municipalities <- refresh_municipalities_and_groups(year = input$data_display_year_selector, is_initial_refresh = F)
    
    # Refresh data frame filtered to selected municipalities and selected year
    # Store data_frame so that it's accessible to the observeEvent code that is triggered 
    # when another sub-tab is selected in the UI

    data_frames_list <- refresh_data_display(output, input$sidebar_menu, municipalities = selected_municipalities, year = input$data_display_year_selector)
    set_municipal_data(data_frames_list)
  })
 
  # Sub-tab/Dataset Selection 
  observeEvent(input$sidebar_menu, {
    selected_sub_tab <- input$sidebar_menu
    
    data_frame_to_display <- municipal_data$data_frame_all_columns
    
    if (selected_sub_tab == kTabBuildingPermitByYear)
    {
      data_frame_to_display <- municipal_data$data_frame_building_permit_activity_by_year
    }

    data_frames_list <- filter_and_display(output, data_frame_to_display, selected_sub_tab, selected_year = input$data_display_year_selector,
                                           municipal_data$data_frame_population_by_year, municipal_data$data_frame_building_permit_activity_by_year)
    set_municipal_data(data_frames_list, only_filtered = T)
    
    # scroll to top
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