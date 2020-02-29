###
#ONLY strong signal
source("Scripts/Preparetion/funk_save_models.R")
set.seed(123)
DATA_FOR_MODEL_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/DATA_FOR_MODEL_N.RDS") 
vData_refID_WAPu_NA_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/vData_refID_WAPu_NA_N.RDS")

data_buil <- DATA_FOR_MODEL_N %>% filter(BUILDINGID == "X1") #%>% select(-c(WAP310))
vData_refID_WAPu_NA_N_X1 <- vData_refID_WAPu_NA_N %>% filter(BUILDINGID == "X1") #%>% select(-c(WAP310))
rm(vData_refID_WAPu_NA_N,DATA_FOR_MODEL_N)

names_WAPs <- vars_select(colnames(data_buil), starts_with("WAP")) #lista wszystkich wapów


# #removing 0v WAPS
# acctiveWAP_tdata <- apply(select(data_buil,starts_with("WAP")),2,var)!=0
# acctiveWAP_vdata <- apply(select(vData_refID_WAPu_NA_N_X1,starts_with("WAP")),2,var)!=0
# 
# sum(acctiveWAP_tdata)
# sum(acctiveWAP_vdata)
# 
# 
# data_buil <- cbind(select(data_buil ,starts_with("WAP"))[,acctiveWAP_tdata & acctiveWAP_vdata],
#                    select(data_buil,-starts_with("WAP")))
# 
# vData_refID_WAPu_NA_N_X1 <-  cbind(select(vData_refID_WAPu_NA_N_X1,starts_with("WAP"))[,acctiveWAP_tdata & acctiveWAP_vdata],
#                                    select(vData_refID_WAPu_NA_N_X1,-starts_with("WAP")))



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
  tuneGrid = expand.grid(k = c(5:10,12,15)),
  trControl = ctrl
  
)

F_save_models(FFit3knn_X1_S)




# check -------------------------------------------------------------------

F_pred_f <- read_rds("Scripts/Preparetion/F_pred_f.RDS")
F_pred_f(test_data = vData_refID_WAPu_NA_N_X1,model = FFit3knn_X1_S)

map_errors <- cbind(vData_refID_WAPu_NA_N_X1,pred_loc =pred_loc) #pred_loc_prob
map_errors <-  map_errors %>%  mutate(corect = FLOOR == pred_loc)
names_WAPs <- vars_select(colnames(map_errors), starts_with("WAP")) #lista wszystkich wapów
map_errors_r <-  map_errors %>% select(-names_WAPs) 

plot_ly(map_errors %>%  filter(FLOOR == 0), x= ~LONGITUDE, y = ~LATITUDE, color = ~ corect, colors = "Set1")

Floor_set = c(0,1,2,3)

map_errors_floor <- map_errors %>%  filter(FLOOR %in% Floor_set)


#removing 0v WAPS
data_buil_FLOOR <- data_buil %>%  filter(FLOOR %in% Floor_set)
acctiveWAP_error <- apply(select(map_errors_floor,starts_with("WAP")),2,var)!=0
acctiveWAP_tdata <- apply(select(data_buil_FLOOR,starts_with("WAP")),2,var)!=0


sum(acctiveWAP_tdata)
sum(acctiveWAP_error)


data_buil_FLOOR_ac <- cbind(select(data_buil_FLOOR ,starts_with("WAP"))[,acctiveWAP_tdata | acctiveWAP_error],
                   select(data_buil_FLOOR,-starts_with("WAP")))

map_errors_floor_ac <- cbind(select(map_errors_floor, starts_with("WAP"))[,acctiveWAP_tdata | acctiveWAP_error],
                           select(map_errors_floor, -starts_with("WAP")))

map_errors_training <-  rbind(data_buil_FLOOR_ac %>%
                                select(starts_with("WAP"),LONGITUDE, LATITUDE, FLOOR, PHONEID,USERID,SPACEID) %>%  mutate(pred_loc= NA) %>%  mutate(corect = "tra"),
                              map_errors_floor_ac %>% 
                                select(starts_with("WAP"),LONGITUDE, LATITUDE, FLOOR, PHONEID,USERID,SPACEID,pred_loc,corect))

write.csv(map_errors_training,"map_errors_training.csv")

map_errors_training_WAP <- map_errors_training 
write.csv(map_errors_training_WAP,"map_errors_training_WAP_F1.csv")



# #SVM
# 
# ctrl <- trainControl(method = "repeatedcv", repeats = 3,verboseIter = TRUE) #crossvalidation 3 razy powtórzona | number = (defaults to 10)
# 
# set.seed(123)
# FFit3svm_X1_S<- train(
#   as.factor(FLOOR) ~  .,
#   data = data_buil %>% select(starts_with("WAP"),  FLOOR),
#   method = "svmRadialSigma",
#   #preProc = c("center", "scale"),
#   tuneLength = 6,
#   trControl = ctrl
#   
# )
# 
# F_save_models(FFit3svm_X1_S)
# 
# # check -------------------------------------------------------------------
# 
# F_pred_f <- read_rds("Scripts/Preparetion/F_pred_f.RDS")
# F_pred_f(test_data = vData_refID_WAPu_NA_N_X1,model = FFit3svm_X1_S)
