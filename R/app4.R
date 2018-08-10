library(shiny)
library(readxl)
library(writexl)
library(DT)
library(httr)
library(jsonlite)
library(dplyr)

setwd("~/IdeaProjects/BMAMunicipalitiesApp/")
source_filename <-"bmaDataSample2.xls"
export_filename <-"bmaExport.xls"
editPermissionUsers <- c("cris", "oti")
user <- 'crisoti'
pwd <- 'Eclipse1999'
base <- 'http://localhost:8000/bmaapp/'
login_endpoint <- 'login'
municipalities_endpoint <- 'municipalities'

get_data <- function(filename, municipalities = NULL) {
  data_frame <- read_excel(filename)
  if (!is.null(municipalities)) {
    data_frame <- data_frame[data_frame$Municipality %in% municipalities, ]
  }
  data_frame  
}

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
print(municipality_all_choices)
municipality_selected_choices <- unlist(call_endpoint(municipalities_endpoint, user))
print(municipality_selected_choices)

data_frame <- get_data(source_filename, municipality_selected_choices)

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
              multiple = TRUE,
              selectize = FALSE,
              size = 10),
 # actionButton(inputId="saveMunicipalitiesButton", label ="Save"),
  DTOutput("data"),
  verbatimTextOutput("min_header"),
  verbatimTextOutput("min"),
 verbatimTextOutput("avg_header"),
  verbatimTextOutput("avg"),
 verbatimTextOutput("median_header"),
  verbatimTextOutput("median"),  
 verbatimTextOutput("max_header"), 
  verbatimTextOutput("max"), 
#  actionButton(inputId="exportButton", label ="Export"),
  # Button
  downloadButton(export_filename, "Download"),
  mainPanel(plotOutput('plot'))
#  actionButton(inputId = "save", label = "Save")
)

refreshSummary <- function(output) {
  numerics <- unlist(lapply(data_frame, is.numeric))
  print(numerics)
  print(data_frame)
  data_frame_nums <- data_frame[ , numerics]
  print(data_frame_nums)
    
  output$min_header <- renderPrint({
    "Min:"
  })
  
  output$min <- renderPrint({
    unlist(lapply(data_frame_nums, min))
  })
  
  output$avg_header <- renderPrint({
    "Avg:"
  })
  output$avg <- renderPrint({
    unlist(lapply(data_frame_nums, mean))
  })
  output$median_header <- renderPrint({
    "Median:"
  })  
  output$median <- renderPrint({
    unlist(lapply(data_frame_nums, median))
  })
  output$max_header <- renderPrint({
    "Max:"
  })  
  output$max <- renderPrint({
    unlist(lapply(data_frame_nums, max))
  })  
}

server <- function(input, output, session) {
  refreshSummary(output)
  
  observeEvent(input$municipalitySelector, {
    # Refresh data frame with newly selected municipalities
    data_frame <- get_data(source_filename, input$municipalitySelector)
    
    # Refresh data table in UI
    output$data <- renderDT(data_frame, selection = 'none', server = F, editable = T)
    
    # Refresh summary
    refreshSummary(output) 
  })
  
  
  observeEvent(input$saveMunicipalitiesButton, {
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

  observeEvent(input$exportButton, {
    write_xlsx(data_frame, export_filename)
    
    showModal(modalDialog(
      title = paste("Exported to file: ", export_filename),
      easyClose = TRUE,
      footer = NULL))
  })      

  output$bmaExport.xls <- downloadHandler(
    filename = export_filename,
    contentType = "text/xls",
    content = function(file) {
      print(file)
      write_xlsx(data_frame, file)
    }
  )    

  output$data <- renderDT(data_frame, selection = 'none', server = F, editable = T)

  slices <- c(10, 12,4, 16, 8)
  lbls <- c("US", "UK", "Australia", "Germany", "France")
  #pie(slices, labels = lbls, main="Tax Split by Type of Property")
  
  output$plot <- renderPlot({pie(slices, labels = lbls, main="Tax Split by Type of Property")})
  
#    output$data <- renderDT(data_frame, selection = 'none', server = F, editable = input$passwd %in% editPermissionUsers)
}

shinyApp(ui = ui, server = server)