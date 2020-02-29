
# model na danych po obróbce
# tylko jeden rezultat dla każdej sesji


# load --------------------------------------------------------------------
source("Scripts/Preparetion/funk_save_models.R")
library(caret)
library(mlbench)
library(LiblineaR)
set.seed(123)
DATA_FOR_MODEL_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/DATA_FOR_MODEL_N.RDS") 




# model building -------------------------------------------------------------------
# control

ctrl <- trainControl(method = "repeatedcv", repeats = 3,verboseIter = TRUE) #crossvalidation 3 razy powtórzona | number = (defaults to 10)


#KNN evry building

for (B in c("X0","X1","X2")) {
  data_buil <- DATA_FOR_MODEL_N %>% filter(BUILDINGID == B)
  ## remove 0v rows
  # subsets  ----------------------------------------------------------------
  inTrain <- createDataPartition(
    y = data_buil$FLOOR, ## the outcome data are needed
    p = .75, ## The percentage of data in the training set
    list = FALSE ## The format of the results
    
  )

  barplot(prop.table(table(data_buil$FLOOR)),main = paste(B,"before"))

  
  
  ##
  training <- data_buil[inTrain,] 
  testing  <- data_buil[-inTrain,]
  name_testing <- paste0("testing",B)
  assign(name_testing,testing)

  barplot(prop.table(table(training$FLOOR)),main = paste(B,"training")) #sprawdzenie rozkładu po podziale
  barplot(prop.table(table(testing$FLOOR)),main = paste(B,"testing")) #sprawdzenie rozkładu po podziale
  
  
  
  #knn
  
  set.seed(123)
  FFit1KNN<- train(
    as.factor(FLOOR) ~  .,
    data = training  %>% select(starts_with("WAP"), BUILDINGID,FLOOR),
    method = "knn",
    #preProc = c("center", "scale"),
    tuneGrid = expand.grid(k = c(1:5,7,9,11,15)),
    trControl = ctrl

  )
  name <- paste0("FFit1KNN",B)
  assign(name , FFit1KNN) 
  
}



# -------------------------------------------------------------------------


#SVN subsets
# model building -------------------------------------------------------------------
# control


for (B in c("X0","X1","X2")) {
  data_buil <- DATA_FOR_MODEL_N %>% filter(BUILDINGID == B)
  
  # subsets  ----------------------------------------------------------------
  inTrain <- createDataPartition(
    y = data_buil$FLOOR, ## the outcome data are needed
    p = .75, ## The percentage of data in the training set
    list = FALSE ## The format of the results
    
  )
  
  barplot(prop.table(table(data_buil$FLOOR)),main = paste(B,"before"))
  
  
  
  ##
  training <- data_buil[inTrain,] 
  testing  <- data_buil[-inTrain,]
  name_testing <- paste0("testing",B)
  assign(name_testing,testing)
  
  barplot(prop.table(table(training$FLOOR)),main = paste(B,"training")) #sprawdzenie rozkładu po podziale
  barplot(prop.table(table(testing$FLOOR)),main = paste(B,"testing")) #sprawdzenie rozkładu po podziale
  
  
  
  
  
  set.seed(123)
  FFit1SVM <- train(
    as.factor(FLOOR) ~  .,
    data = training  %>% select(starts_with("WAP"), FLOOR),
    method = "svmRadialSigma",
    #preProc = c("center", "scale"),
    tuneLength = 6,
    trControl = ctrl
    
  )
  name <- paste0("FFit1SVM",B)
  assign(name , FFit1SVM) 
  rm(FFit1SVM,testing)
}






# SVN alldata -------------------------------------------------------------
for (B in c("X0","X1","X2")) {
  data_buil <- DATA_FOR_MODEL_N %>% filter(BUILDINGID == B)
  training <- data_buil
  
  set.seed(123)
  FFit1SVM <- train(
    as.factor(FLOOR) ~  .,
    data = training  %>% select(starts_with("WAP"), FLOOR),
    method = "svmRadialSigma",
    #preProc = c("center", "scale"),
    tuneLength = 6,
    trControl = ctrl
    
  )
  name <- paste0("FFit1SVM",B)
  assign(name , FFit1SVM) 
  rm(FFit1SVM,testing)
}

F_save_models(FFit1SVMX0,FFit1SVMX1,FFit1SVMX2)
