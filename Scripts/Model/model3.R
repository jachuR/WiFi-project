# model na danych po obróbce
# tylko jeden rezultat dla każdej sesji


# load --------------------------------------------------------------------
source("Scripts/Preparetion/funk_save_models.R")
library(caret)
library(mlbench)
library(LiblineaR)
set.seed(123)
MEDIAN_per_session_NA <- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/MEDIAN_per_session_NA.RDS") 
MEDIAN_per_session_NA_name <- MEDIAN_per_session_NA
MEDIAN_per_session_NA_name$BUILDINGID <-  make.names(MEDIAN_per_session_NA$BUILDINGID) #make.names() dodanie litery do liczby ("X1") żeby dało się użyć classProbs

# subsets  ----------------------------------------------------------------
inTrain <- createDataPartition(
  y = MEDIAN_per_session_NA_name$BUILDINGID, ## the outcome data are needed
  p = .75, ## The percentage of data in the training set
  list = FALSE ## The format of the results
  
)
## The output is a set of integers for the rows  that belong in the training set.
str(inTrain)
barplot(prop.table(table(MEDIAN_per_session_NA_name$BUILDINGID)))  #sprawdzenie rozkładu przez podziałem
# hist() działa dla factor, ale tylko jeśli jest liczbą, po zmianie na name już nie działa


##
training <- MEDIAN_per_session_NA_name[inTrain,] 
testing  <- MEDIAN_per_session_NA_name[-inTrain,]

nrow(training)
nrow(testing)
barplot(prop.table(table(training$BUILDINGID))) #sprawdzenie rozkładu po podziale
barplot(prop.table(table(testing$BUILDINGID))) #sprawdzenie rozkładu po podziale

# model building -------------------------------------------------------------------
# control

ctrl <- trainControl(method = "repeatedcv", repeats = 3) #crossvalidation 3 razy powtórzona | number = (defaults to 10) 


# ---MODELS ----------------------------------------------------------------------

set.seed(123)
BFit3SVMSig <- train(
  as.factor(BUILDINGID) ~  .,
  data = training %>% select(starts_with("WAP"), BUILDINGID),
  method = "svmRadialSigma",
  #preProc = c("center", "scale"),
  tuneLength = 6, # ile różnych parametrów ma sprawdzić
  # The tuneGrid parameter lets us decide which values the main parameter will take
  # While tuneLength only limit the number of default parameters to use.
  
  trControl = ctrl #- metoda resamplingu #domyślnie bootstrap
)
set.seed(123)
BFit3SVMSig_prob <- train(
  as.factor(BUILDINGID) ~  .,
  data = training %>% select(starts_with("WAP"), BUILDINGID),
  method = "svmRadialSigma",
  #preProc = c("center", "scale"),
  tuneLength = 6, # ile różnych parametrów ma sprawdzić
  # The tuneGrid parameter lets us decide which values the main parameter will take
  # While tuneLength only limit the number of default parameters to use.
  
  trControl = trainControl(method = "repeatedcv", repeats = 3, classProbs =  TRUE)
  # classProbs jeśli chcemy późnie móc sprawdzić z jakim prawdopodobieńswtem obiek nalezy do danej klasy
)


# output ------------------------------------------------------------------


F_save_models(BFit3SVMSig)
F_save_models(BFit3SVMSig_prob)
