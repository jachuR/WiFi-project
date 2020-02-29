# modele na surowych danych 
# usunięte nieaktywne WAPy


# load --------------------------------------------------------------------
source("Scripts/Preparetion/funk_save_models.R")
library(caret)
library(mlbench)
set.seed(123)
tData<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID.RDS") 


# subsets  ----------------------------------------------------------------
inTrain <- createDataPartition(
  y = tData$BUILDINGID, ## the outcome data are needed
  p = .75, ## The percentage of data in the training set
  list = FALSE ## The format of the results
  
)
## The output is a set of integers for the rows of Sonar that belong in the training set.
str(inTrain)
hist(tData$BUILDINGID) #sprawdzenie rozkładu przez podziałem

##
training <- tData[inTrain,] 
testing  <- tData[-inTrain,]

nrow(training)
nrow(testing)
hist(training$BUILDINGID) #sprawdzenie rozkładu po podziale
hist(testing$BUILDINGID) #sprawdzenie rozkładu po podziale

# model building -------------------------------------------------------------------
# control

ctrl <- trainControl(method = "repeatedcv", repeats = 3) 
#crossvalidation 5 razy powtórzona | liczba foldów - number = (defaults to 10) 


# -------------------------------------------------------------------------

# rpart

BFit1rpart <- train(
  as.factor(BUILDINGID) ~  ., # chcemy przewidziec buiding ID ale jako factor, używając wszystkich pozostałych kolumn (~ .)
  data = training %>% select(starts_with("WAP"), BUILDINGID), # dopiero tutaj definiujemy dane których używamy w linijce wyżej :/
  method = "rpart", # wybór modelu
  #preProc = c("center", "scale"),
  tuneLength = 5, # ile różnych wartości podstawowego parametru ma być przetestowane
  ## added:
  trControl = ctrl #- metoda resamplingu #domyślnie bootstrap
)

# KKNN

BFit1KKNN <- train(
  as.factor(BUILDINGID) ~  .,
  data = training %>% select(starts_with("WAP"), BUILDINGID),
  method = "kknn", # "pls",
  #preProc = c("center", "scale"),
  tuneLength = 5,
  ## added:
  trControl = ctrl #- metoda resamplingu #domyślnie bootstrap
)

F_save_models(BFit1KKNN,BFit1rpart)      
