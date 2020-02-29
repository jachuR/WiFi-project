# -------------------------------------------------------------------------
source("Scripts/Preparetion/funk_save_models.R")
library(caret)
library(mlbench)
library(LiblineaR)
set.seed(123)
DATA_FOR_MODEL_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/DATA_FOR_MODEL_N.RDS") 


#TESTYYYY

data_buil <- DATA_FOR_MODEL_N 
ctrl <- trainControl(method = "repeatedcv", repeats = 3,verboseIter = TRUE) #crossvalidation 3 razy powtórzona | number = (defaults to 10)

# #removing 0v WAPS
# acctiveWAP_tdata <- apply(select(data_buil,starts_with("WAP")),2,var)!=0
# sum(acctiveWAP_tdata)
# data_buil <- cbind(select(data_buil ,starts_with("WAP"))[,acctiveWAP_tdata],
#                           select(training,-starts_with("WAP")))

# subsets  ----------------------------------------------------------------
inTrain <- createDataPartition(
  y = data_buil$FLOOR, ## the outcome data are needed
  p = .75, ## The percentage of data in the training set
  list = FALSE ## The format of the results
  
)

barplot(prop.table(table(data_buil$FLOOR)),main = paste("before"))



##
training <- data_buil[inTrain,] 
testing  <- data_buil[-inTrain,]

barplot(prop.table(table(training$FLOOR)),main = paste("training")) #sprawdzenie rozkładu po podziale
barplot(prop.table(table(testing$FLOOR)),main = paste("testing")) #sprawdzenie rozkładu po podziale


# #removing 0v WAPS
# acctiveWAP_tdata <- apply(select(training,starts_with("WAP")),2,var)!=0
# sum(acctiveWAP_tdata)
# training <- cbind(select(training ,starts_with("WAP"))[,acctiveWAP_tdata],
#                           select(training,-starts_with("WAP")))



set.seed(123)
FFit1SVM_subset <- train(
  as.factor(FLOOR) ~  .,
  data = training %>% select(starts_with("WAP"), BUILDINGID, FLOOR),
  method = "svmRadialSigma",
  #preProc = c("center", "scale"),
  tuneLength = 6,
  trControl = ctrl
  
)

F_save_models(FFit1SVM_subset)
