###
#ONLY strong signal
source("Scripts/Preparetion/funk_save_models.R")
set.seed(123)
DATA_FOR_MODEL_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/DATA_FOR_MODEL_N.RDS") 
vData <- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/FinnalTable.RDS")

data_buil <- DATA_FOR_MODEL_N %>% mutate(BuilPRED = BUILDINGID) %>%  filter(BuilPRED == "X1")
vData_refID_WAPu_NA_N_X1 <- vData %>% filter(BuilPRED == "X1")

names_WAPs <- vars_select(colnames(data_buil), starts_with("WAP")) #lista wszystkich wapów


a <- data_buil[,names_WAPs]
a[a < 0.85] <-0 
data_buil[,names_WAPs] <- a
b <- vData_refID_WAPu_NA_N_X1[,names_WAPs]
b[b < 0.85] <-0 
vData_refID_WAPu_NA_N_X1[,names_WAPs] <- b



#KNN
ctrl <- trainControl(method = "repeatedcv", repeats = 3,verboseIter = TRUE) #crossvalidation 3 razy powtórzona | number = (defaults to 10)

set.seed(123)
FFit3knn_X1_S<- train(
  as.factor(FLOOR) ~  .,
  data = data_buil %>% select(starts_with("WAP"),  FLOOR),
  method = "knn",
  #preProc = c("center", "scale"),
  tuneGrid = expand.grid(k = c(3:7)),
  trControl = ctrl
  
)

# output ------------------------------------------------------------------

source(file = "Scripts/Preparetion/funk_save_models.R")
F_save_models(FFit3knn_X1_S,filename = "Data/Results/models/FFit3knn_X1_S.RDS")


# check -------------------------------------------------------------------

F_pred_f <- read_rds("Scripts/Preparetion/F_pred_f.RDS")
F_pred_f(test_data = vData_refID_WAPu_NA_N_X1,model = FFit3knn_X1_S)

# output ------------------------------------------------------------------

FinnalTableX1F <- vData %>% filter(BuilPRED == "X1")
FinnalTableX1F$FLOOR_PRED <- pred_loc

saveRDS(FinnalTableX1F,"Data/Results/FinnalTableX1F.RDS")


# RESULTS


# Confusion Matrix and Statistics
# 
# Reference
# Prediction   0   1   2   3
# 0  23   4   0   0
# 1   7 137   7   0
# 2   0   2  79   2
# 3   0   0   1  45
# 
# Overall Statistics
# 
# Accuracy : 0.9251          
# 95% CI : (0.8897, 0.9519)
# No Information Rate : 0.4658          
# P-Value [Acc > NIR] : < 2.2e-16       
# 
# Kappa : 0.887           
# 
# Mcnemar's Test P-Value : NA              
# 
# Statistics by Class:
# 
#                      Class: 0 Class: 1 Class: 2 Class: 3
# Sensitivity           0.76667   0.9580   0.9080   0.9574
# Specificity           0.98556   0.9146   0.9818   0.9962
# Pos Pred Value        0.85185   0.9073   0.9518   0.9783
# Neg Pred Value        0.97500   0.9615   0.9643   0.9923
# Prevalence            0.09772   0.4658   0.2834   0.1531
# Detection Rate        0.07492   0.4463   0.2573   0.1466
# Detection Prevalence  0.08795   0.4919   0.2704   0.1498
# Balanced Accuracy     0.87611   0.9363   0.9449   0.9768
