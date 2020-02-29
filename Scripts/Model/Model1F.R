# model na danych po obróbce
# tylko jeden rezultat dla każdej sesji


# load --------------------------------------------------------------------
source("Scripts/Preparetion/funk_save_models.R")
library(caret)
library(mlbench)
library(LiblineaR)
set.seed(123)
DATA_FOR_MODEL_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/DATA_FOR_MODEL_N.RDS") 


# subsets  ----------------------------------------------------------------
inTrain <- createDataPartition(
  y = DATA_FOR_MODEL_N$BUILDINGID, ## the outcome data are needed
  p = .75, ## The percentage of data in the training set
  list = FALSE ## The format of the results
  
)
## The output is a set of integers for the rows  that belong in the training set.
str(inTrain)
barplot(prop.table(table(DATA_FOR_MODEL_N$FLOOR)))  #sprawdzenie rozkładu przez podziałem
# hist() działa dla factor, ale tylko jeśli jest liczbą, po zmianie na name już nie działa


##
training1F <- DATA_FOR_MODEL_N[inTrain,] 
testing1F <- DATA_FOR_MODEL_N[-inTrain,]

nrow(training)
nrow(testing)
barplot(prop.table(table(training$FLOOR))) #sprawdzenie rozkładu po podziale
barplot(prop.table(table(testing$FLOOR))) #sprawdzenie rozkładu po podziale

# model building -------------------------------------------------------------------
# control

ctrl <- trainControl(method = "repeatedcv", repeats = 3,verboseIter = TRUE) #crossvalidation 3 razy powtórzona | number = (defaults to 10) 


# ---MODELS ----------------------------------------------------------------------
set.seed(123)
FFit1SVMSig7ID1_T <- train(
  as.factor(FLOOR) ~  .,
  data = training1F %>% select(starts_with("WAP"), BUILDINGID,FLOOR),
  method = "svmRadialSigma",
  #preProc = c("center", "scale"),
  tuneLength = 6, # ile różnych parametrów ma sprawdzić
  # The tuneGrid parameter lets us decide which values the main parameter will take
  # While tuneLength only limit the number of default parameters to use.
  
  trControl = ctrl #- metoda resamplingu #domyślnie bootstrap
)


# output ------------------------------------------------------------------


F_save_models(FFit1SVMSig7ID1)
testing1F <- testing 
saveRDS(testing1F,"Data/models/testing1F.RDS")
