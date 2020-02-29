source("Scripts/Preparetion/funk_save_models.R")
library(caret)
library(mlbench)
library(LiblineaR)
set.seed(123)

DATA_FOR_MODEL_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/DATA_FOR_MODEL_N.RDS") 


ctrl <- trainControl(method = "repeatedcv", repeats = 3,verboseIter = TRUE) #crossvalidation 3 razy powtórzona | number = (defaults to 10) 



#all traning data:
set.seed(123)
BFit6SVMSig7ID1 <- train(
  as.factor(BUILDINGID) ~  .,
  data = DATA_FOR_MODEL_N %>% select(starts_with("WAP"), BUILDINGID),
  method = "svmRadialSigma",
  #preProc = c("center", "scale"),
  tuneLength = 6, # ile różnych parametrów ma sprawdzić
  # The tuneGrid parameter lets us decide which values the main parameter will take
  # While tuneLength only limit the number of default parameters to use.
  
  trControl = ctrl #- metoda resamplingu #domyślnie bootstrap
)


# output ------------------------------------------------------------------

F_save_models(BFit6SVMSig7ID1)
