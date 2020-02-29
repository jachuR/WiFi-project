#trying model  

source("Scripts/Preparetion/funk_save_models.R")
library(caret)
library(mlbench)
library(LiblineaR)
set.seed(123)
MEDIAN_per_session_rem_NA <- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/MEDIAN_per_session_rem_NA.RDS") 
MEDIAN_per_session_NA_name <- MEDIAN_per_session_rem_NA
MEDIAN_per_session_NA_name$BUILDINGID <-  make.names(MEDIAN_per_session_rem_NA$BUILDINGID) #make.names() dodanie litery do liczby ("X1") żeby dało się użyć classProbs





# pre-procesing -----------------------------------------------------------



tData_refID_WAPu_sesionID_rem_19 <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID_rem_19.RDS")
tData_refID_WAPu_sesionID_rem_19_NA <- tData_refID_WAPu_sesionID_rem_19
WAP_cols_list <-vars_select(colnames(tData_refID_WAPu_sesionID_rem_19_NA), starts_with("WAP")) #lista wszystkich wapów
tData_refID_WAPu_sesionID_rem_19_NA <- replace.value(tData_refID_WAPu_sesionID_rem_19_NA, WAP_cols_list , from = 100, to = - 120)

MEDIAN_per_session_rem19_NA<- tData_refID_WAPu_sesionID_rem_19_NA %>%  
  group_by(LONGITUDE, LATITUDE, BUILDINGID, FLOOR, SPACEID, PHONEID, USERID, RELATIVEPOSITION, sesion_ID,group) %>% #wszystkie pozostałe kolumny do group_by zeby zachowac je w wynikowej kolumnie
  summarise_at(WAP_cols_list,median) %>%  ungroup()

MEDIAN_per_session_NA_name <- MEDIAN_per_session_rem19_NA
MEDIAN_per_session_NA_name$BUILDINGID <-  make.names(MEDIAN_per_session_NA_name$BUILDINGID)
output <- MEDIAN_per_session_NA_name %>% filter(USERID !=1 )


saveRDS(tData_refID_WAPu_sesionID_rem_19_NA,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID_rem_19_NA.RDS")
saveRDS(MEDIAN_per_session_NA_name,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/MEDIAN_per_session_NA_name.RDS" )
rm(tData_refID_WAPu_sesionID_rem_19,MEDIAN_per_session_rem19_NA)




ctrl <- trainControl(method = "repeatedcv", repeats = 3,verboseIter = TRUE) #crossvalidation 3 razy powtórzona | number = (defaults to 10) 

#all traning data:
set.seed(123)
BFit5SVMSig7ID1 <- train(
  as.factor(BUILDINGID) ~  .,
  data = output %>% select(starts_with("WAP"), BUILDINGID),
  method = "svmRadialSigma",
  #preProc = c("center", "scale"),
  tuneLength = 6, # ile różnych parametrów ma sprawdzić
  # The tuneGrid parameter lets us decide which values the main parameter will take
  # While tuneLength only limit the number of default parameters to use.
  
  trControl = ctrl #- metoda resamplingu #domyślnie bootstrap
)