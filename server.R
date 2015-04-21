
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)

shinyServer(function(input, output) {

  output$distPlot <- renderPlot({

    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')

  })
  
  output$distPlot2 <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    qplot(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
  output$progressBox <- renderInfoBox({
    infoBox(
      "Progress", paste0(25 + input$count, "%"), icon = icon("list"),
      color = "purple"
    )
  })
  output$approvalBox <- renderValueBox({
    valueBox(
      value = formatC(input$bins/100.0, digits = 1, format = "f"),
      subtitle = "Downloads per sec (last 5 min)",
      icon = icon("thumbs-up", lib = "glyphicon"),
      color = if (50 >= input$bins) "yellow" else "aqua"      
    )
  })
  
  output$packageTable <- renderTable({
#     pkgData() %>%
#       group_by(package) %>%
#       tally() %>%
#       arrange(desc(n), tolower(package)) %>%
#       mutate(percentage = n / nrow(pkgData()) * 100) %>%
#       select("Package name" = package, "% of downloads" = percentage) %>%
#       as.data.frame() %>%
#       head(15)
    head(faithful,15)
  }, digits = 1)

})
