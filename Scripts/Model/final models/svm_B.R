DATA_FOR_MODEL_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/DATA_FOR_MODEL_N.RDS") 


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
source(file = "Scripts/Preparetion/funk_save_models.R")
F_save_models(BFit6SVMSig7ID1,filename = "Data/Results/models/BFit6SVMSig7ID1.RDS")



# Check -------------------------------------------------------------------


fun_pred_check_building <- readRDS(file = "Data/Results/functions/fun_pred_check_building.RDS")
vData<- read_rds("Data/Clean/vData_refID_WAPu_NA_N.RDS")
fun_pred_check_building(model = BFit6SVMSig7ID1,test_data = vData)



# output ------------------------------------------------------------------

FinnalTable <- vData
FinnalTable$BuilPRED <- pred_loc

saveRDS(FinnalTable,"Data/Results/FinnalTable.RDS")


# RESULTS


# Reference
# Prediction  X0  X1  X2
# X0 536   0   0
# X1   0 307   0
# X2   0   0 268
# 
# Overall Statistics
# 
# Accuracy : 1          
# 95% CI : (0.9967, 1)
# No Information Rate : 0.4824     
# P-Value [Acc > NIR] : < 2.2e-16  
# 
# Kappa : 1          
# 
# Mcnemar's Test P-Value : NA         
# 
# Statistics by Class:
# 
#                      Class: X0 Class: X1 Class: X2
# Sensitivity             1.0000    1.0000    1.0000
# Specificity             1.0000    1.0000    1.0000
# Pos Pred Value          1.0000    1.0000    1.0000
# Neg Pred Value          1.0000    1.0000    1.0000
# Prevalence              0.4824    0.2763    0.2412
# Detection Rate          0.4824    0.2763    0.2412
# Detection Prevalence    0.4824    0.2763    0.2412
# Balanced Accuracy       1.0000    1.0000    1.0000


