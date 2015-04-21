
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
  #checkboxInput("outliers", "Show outliers", FALSE),
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
              infoBox("Accuracy", textOutput("modelAccuracy"), icon = icon("thumbs-up", lib = "glyphicon"),
                      color="red"
              ),
              infoBox(
                "Recall", textOutput("modelRecall"), icon = icon("plus-square-o"),
                color = "orange"
              ),
              infoBox(
                "Sensitivity", textOutput("modelSensitivity"), icon = icon("check-square-o"),
                color = "purple"
              )
            ),
            fluidRow(
              # A static infoBox
              infoBox("F1 Score", textOutput("modelF1"), icon = icon("stethoscope"),
                      color="red"
              ),
              infoBox(
                "Specificity", textOutput("modelSpecificity"), icon = icon("minus-square-o"),
                color = "orange"
              ),
              infoBox(
                "Precision", textOutput("modelPrecision"), icon = icon("plus-square"),
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
              infoBox("Degrees of Freedom", textOutput("modelDOF"), icon = icon("random"),
                      color="red"
              ),
              infoBox(
                "AUC", textOutput("modelAUC"), icon = icon("line-chart"),
                color = "orange"
              ),
              infoBox(
                "AIC", textOutput("modelAIC"), icon = icon("gavel"),
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
            h2("About this application"),
            wellPanel(
              helpText(
              "This is a simple project to test the capabilities of data product development. ",  
              "More details are availabe on ",
              a("RPubs",href="http://rpubs.com/crsExplorate/sprojectPresentation",target="_blank"),"."
              ),
              br(),
              "This project is based on ",
              a("Shiny",href="http://shiny.rstudio.com/",target="_blank"),
              " and ",
              a("Shinydashboard",href="http://rstudio.github.io/shinydashboard/",target="_blank"),
              "."
            ),
            h3("Application description"),
            wellPanel(
              "This application allows to compare several logit regression models and  ",
              " several main characteristics.",
              " For each specie of the iris data set several models has been built, and this app allows to chose an objetive Specie and a model.",
              " Based on several characteristics try to determine if the data corresponds to this specie.",
              " The user can change the cutoff probability to analyze thier effect.",br(),
              " The main tab shows the measures that are affected by this cange. On the other hand, on the model details generic information ",
              " of the selected model is shown."
            )
            
            )
  )
)


ui<-dashboardPage(header,sidebar,body)
