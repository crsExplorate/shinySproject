
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

require(shiny)
require(shinydashboard)

header<-dashboardHeader(title = "Regresion Model")

sidebar<-dashboardSidebar(
  selectInput("predict", "Detect:",
              c("Setosa" = "setosa",
                "Versicolor" = "versicolor",
                "Virginica" = "virginica")),
  selectInput("model", "Model:",
              c("Model A" = "modA",
                "Model B" = "modB",
                "Model C" = "modC")),
  
  sliderInput("prob", "Probability Cut",
              min = 0, max = 1, value = 0.5, step = 0.01
  ),
  checkboxInput("outliers", "Show outliers", FALSE),
  sidebarMenu(
    menuItem("Main Board", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Model Details", tabName = "details", icon = icon("area-chart")),
    menuItem("About", tabName = "about", icon = icon("th"))
  )
)

body<-dashboardBody(
  tabItems(
    tabItem(tabName = "dashboard",
            fluidRow(
              # A static infoBox
              infoBox("Accuracy", textOutput("modelAccuracy"), icon = icon("credit-card"),
                      color="red"
              ),
              infoBox(
                "Recall", textOutput("modelRecall"), icon = icon("list"),
                color = "orange"
              ),
              infoBox(
                "Sensitivity", textOutput("modelSensitivity"), icon = icon("thumbs-up", lib = "glyphicon"),
                color = "purple"
              )
            ),
            fluidRow(
              # A static infoBox
              infoBox("F1 Score", textOutput("modelF1"), icon = icon("credit-card"),
                      color="red"
              ),
              infoBox(
                "Specificity", textOutput("modelSpecificity"), icon = icon("list"),
                color = "orange"
              ),
              infoBox(
                "Precision", textOutput("modelPrecision"), icon = icon("thumbs-up", lib = "glyphicon"),
                color = "purple"
              )
            ),
            fluidRow(
              box(
                width = 5, status = "info", solidHeader = TRUE,
                title = "ROC Curve",
                plotOutput("plotROCCurve", height = 350)
              ),
              box(
                width = 5, status = "info", solidHeader = TRUE,
                title = "Precission vs Recall",
                plotOutput("plotPrecissionRecall", height = 350)
              )
              
            ),
            fluidRow(
              box(
                width = 5, status = "info", solidHeader = TRUE,
                title = "Sensitivity vs Specifity",
                plotOutput("plotSensitivitySpecifity", height = 350)
              ),
              box(
                width = 5, status = "info", solidHeader = TRUE,
                title = "Accuracy vs Cutoff",
                plotOutput("plotAccuracyCutoff", height = 350)
              )
              
            )
    ),
    
    # Second tab content
    tabItem(tabName = "details",
            h2("Widgets tab content"),
            fluidRow(
              # A static infoBox
              infoBox("Degrees of Freedom", textOutput("modelDOF"), icon = icon("credit-card"),
                      color="red"
              ),
              infoBox(
                "AUC", textOutput("modelAUC"), icon = icon("list"),
                color = "orange"
              ),
              infoBox(
                "AIC", textOutput("modelAIC"), icon = icon("thumbs-up", lib = "glyphicon"),
                color = "purple"
              )
              
            ),
            fluidRow(
              box(
                width = 8, status = "info", solidHeader = TRUE,
                title = "Model adjust details",
                plotOutput("plotModelAdjust", height = 600)
              ),
              box(
                width = 4, status = "info",
                title = "Model Coefficeints",
                tableOutput("coeffTables")
              )
              
            )
    ),
    tabItem(tabName = "about",
            h2("About tab content"),
            h3("http://google.es") 
            )
  )
)


ui<-dashboardPage(header,sidebar,body)
