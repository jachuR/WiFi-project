# model na danych po obróbce
# tylko jeden rezultat dla każdej sesji


# load --------------------------------------------------------------------
source("Scripts/Preparetion/funk_save_models.R")
library(caret)
library(mlbench)
library(LiblineaR)
set.seed(123)
MEDIAN_per_session<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/MEDIAN_per_session.RDS") 



# subsets  ----------------------------------------------------------------
inTrain <- createDataPartition(
  y = MEDIAN_per_session$BUILDINGID, ## the outcome data are needed
  p = .75, ## The percentage of data in the training set
  list = FALSE ## The format of the results
  
)
## The output is a set of integers for the rows  that belong in the training set.
str(inTrain)
hist(MEDIAN_per_session$BUILDINGID) #sprawdzenie rozkładu przez podziałem

##
training <- MEDIAN_per_session[inTrain,] 
testing  <- MEDIAN_per_session[-inTrain,]

nrow(training)
nrow(testing)
hist(training$BUILDINGID) #sprawdzenie rozkładu po podziale
hist(testing$BUILDINGID) #sprawdzenie rozkładu po podziale

# model building -------------------------------------------------------------------
# control

ctrl <- trainControl(method = "repeatedcv", repeats = 3) #crossvalidation 3 razy powtórzona | number = (defaults to 10) 


# ---MODELS ----------------------------------------------------------------------

BFit2rpart <- train(
  as.factor(BUILDINGID) ~  .,
  data = training %>% select(starts_with("WAP"), BUILDINGID),
  method = "rpart", # "pls",
  #preProc = c("center", "scale"),
  tuneLength = 5,
  trControl = ctrl #- metoda resamplingu #domyślnie bootstrap
)


BFit2KNN <- train(
  as.factor(BUILDINGID) ~  .,
  data = training %>% select(starts_with("WAP"), BUILDINGID),
  method = "knn", # "pls",
  #preProc = c("center", "scale"),
  tuneLength = 5, # ile różnych parametrów ma sprawdzić
                  # The tuneGrid parameter lets us decide which values the main parameter will take
                  # While tuneLength only limit the number of default parameters to use.
 
  trControl = ctrl #- metoda resamplingu #domyślnie bootstrap
)


BFit2KKNN <- train(
  as.factor(BUILDINGID) ~  .,
  data = training %>% select(starts_with("WAP"), BUILDINGID),
  method = "kknn",
  #preProc = c("center", "scale"),
  tuneLength = 5, # ile różnych parametrów ma sprawdzić
  # The tuneGrid parameter lets us decide which values the main parameter will take
  # While tuneLength only limit the number of default parameters to use.
  
  trControl = ctrl #- metoda resamplingu #domyślnie bootstrap
)


BFit2SVM <- train(
  as.factor(BUILDINGID) ~  .,
  data = training %>% select(starts_with("WAP"), BUILDINGID),
  method = "svmRadial",
  #preProc = c("center", "scale"),
  tuneLength = 5, # ile różnych parametrów ma sprawdzić
  # The tuneGrid parameter lets us decide which values the main parameter will take
  # While tuneLength only limit the number of default parameters to use.
  
  trControl = ctrl #- metoda resamplingu #domyślnie bootstrap
)

BFit2SVMSig <- train(
  as.factor(BUILDINGID) ~  .,
  data = training %>% select(starts_with("WAP"), BUILDINGID),
  method = "svmRadialSigma",
  #preProc = c("center", "scale"),
  tuneLength = 6, # ile różnych parametrów ma sprawdzić
  # The tuneGrid parameter lets us decide which values the main parameter will take
  # While tuneLength only limit the number of default parameters to use.
  
  trControl = ctrl #- metoda resamplingu #domyślnie bootstrap
)

# output ------------------------------------------------------------------


F_save_models(BFit2KKNN,BFit2KNN,BFit2rpart,BFit2SVM)
F_save_models(BFit2SVMSig)
