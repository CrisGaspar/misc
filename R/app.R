library(shiny)
library(readxl)

setwd("~/IdeaProjects/BMAMunicipalitiesApp/")
dataframe <- read_excel("bmaDataSample.xls")

ui <- fluidPage(
#  sliderInput(inputId = "num", 
#    label = "Choose a number", 
#    value = 25, min = 1, max = 100),
  dataTableOutput("data")
)

server <- function(input, output) {
  output$data <- renderDataTable({
    dataframe
  })
}

shinyApp(ui = ui, server = server)