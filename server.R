
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
require(ROCR)

findPerformance<-function(t,m){
  findCorrespondence(t,rev(m@x.values[[1]]),rev(m@y.values[[1]]))
}

findCorrespondence<-function(t,x,y){
  idx<-findInterval(t,x)
  xlow<-x[idx]
  xhigh<-x[idx+1]
  if(!is.na(xhigh)){
    idx=idx+round((t-xlow)/(xhigh-xlow))
  }
  y[idx]
}
  
buildModel<-function(){
  irisExtra<-iris
  irisExtra$setosa<-irisExtra$Species=="setosa"
  irisExtra$versicolor<-irisExtra$Species=="versicolor"
  irisExtra$virginica<-irisExtra$Species=="virginica"
  
  
  list(
  "setosa"=list(
    "data"=irisExtra$setosa,
    "modA"=glm(setosa~Sepal.Length,irisExtra,family = "binomial"),
    "modB"=glm(setosa~Sepal.Length+Sepal.Width,irisExtra,family = "binomial"),
    "modC"=glm(setosa~Sepal.Length+Sepal.Width+Petal.Length+Petal.Width,irisExtra,family = "binomial")
  ),
  "versicolor"=list(
    "data"=irisExtra$versicolor,
    "modA"=glm(versicolor~Sepal.Length,irisExtra,family = "binomial"),
    "modB"=glm(versicolor~Sepal.Length+Sepal.Width,irisExtra,family = "binomial"),
    "modC"=glm(versicolor~Sepal.Length+Sepal.Width+Petal.Length+Petal.Width,irisExtra,family = "binomial")
  ),
  "virginica"=list(
    "data"=irisExtra$virginica,
    "modA"=glm(virginica~Sepal.Length,irisExtra,family = "binomial"),
    "modB"=glm(virginica~Sepal.Length+Sepal.Width,irisExtra,family = "binomial"),
    "modC"=glm(virginica~Sepal.Length+Sepal.Width+Petal.Length+Petal.Width,irisExtra,family = "binomial")
  )
 )
}

model<-buildModel()


shinyServer(function(input, output) {
  
  buildPrediction<-function(){
    prd<-predict(model[[input$predict]][[input$model]], type = "response")
    predict<-prediction(prd,model[[input$predict]][["data"]])
    predict
  }
  
  
  output$modelDOF<-renderText({ 
    df.residual(model[[input$predict]][[input$model]])
  })
  
  output$modelAUC<-renderText({ 
    as.numeric(performance(buildPrediction(),measure = "auc")@y.values)
  })

  output$modelAIC<-renderText({ 
    AIC(model[[input$predict]][[input$model]])
  })
  
  output$cutOffProb<-renderText({ 
    formatC(input$prob*100.0, digits = 1, format = "f")
  })
  
  
  output$modelAccuracy<-renderText({ 
    findPerformance(input$prob,performance(buildPrediction(),measure = "acc"))
  })
  
  output$modelRecall<-renderText({ 
    findPerformance(input$prob,performance(buildPrediction(),measure = "rec"))
  })
  
  output$modelSensitivity<-renderText({ 
    findPerformance(input$prob,performance(buildPrediction(),measure = "sens"))
  })
  
  output$modelF1<-renderText({ 
    findPerformance(input$prob,performance(buildPrediction(),measure = "f"))
  })
  
  output$modelSpecificity<-renderText({ 
    findPerformance(input$prob,performance(buildPrediction(),measure = "spec"))
  })
  
  output$modelPrecision<-renderText({ 
    findPerformance(input$prob,performance(buildPrediction(),measure = "prec"))
  })
  
  
  output$plotROCCurve <- renderPlot({
    
    # draw the performance Graph
    plot(performance(buildPrediction(),"tpr","fpr"),print.cutoffs.at=c(input$prob),text.adj=c(-1.2, 1.2),colorize=TRUE)
    
  })
  
  output$plotPrecissionRecall <- renderPlot({
    
    # draw the performance Graph
    plot(performance(buildPrediction(),"prec","rec"),print.cutoffs.at=c(input$prob),text.adj=c(1.2, 1.2),colorize=TRUE)
    
  })
  
  output$plotSensitivitySpecifity <- renderPlot({
    
    # draw the performance Graph
    plot(performance(buildPrediction(),"sens","spec"),print.cutoffs.at=c(input$prob),text.adj=c(1.2, 1.2),colorize=TRUE)
    
  })
  
  output$plotAccuracyCutoff <- renderPlot({
    
    # draw the performance Graph
    plot(performance(buildPrediction(),"acc"))
    abline(v=input$prob, col = "blue")
  })
  

  output$plotModelAdjust <- renderPlot({
    
    # draw the model Graph
    par(mfrow=c(2,2))
    plot(model[[input$predict]][[input$model]])   
  })
  
  
  
  output$coeffTables <- renderTable({
    coefs<-as.data.frame(coefficients(model[[input$predict]][[input$model]]))
    names(coefs)<-"Values"
    coefs
  }, digits = 1)

})
