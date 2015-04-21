
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinydashboard)

# shinyUI(fluidPage(
# 
#   # Application title
#   titlePanel("Old Faithful Geyser Data"),
# 
#   # Sidebar with a slider input for number of bins
#   sidebarLayout(
#     sidebarPanel(
#       sliderInput("bins",
#                   "Number of bins:",
#                   min = 1,
#                   max = 50,
#                   value = 30)
#     ),
# 
#     # Show a plot of the generated distribution
#     mainPanel(
#       plotOutput("distPlot")
#     )
#   )
# ))

header<-dashboardHeader(title = "Confidence Model")

sidebar<-dashboardSidebar(
  selectInput("variable", "Variable:",
              c("Cylinders" = "cyl",
                "Transmission" = "am",
                "Gears" = "gear")),
  
  sliderInput("bins", "Warn when rate exceeds",
              min = 0, max = 100, value = 20, step = 0.1
  ),
  checkboxInput("outliers", "Show outliers", FALSE),
  sidebarMenu(
    menuItem("Main Board", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Details", tabName = "widgets", icon = icon("th"))
  )
)

body<-dashboardBody(
  tabItems(
    tabItem(tabName = "dashboard",
            fluidRow(
              # A static infoBox
              infoBox("New Orders", 10 * 2, icon = icon("credit-card")),
              # Dynamic infoBoxes
              infoBoxOutput("progressBox"),
              infoBoxOutput("approvalBox")
            ),
            fluidRow(
              box(
                width = 8, status = "info", solidHeader = TRUE,
                title = "Popularity by package (last 5 min)",
                plotOutput("distPlot", height = 450)
              ),
              box(
                width = 3, status = "info",
                title = "Top packages (last 5 min)",
                tableOutput("packageTable")
              )
              
            )
    ),
    
    # Second tab content
    tabItem(tabName = "widgets",
            h2("Widgets tab content"),
            fluidRow(
              box(
                width = 8, status = "info", solidHeader = TRUE,
                title = "Grafico repetido",
                plotOutput("distPlot2", height = 450)
              )
              
            )
    )
  )
)


ui<-dashboardPage(header,sidebar,body)
