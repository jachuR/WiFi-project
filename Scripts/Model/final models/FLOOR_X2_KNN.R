###
#ONLY strong signal
source("Scripts/Preparetion/funk_save_models.R")
set.seed(123)
DATA_FOR_MODEL_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/DATA_FOR_MODEL_N.RDS") 
vData <- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/FinnalTable.RDS")

data_buil <- DATA_FOR_MODEL_N %>% mutate(BuilPRED = BUILDINGID) %>%  filter(BuilPRED == "X2")
vData_refID_WAPu_NA_N_X2 <- vData %>% filter(BuilPRED == "X2")


names_WAPs <- vars_select(colnames(data_buil), starts_with("WAP")) #lista wszystkich wapów


th = 0.85
a <- data_buil[,names_WAPs]
a[a < th] <-0 
data_buil[,names_WAPs] <- a
b <- vData_refID_WAPu_NA_N_X2[,names_WAPs]
b[b < th] <-0 
vData_refID_WAPu_NA_N_X2[,names_WAPs] <- b


#removing 0v WAPS
acctiveWAP_tdata <- apply(select(data_buil,starts_with("WAP")),2,var)!=0
acctiveWAP_vdata <- apply(select(vData_refID_WAPu_NA_N_X2,starts_with("WAP")),2,var)!=0

sum(acctiveWAP_tdata)
sum(acctiveWAP_vdata)


data_buil <- cbind(select(data_buil ,starts_with("WAP"))[,acctiveWAP_tdata | acctiveWAP_vdata],
                   select(data_buil,-starts_with("WAP")))

vData_refID_WAPu_NA_N_X2 <-  cbind(select(vData_refID_WAPu_NA_N_X2,starts_with("WAP"))[,acctiveWAP_tdata | acctiveWAP_vdata],
                                   select(vData_refID_WAPu_NA_N_X2,-starts_with("WAP")))


#KNN
ctrl <- trainControl(method = "repeatedcv", repeats = 3,verboseIter = TRUE) #crossvalidation 3 razy powtórzona | number = (defaults to 10)

set.seed(123)
FFit3knn_X2_S<- train(
  as.factor(FLOOR) ~  .,
  data = data_buil %>% select(starts_with("WAP"),  FLOOR),
  method = "knn",
  #preProc = c("center", "scale"),
  tuneGrid = expand.grid(k = c(3:8)),
  trControl = ctrl
  
)

# output ------------------------------------------------------------------

#source(file = "Scripts/Preparetion/funk_save_models.R")
saveRDS(FFit3knn_X2_S,"Data/Results/models/FFit3knn_X2_S.RDS")


# check -------------------------------------------------------------------

source(file = "Scripts/Model/fun_floor_check.R")
F_pred_f(test_data = vData_refID_WAPu_NA_N_X2,model = FFit3knn_X2_S)




# output ------------------------------------------------------------------
vData <- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/FinnalTable.RDS")
vData_refID_WAPu_NA_N_X2 <- vData %>% filter(BuilPRED == "X2")
FinnalTableX2F <- vData %>% filter(BuilPRED == "X2")
FinnalTableX2F$FLOOR_PRED <- pred_loc

saveRDS(FinnalTableX2F,"Data/Results/FinnalTableX2F.RDS")


# RESULTS


# Confusion Matrix and Statistics
# 
# Reference
# Prediction   0   1   2   3   4
# 0  23   4   0   0   0
# 1   1 107   2   1   2
# 2   0   0  52   0   0
# 3   0   0   0  38   4
# 4   0   0   0   1  33
# 
# Overall Statistics
# 
# Accuracy : 0.944           
# 95% CI : (0.9094, 0.9683)
# No Information Rate : 0.4142          
# P-Value [Acc > NIR] : < 2.2e-16       
# 
# Kappa : 0.9239          
# 
# Mcnemar's Test P-Value : NA              
# 
# Statistics by Class:
# 
#                      Class: 0 Class: 1 Class: 2 Class: 3 Class: 4
# Sensitivity           0.95833   0.9640   0.9630   0.9500   0.8462
# Specificity           0.98361   0.9618   1.0000   0.9825   0.9956
# Pos Pred Value        0.85185   0.9469   1.0000   0.9048   0.9706
# Neg Pred Value        0.99585   0.9742   0.9907   0.9912   0.9744
# Prevalence            0.08955   0.4142   0.2015   0.1493   0.1455
# Detection Rate        0.08582   0.3993   0.1940   0.1418   0.1231
# Detection Prevalence  0.10075   0.4216   0.1940   0.1567   0.1269
# Balanced Accuracy     0.97097   0.9629   0.9815   0.9662   0.9209
# 
