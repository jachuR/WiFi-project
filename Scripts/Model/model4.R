# model na danych po obróbce
# tylko jeden rezultat dla każdej sesji


# load --------------------------------------------------------------------
source("Scripts/Preparetion/funk_save_models.R")
library(caret)
library(mlbench)
library(LiblineaR)
set.seed(123)
MEDIAN_per_session_rem_NA <- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/MEDIAN_per_session_rem_NA.RDS") 
MEDIAN_per_session_NA_name <- MEDIAN_per_session_rem_NA
MEDIAN_per_session_NA_name$BUILDINGID <-  make.names(MEDIAN_per_session_rem_NA$BUILDINGID) #make.names() dodanie litery do liczby ("X1") żeby dało się użyć classProbs

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

ctrl <- trainControl(method = "repeatedcv", repeats = 3,verboseIter = TRUE) #crossvalidation 3 razy powtórzona | number = (defaults to 10) 


# ---MODELS ----------------------------------------------------------------------

# -------------------------------------------------------------------------


set.seed(123)
BFit4SVMSig <- train(
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
BFit4knn <- train(
  as.factor(BUILDINGID) ~  .,
  data = training %>% select(starts_with("WAP"), BUILDINGID),
  method = "knn",
  #preProc = c("center", "scale"),
  tuneGrid = expand.grid(k = c(1:10)),
  trControl = ctrl
)


# The tuneGrid parameter lets us decide which values the main parameter will take
# While tuneLength only limit the number of default parameters to use.



# -------------------------------------------------------------------------

#try with ID7 
tData_refID_WAPu_sesionID_rem_19 <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID_rem_19.RDS")
tData_refID_WAPu_sesionID_rem_19_NA <- tData_refID_WAPu_sesionID_rem_19
WAP_cols_list <-vars_select(colnames(tData_refID_WAPu_sesionID_rem_19_NA), starts_with("WAP")) #lista wszystkich wapów
tData_refID_WAPu_sesionID_rem_19_NA <- replace.value(tData_refID_WAPu_sesionID_rem_19_NA, WAP_cols_list , from = 100, to = - 120)

MEDIAN_per_session_rem19_NA<- tData_refID_WAPu_sesionID_rem_19_NA %>%  
  group_by(LONGITUDE, LATITUDE, BUILDINGID, FLOOR, SPACEID, PHONEID, USERID, RELATIVEPOSITION, sesion_ID,group) %>% #wszystkie pozostałe kolumny do group_by zeby zachowac je w wynikowej kolumnie
  summarise_at(WAP_cols_list,median) %>%  ungroup()

MEDIAN_per_session_NA_name <- MEDIAN_per_session_rem19_NA
MEDIAN_per_session_NA_name$BUILDINGID <-  make.names(MEDIAN_per_session_NA_name$BUILDINGID)
output <- MEDIAN_per_session_NA_name %>% filter(USERID ==1 )

saveRDS(tData_refID_WAPu_sesionID_rem_19_NA,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID_rem_19_NA.RDS")
saveRDS(MEDIAN_per_session_NA_name,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/MEDIAN_per_session_NA_name.RDS" )
rm(tData_refID_WAPu_sesionID_rem_19,MEDIAN_per_session_rem19_NA)



set.seed(123)
BFit4SVMSig7 <- train(
  as.factor(BUILDINGID) ~  .,
  data = training %>% select(starts_with("WAP"), BUILDINGID),
  method = "svmRadialSigma",
  #preProc = c("center", "scale"),
  tuneLength = 6, # ile różnych parametrów ma sprawdzić
  # The tuneGrid parameter lets us decide which values the main parameter will take
  # While tuneLength only limit the number of default parameters to use.
  
  trControl = ctrl #- metoda resamplingu #domyślnie bootstrap
)

#same for all data:
set.seed(123)
BFit4SVMSig7 <- train(
  as.factor(BUILDINGID) ~  .,
  data = MEDIAN_per_session_NA_name %>% select(starts_with("WAP"), BUILDINGID),
  method = "svmRadialSigma",
  #preProc = c("center", "scale"),
  tuneLength = 6, # ile różnych parametrów ma sprawdzić
  # The tuneGrid parameter lets us decide which values the main parameter will take
  # While tuneLength only limit the number of default parameters to use.
  
  trControl = ctrl #- metoda resamplingu #domyślnie bootstrap
)


set.seed(123)
BFit4KNN7 <- train(
  as.factor(BUILDINGID) ~  .,
  data = MEDIAN_per_session_NA_name %>% select(starts_with("WAP"), BUILDINGID),
  method = "knn",
  #preProc = c("center", "scale"),
  tuneGrid = expand.grid(k = c(1:4)),
  # The tuneGrid parameter lets us decide which values the main parameter will take
  # While tuneLength only limit the number of default parameters to use.
  
  trControl = ctrl #- metoda resamplingu #domyślnie bootstrap
)




# -------------------------------------------------------------------------









# output ------------------------------------------------------------------


F_save_models(BFit4SVMSig)
F_save_models(BFit4knn)
F_save_models(BFit4SVMSig7)
