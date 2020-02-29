###
#ONLY strong signal
source("Scripts/Preparetion/funk_save_models.R")
set.seed(123)
DATA_FOR_MODEL_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/DATA_FOR_MODEL_N.RDS") 
vData <- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/FinnalTable.RDS")

data_buil <- DATA_FOR_MODEL_N %>%  mutate(BuilPRED = BUILDINGID) %>%  filter(BuilPRED == "X0")
vData_refID_WAPu_NA_N_X0 <- vData %>% filter(BuilPRED == "X0")
rm(vData ,DATA_FOR_MODEL_N)

names_WAPs <- vars_select(colnames(data_buil), starts_with("WAP")) #lista wszystkich wapów


a <- data_buil[,names_WAPs]
a[a < 0.0] <-0 
data_buil[,names_WAPs] <- a
b <- vData_refID_WAPu_NA_N_X0[,names_WAPs]
b[b < 0.0] <-0 
vData_refID_WAPu_NA_N_X0[,names_WAPs] <- b


ctrl <- trainControl(method = "repeatedcv", repeats = 3,verboseIter = TRUE) #crossvalidation 3 razy powtórzona | number = (defaults to 10)

set.seed(123)
FFit3svm_X0_S<- train(
  as.factor(FLOOR) ~  .,
  data = data_buil %>% select(starts_with("WAP"),  FLOOR),
  method = "svmRadialSigma",
  #preProc = c("center", "scale"),
  tuneLength = 10,
  trControl = ctrl
  
)

# output ------------------------------------------------------------------

source(file = "Scripts/Preparetion/funk_save_models.R")
F_save_models(FFit3svm_X0_S,filename = "Data/Results/models/FFit3svm_X0_S.RDS")


# check -------------------------------------------------------------------

F_pred_f <- read_rds("Scripts/Preparetion/F_pred_f.RDS")
F_pred_f(test_data = vData_refID_WAPu_NA_N_X0,model = FFit3svm_X0_S)

# output ------------------------------------------------------------------

FinnalTableX0F <- vData_refID_WAPu_NA_N_X0
FinnalTableX0F$FLOOR_PRED <- pred_loc

saveRDS(FinnalTableX0F,"Data/Results/FinnalTableX0F.RDS")


# RESULTS


# Confusion Matrix and Statistics
# 
# Reference
# Prediction   0   1   2   3
# 0  73   2   0   0
# 1   3 203   5   0
# 2   2   3 160   6
# 3   0   0   0  79
# 
# Overall Statistics
# 
# Accuracy : 0.9608          
# 95% CI : (0.9407, 0.9756)
# No Information Rate : 0.3881          
# P-Value [Acc > NIR] : < 2.2e-16       
# 
# Kappa : 0.9444          
# 
# Mcnemar's Test P-Value : NA              
# 
# Statistics by Class:
# 
#                      Class: 0 Class: 1 Class: 2 Class: 3
# Sensitivity            0.9359   0.9760   0.9697   0.9294
# Specificity            0.9956   0.9756   0.9704   1.0000
# Pos Pred Value         0.9733   0.9621   0.9357   1.0000
# Neg Pred Value         0.9892   0.9846   0.9863   0.9869
# Prevalence             0.1455   0.3881   0.3078   0.1586
# Detection Rate         0.1362   0.3787   0.2985   0.1474
# Detection Prevalence   0.1399   0.3937   0.3190   0.1474
# Balanced Accuracy      0.9658   0.9758   0.9700   0.9647