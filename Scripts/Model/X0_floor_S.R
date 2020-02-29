###
#ONLY strong signal
source("Scripts/Preparetion/funk_save_models.R")
set.seed(123)
DATA_FOR_MODEL_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/DATA_FOR_MODEL_N.RDS") 
vData_refID_WAPu_NA_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/vData_refID_WAPu_NA_N.RDS")

data_buil <- DATA_FOR_MODEL_N %>% filter(BUILDINGID == "X0")
vData_refID_WAPu_NA_N_X0 <- vData_refID_WAPu_NA_N %>% filter(BUILDINGID == "X0")
rm(vData_refID_WAPu_NA_N,DATA_FOR_MODEL_N)

names_WAPs <- vars_select(colnames(data_buil), starts_with("WAP")) #lista wszystkich wapów


a <- data_buil[,names_WAPs]
a[a < 0.0] <-0 
data_buil[,names_WAPs] <- a
b <- vData_refID_WAPu_NA_N_X0[,names_WAPs]
b[b < 0.0] <-0 
vData_refID_WAPu_NA_N_X0[,names_WAPs] <- b

# #removing 0v WAPS
# acctiveWAP_tdata <- apply(select(data_buil,starts_with("WAP")),2,var)!=0
# acctiveWAP_vdata <- apply(select(vData_refID_WAPu_NA_N_X0,starts_with("WAP")),2,var)!=0
# 
# sum(acctiveWAP_tdata)
# sum(acctiveWAP_vdata)
# 
# 
# data_buil <- cbind(select(data_buil ,starts_with("WAP"))[,acctiveWAP_tdata & acctiveWAP_vdata],
#                    select(data_buil,-starts_with("WAP")))
# 
# vData_refID_WAPu_NA_N_X0 <-  cbind(select(vData_refID_WAPu_NA_N_X0 ,starts_with("WAP"))[,acctiveWAP_tdata & acctiveWAP_vdata],
#                                    select(vData_refID_WAPu_NA_N_X0,-starts_with("WAP")))



# #KNN
# ctrl <- trainControl(method = "repeatedcv", repeats = 3,verboseIter = TRUE) #crossvalidation 3 razy powtórzona | number = (defaults to 10)
# 
# set.seed(123)
# FFit3knn_X0_S<- train(
#   as.factor(FLOOR) ~  .,
#   data = data_buil %>% select(starts_with("WAP"),  FLOOR),
#   method = "knn",
#   #preProc = c("center", "scale"),
#   tuneLength = 6,
#   trControl = ctrl
#   
# )
# 
# F_save_models(FFit3knn_X0_S)
# F_pred_f <- read_rds("Scripts/Preparetion/F_pred_f.RDS")
# F_pred_f(test_data = vData_refID_WAPu_NA_N_X0,model = FFit3knn_X0_S)


#SVM

ctrl <- trainControl(method = "repeatedcv", repeats = 3,verboseIter = TRUE) #crossvalidation 3 razy powtórzona | number = (defaults to 10)

set.seed(123)
FFit3svm_X0_S<- train(
  as.factor(FLOOR) ~  .,
  data = data_buil %>% select(starts_with("WAP"),  FLOOR),
  method = "svmRadialSigma",
  #preProc = c("center", "scale"),
  tuneLength = 6,
  trControl = ctrl
  
)

F_save_models(FFit3svm_X0_S)

# check -------------------------------------------------------------------

F_pred_f <- read_rds("Scripts/Preparetion/F_pred_f.RDS")
F_pred_f(test_data = vData_refID_WAPu_NA_N_X0,model = FFit3svm_X0_S)
