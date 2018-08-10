library(shiny)
library(readxl)
library(DT)
library(httr)
library(jsonlite)

setwd("~/IdeaProjects/BMAMunicipalitiesApp/")
source_filename <-"bmaDataSample.xls"
editPermissionUsers <- c("cris", "oti")

get_data <- function(filename, municipalities = NULL) {
  data_frame <- read_excel(filename)
  if (!is.null(municipalities)) {
    data_frame <- dataframe[dataframe$municipality %in% municipalities, ]
  }
  data_frame  
}

#data_frame <- get_data(source_filename)

call_login_endpoint <- function(userid, password) {
  url <- paste(base, login_endpoint, "?", "userid", "=", userid, "&", "password", "=", password, sep="")
  call_success <- httr::GET(url)
  call_success_text <- content(call_success, "text")
  call_success_final <- fromJSON(call_success_text)
  print(call_success_final)  
}

# Log-in
login_result <- call_login_endpoint(user, pwd)

call_endpoint <- function(endpoint, user=NULL, municipalities = NULL) {
  if (!is.null(user)) {
    url <-paste(base, endpoint, "?", "userid", "=", user, sep="")
  }
  else {
    url <-paste(base, endpoint, sep="")
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
  call_success_final <- fromJSON(call_success_text)
  print(call_success_final)
}

municipality_all_choices <- call_endpoint(municipalities_endpoint)
municipality_selected_choices <- unlist(call_endpoint(municipalities_endpoint, user))


ui <- fluidPage(
#  tabPanel("Login",
#           br(),
#           tags$form(
#             textInput(inputId = "username", label = "Userid"),
#             passwordInput("passwd",label = "Password"),
#             submitButton("Login")
#           ),
#           textOutput("pwrd")
#  ),
  selectInput(inputId = "municipalitySelector", 
              label="Municipalities", 
              choices = municipality_all_choices,
              selected = municipality_selected_choices,
              multiple = TRUE),
  actionButton(inputId="saveMunicipalitiesButton", label ="Save")
# , DTOutput("data")
#  actionButton(inputId = "save", label = "Save")
)


server <- function(input, output, session) {
  # First username and password
  # Now check edit permission
  observeEvent(input$saveMunicipalitiesButton, {
    print(typeof(input$municipalitySelector))
    print(input$municipalitySelector)
    tryCatch(
      result <- call_endpoint(municipalities_endpoint, user, municipalities=input$municipalitySelector), 
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

#  output$data <- renderDT(data_frame, selection = 'none', server = F, editable = T)
#    output$data <- renderDT(data_frame, selection = 'none', server = F, editable = input$passwd %in% editPermissionUsers)
}

shinyApp(ui = ui, server = server)