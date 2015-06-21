library(shiny)

shinyUI(
  navbarPage("Best Prediction",
        tabPanel("User Guide",
                 h1("Get the best model", style = "color:blue"),
                 p("This page is the what you see right after you run the application. This application help the user make predictions on certain data base on selected inputs"),
                 p("To start using the appiclation click on Data Analysis tab and follow the wizard. On the main panel, output and additional instructions as displayed.")),
        tabPanel("Data Analysis",
           sidebarPanel(
             uiOutput("your_dataset"), 
             uiOutput("your_dependent"),
             uiOutput("your_model"),
             uiOutput("your_prepro")#,
           ),
           mainPanel(
             tabsetPanel(type = "tabs", 
                tabPanel("Final Model", verbatimTextOutput("confMatixT")) 
             )
           )
        )
  )
)