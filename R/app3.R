library(shiny)
#library(RODBC)
#channel <- odbcConnect("joy_test_sql_data_source", uid="shiny_test", pwd="shiny123")

#login_table<<-as.data.frame(sqlQuery(channel,"select * FROM [R_shiny_test].[dbo].[login_id]"))
login_table.username = c("cris", "oti")
login_table.password = c("abc", "def")

ui <- fluidPage(
  tabPanel("Login",
           br(),
           tags$form(
             textInput(inputId = "login.userid", label = "Userid"),
             passwordInput("login.password",label = "Password"),
             submitButton("Login")
           ),
           textOutput("pwrd")
  )
)

server <- function(input, output, session) {
  observeEvent(input$login,{
    uid_t<-isolate(input$userid)
    pwd_t<-isolate(input$password)
    if(input$userid=="")
    {
      showModal(modalDialog(
        title = "Invalid",
        "Please Fill Username"
      ))
    }
    else if(input$password=="")
    {
      showModal(modalDialog(
        title = "Invalid",
        "Please Fill Password"
      ))
    }
    else if(input$userid=="" &&input$password=="" )
    {
      showModal(modalDialog(
        title = "Invalid",
        "Please Fill Username & Password"
      )) 
    }
    else if(ui_t %in% login_table$username==TRUE|pwd_t %in% login_table$password==TRUE)
    {
      temp_login<-login_table[(login_table$username == uid_t ), ]
      if(temp_login$username==input$userid && temp_login$password==input$password)
      {
        library(tcltk)
        tkmessageBox(title = "XyBot",message = "Login Sucessful", icon = "info", type = "ok")
        shinyjs::removeClass(selector = "body", class = "sidebar-collapse")
        updateTabsetPanel(session, "tabs",selected ="data_upload")
        user_logged<-1
        shinyjs::disable("login_box")
        
      }
      else
      {
        tkmessageBox(title = "XyBot",message = "Wrong Credentials", icon = "info", type = "ok")
      }
    }
    else 
    {
      showModal(modalDialog(
        title = "Wrong",
        "Please Check your Credentials "
      ))
    }
  })
}
  
shinyApp(ui = ui, server = server)

