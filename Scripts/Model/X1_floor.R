# -------------------------------------------------------------------------
source("Scripts/Preparetion/funk_save_models.R")
library(caret)
library(mlbench)
library(LiblineaR)
set.seed(123)
DATA_FOR_MODEL_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/DATA_FOR_MODEL_N.RDS") 
vData_refID_WAPu_NA_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/vData_refID_WAPu_NA_N.RDS")




data_buil <- DATA_FOR_MODEL_N %>% filter(BUILDINGID == "X1")
vData_refID_WAPu_NA_N_X1 <- vData_refID_WAPu_NA_N %>% filter(BUILDINGID == "X1")
rm(vData_refID_WAPu_NA_N,DATA_FOR_MODEL_N)




#removing 0v WAPS
acctiveWAP_tdata <- apply(select(data_buil,starts_with("WAP")),2,var)!=0
acctiveWAP_vdata <- apply(select(vData_refID_WAPu_NA_N_X1,starts_with("WAP")),2,var)!=0

sum(acctiveWAP_tdata)
sum(acctiveWAP_vdata)


data_buil <- cbind(select(data_buil ,starts_with("WAP"))[,acctiveWAP_tdata & acctiveWAP_vdata],
                          select(data_buil,-starts_with("WAP")))

vData_refID_WAPu_NA_N_X1 <-  cbind(select(vData_refID_WAPu_NA_N_X1 ,starts_with("WAP"))[,acctiveWAP_tdata & acctiveWAP_vdata],
                                    select(vData_refID_WAPu_NA_N_X1,-starts_with("WAP")))



ctrl <- trainControl(method = "repeatedcv", repeats = 3,verboseIter = TRUE) #crossvalidation 3 razy powtórzona | number = (defaults to 10)

set.seed(123)
FFit3SVM_X1<- train(
  as.factor(FLOOR) ~  .,
  data = data_buil %>% select(starts_with("WAP"),  FLOOR),
  method = "svmRadialSigma",
  #preProc = c("center", "scale"),
  tuneLength = 6,
  trControl = ctrl
  
)

F_save_models(FFit3SVM_X1)



ctrl <- trainControl(method = "repeatedcv", repeats = 3,verboseIter = TRUE) #crossvalidation 3 razy powtórzona | number = (defaults to 10)

set.seed(123)
FFit3kknn_X1<- train(
  as.factor(FLOOR) ~  .,
  data = data_buil %>% select(starts_with("WAP"),  FLOOR),
  method = "kknn",
  #preProc = c("center", "scale"),
  tuneLength = 6,
  trControl = ctrl
  
)

F_save_models(FFit3kknn_X1)


# -------------------------------------------------------------------------


# check -------------------------------------------------------------------

F_pred_f <- read_rds("Scripts/Preparetion/F_pred_f.RDS")
F_pred_f(test_data = vData_refID_WAPu_NA_N_X1,model = FFit3knn_X1_S)

