install.packages(shiny)
install.packages(caret)
install.packages(ada)
install.packages(ggplot2)
install.packages(datasets)
install.packages(e1071)
install.packages(randomForest)
library(shiny)
library(caret)
library(ada)
library(ggplot2)
library(datasets)
library(e1071)
library(randomForest)

shinyServer(function(input, output) {
  data_sets <- c("none", "ToothGrowth", "InsectSprays", "PlantGrowth")
  pred_mods <- c("glm", "rf")
  pre_pro <- c("pca", "BoxCox", "center", "ica")

  output$your_dataset <- renderUI({
    selectInput("dataset", "Choose a dataset:", as.list(data_sets))
  })
  output$dataset_str <- renderPrint({
    if(!is.null(input$dataset) || input$dataset == "none")
      return()
    str(get(input$dataset))
  })
  
  output$your_dependent <- renderUI({
    if(is.null(input$dataset) || input$dataset == "none")
      return("")
    dat <- get(input$dataset)
    colnames <- names(dat)
    selectInput("dependent", "Choose the dependent variables:", as.list(c("none",colnames)))
  })

  output$your_model <- renderUI({
    if (is.null(input$dependent) || input$dependent == "none" || input$dataset == "none")
      return()
    selectInput("model", "Choose a predictive model:", as.list(pred_mods))
  })
  
  output$your_prepro <- renderUI({
    if (is.null(input$dependent) || input$dependent == "none" || input$dataset == "none")
      return()
    selectInput("prepro", "Choose a pre-process:", as.list(pre_pro))
  })
  
  # Building the model
  output$confMatixT <- renderPrint({
    if(is.null(input$dataset) || input$dataset == "none")
      return("Select a dataset from the dropdown list")
    if (is.null(input$dependent) || !(input$dependent %in% names(get(input$dataset))))
      return(c(str(get(input$dataset)),"Select a 'Factor' column to use as the variable to be predicted"))
    set.seed(1500)
    inTrain <- with(get(input$dataset), createDataPartition(get(input$dependent), p=0.75,list=FALSE))
    training <- get(input$dataset)[inTrain,]
    testing <- get(input$dataset)[-inTrain,]
    set.seed(1501)
    modelFit <- train(get(input$dependent) ~ ., method=input$model, data=training, preProcess=input$prepro)
    modelFit$finalModel
  })
})