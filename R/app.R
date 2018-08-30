library(shiny)
library(readxl)
library(writexl)
library(DT)
library(httr)
library(jsonlite)
library(dplyr)
library(splus2R)

setwd("~/Downloads/")
source_filename <-"bmaDataSample.xls"

api_server_url <- 'http://localhost:8000/bmaapp/'
login_endpoint <- 'login'
municipalities_endpoint <- 'municipalities'
data_endpoint <- 'data'

non_numeric_cols_count <- 1
export_filename <-"bmaExport.xls"

##### TODO: FIX to read from API instead of xls file
get_data <- function(filename, municipalities = NULL) {
  data_frame <- read_excel(filename)
  # TODO::: UNCOMMENT BELOW !!!!
  #if (!is.null(municipalities)) {
  #  data_frame <- data_frame[data_frame$Municipality %in% municipalities, ]
  #}
  data_frame  
}

# Create stats data frame for given data frame with min, max, average, and median 
# for each of numeric column in given data frame
get_stats <- function(data_frame) {
  
  # TODO: adjust to skip more an arbitrary number of intial non-numeric columns
  data_frame_only_numeric <- data_frame[,-non_numeric_cols_count]
  
  # Create empty data frame that will store the stats
  df <- data.frame(matrix(ncol = ncol(data_frame)-non_numeric_cols_count, nrow = 0))
  
  # Copy non-numeric column names
  colnames(df) <- colnames(data_frame_only_numeric)

  df["Min",] <- colMins(data_frame_only_numeric)
  df["Max",] <- colMaxs(data_frame_only_numeric)
  df["Average",] <- colMeans(data_frame_only_numeric)
  df["Median",] <- colMedians(data_frame_only_numeric)
  df
}

# Login given credentials. 
call_login_endpoint <- function(userid, password) {
  # call appropriate login endpoing
  url <- paste(api_server_url, login_endpoint, "?", "userid", "=", userid, "&", "password", "=", password, sep="")
  call_success <- httr::GET(url)
  call_success_text <- content(call_success, "text")
  call_success_final <- fromJSON(call_success_text)
  print(call_success_final)  
}

# Call API given specified API endpoint. Userids passed in (if needed). 
# Municipality list passed in when needed to store new selection of municipalities.
call_API <- function(endpoint, userid=NULL, municipalities = NULL) {
  if (!is.null(userid)) {
    url <-paste(api_server_url, endpoint, "?", "userid", "=", userid, sep="")
  }
  else {
    url <-paste(api_server_url, endpoint, sep="")
  }
  if (is.null(municipalities)) {
    method <- httr::GET
    requestBody <- NULL
  }
  else {
    method <- httr::POST
    requestBody <- paste('{"municipalities":', toJSON(municipalities),'}')
  }
  
  call_success <- method(url, body=requestBody)
  call_success_text <- content(call_success, "text")
  
  # Get API response (succesful or unsuccesful) 
  call_success_final <- fromJSON(call_success_text)
  print(call_success_final)
}

# UI rendering of data frame as a data table
renderDT_formatted <- function(data_frame, can_edit = F) {
  # Before rendering format the numbers to display in currency format
  # TODO: handle percent and other non-currency columns
  renderDT(datatable(data_frame) %>% formatCurrency(1:ncol(data_frame)), selection = 'none', server = F, editable = can_edit)
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
    } else {
      #### Your app's UI code goes here!
      fluidPage(
        selectInput(inputId = "municipalitySelector", 
                    label="Municipalities", 
                    choices = municipality_choices$all,
                    selected = municipality_choices$selected,
                    multiple = TRUE,
                    selectize = FALSE,
                    size = 10),
        # actionButton(inputId="saveMunicipalitiesButton", label ="Save"),
        DTOutput("data"),
        DTOutput("data_stats"),
        #  actionButton(inputId="exportButton", label ="Export"),
        # Button
        downloadButton(export_filename, "Download"),
        mainPanel(plotOutput('plot'))
        #  actionButton(inputId = "save", label = "Save")
      )
    }
  })
  
  ################### APP SERVER CODE #####################################################
  # TODO: FIX this!!!!
  # Set selected municipalities based on existing user preference
  #input$municipalitySelector <- unlist(call_API(municipalities_endpoint, userid))
  
  # Refresh data frame
  data_frame <- get_data(source_filename, municipality_selected_choices)
  
  # Render the data and stats tables in UI 
  # TODO: set 'editable' based on user role
  editable = T
  output$data <- renderDT_formatted(data_frame, can_edit = editable)
  data_frame_stats <- get_stats(data_frame)
  output$data_stats <- renderDT_formatted(data_frame_stats, can_edit = F)
  
  # TODO: GRAPHS!!!!
  slices <- c(10, 12,4, 16, 8)
  lbls <- c("US", "UK", "Australia", "Germany", "France")
  #pie(slices, labels = lbls, main="Tax Split by Type of Property")
  output$plot <- renderPlot({pie(slices, labels = lbls, main="Tax Split by Type of Property")})    
  
  #
  # UI event handling
  #
  # Municipality Selection
  observeEvent(input$municipalitySelector, {
    
    # Refresh data frame filtered to newly selected municipalities
    data_frame <- get_data(source_filename, input$municipalitySelector)
    
    # Render data and stats tables in UI
    
    # TODO: set 'editable' based on user role
    output$data <- renderDT_formatted(data_frame, can_edit = editable)
    data_frame_stats <- get_stats(data_frame)
    output$data_stats <- renderDT_formatted(data_frame_stats, can_edit = F)
  })
  
  # Button to save currently selected municipalities
  observeEvent(input$saveMunicipalitiesButton, {
    tryCatch(
      # Call API to store the selected municipalities
      result <- call_API(municipalities_endpoint, userid, municipalities=input$municipalitySelector), 
      error = function(err) {
        showModal(modalDialog(
          title = "Failed to Save Settings",
          err,        
          easyClose = TRUE,
          footer = NULL))   
      },
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
  user_input <- reactiveValues(authenticated = FALSE, error_message = NULL)
  
  observeEvent(input$login_button, {
    login_result <- call_login_endpoint(input$user_name, input$password)
    
    if (login_result$success == "true") {
      user_input$authenticated <- TRUE

      # Get Municipalities from API
      
      # Full list of Municipalities
      municipality_choices$all <- call_API(municipalities_endpoint)
      
      # Municipalities that current user is interested in
      municipality_choices$selected <- unlist(call_API(municipalities_endpoint, input$user_name))
      print(municipality_choices)
      
    } else {
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
  
  # red error message if bad credentials
  output$pass <- renderUI({
    if (!is.null(user_input$error_message)) {
      #TODO: Check if should remove user_input$error_message for security reasons
      h5(strong(paste0("Failed to login. Incorrect credentials.\n", user_input$error_message), style = "color:red"), align = "center")
    } else {
      ""
    }
  })
}

# start our web app
shinyApp(ui = ui, server = server)