###
#ONLY strong signal
source("Scripts/Preparetion/funk_save_models.R")
set.seed(123)
DATA_FOR_MODEL_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/DATA_FOR_MODEL_N.RDS") 
#vData_refID_WAPu_NA_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/vData_refID_WAPu_NA_N.RDS") TO DZIALA DLA X1
vData_refID_WAPu_NA_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/FinnalTable_F.RDS")


data_buil <- DATA_FOR_MODEL_N
names_WAPs <- vars_select(colnames(data_buil), starts_with("WAP")) #lista wszystkich wapów

th = 0.50
a <- data_buil[,names_WAPs]
a[a < th ] <-0 
data_buil[,names_WAPs] <- a
b <- vData_refID_WAPu_NA_N[,names_WAPs]
b[b < th ] <-0 
vData_refID_WAPu_NA_N[,names_WAPs] <- b

ctrl <- trainControl(method = "repeatedcv", repeats = 3,verboseIter = TRUE) #crossvalidation 3 razy powtórzona | number = (defaults to 10)

for (B in c("X0","X1","X2")) {
  data_buil <- DATA_FOR_MODEL_N %>% filter(BUILDINGID == B) 
  funk <- c("LONGITUDE ~ .", "LATITUDE ~ .")
  column <- c("LONGITUDE", "LATITUDE")
  name_v <- paste("validation",B, sep = "_")
  vData_B <- vData_refID_WAPu_NA_N %>% filter(BUILDINGID == B)
  assign(name_v , vData_B)
  for (i in 1:2) {
      set.seed(123)
      FLLfit1KNN <- train(
        formula(funk[i]),
        data = data_buil  %>% select(starts_with("WAP"),column[i]),
        method = "knn",
        #preProc = c("center", "scale"),
        tuneLength = 6,
        #tuneGrid = expand.grid(k = c(4:11,15)),
        trControl = ctrl
      )
      name_mod <- paste("FLLfit1KNN",th,B,column[i], sep = "_")
      assign(name_mod , FLLfit1KNN) 
      
  }
}


# Testing Function----------------------------------------------------------------



loc_pred_f <- function(test_data, model, type = "raw", file_name = deparse(substitute(model)),LONGLAT) {
  # test_data - dane testowe do walidacji wyników predykcji, domyślnie "testing")
  # model - model który ma zotstaać użyty
  # type - "raw" (domyslny), "prob" - wynik procentowego prawdopodobieństwa
  # file_name - nazwa pod którą ma być zapisany wynik, domyslnie nazwa modelu
  
  
  # predictions
  pred_loc <<- predict(object = model, newdata = test_data, type = type) # <<- save to global envi
  # store results
  write_rds(pred_loc, paste0("data/clean/model_results_",file_name,".rds"))
  
  if (type == "raw") {
    postResample(pred  = pred_loc, obs = test_data[[LONGLAT]])  #normalnie to: pred_loc[[1]] nie jest potrzebne, ale cos sie gdzies zjebalo i bez tego pokazuje ze faktory nie maja jednakowych poziomow
    
  }}

# error check -------------------------------------------------------------

loc_pred_f(model = FLLfit1KNN_X0_LONGITUDE, test_data = validation_X0, LONGLAT = "LONGITUDE")
map_errors <- cbind(vData_refID_WAPu_NA_N %>% filter(BUILDINGID=="X0"),pred_loc =pred_loc) #pred_loc_prob
map_errors <-  map_errors %>%  mutate(residual = abs(LATITUDE - pred_loc)) %>% arrange(residual)
map_errors_r <-  map_errors[312:323]



# ## F to save models -----------------------------------------------------


F_save_models_ls <- function(objects,object_names) {
  
  
  sapply(1:length(objects), function(i) {  ## co to za cuda??
    filename = paste0("data/models/", object_names[i], ".rds")
    saveRDS(objects[[i]], filename)
  })
}




# list of models  from ls() detected by string---------------------------------------------------------

model_list <-  ls() %>% vars_select(starts_with("FLL")) %>%  
  vars_select(ends_with("TUDE")) %>% 
  as_tibble()
model_list_name <- unname(ls() %>% vars_select(starts_with("FLL")) %>%  
  vars_select(ends_with("TUDE")))
model_list_un <- lapply(model_list$value,function(x) eval(parse(text = x)))

F_save_models_ls(model_list_un,model_list_name)

# list of val -------------------------------------------------------------
# 
# val_list <- ls() %>% vars_select(starts_with("validation"))  %>% 
#   as_tibble()
# val_list_name <- unname(ls() %>% vars_select(starts_with("validation")))
# val_list_un <- lapply(model_list$value,function(x) eval(parse(text = x)))
# 
# 
# 
# F_save_models_ls(val_list_un,val_list_name)


# -------------------------------------------------------------------------



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





# #SVM
# 
# ctrl <- trainControl(method = "repeatedcv", repeats = 3,verboseIter = TRUE) #crossvalidation 3 razy powtórzona | number = (defaults to 10)
# 
# set.seed(123)
# CFit1svm_X0_S<- train(
#   LONGITUDE ~  .,
#   data = data_buil %>% select(starts_with("WAP"),  FLOOR),
#   method = "svmRadialSigma",
#   #preProc = c("center", "scale"),
#   tuneLength = 6,
#   trControl = ctrl
#   
# )
# 
# F_save_models(FFit3svm_X0_S)
# 
# ctrl <- trainControl(method = "repeatedcv", repeats = 3,verboseIter = TRUE) #crossvalidation 3 razy powtórzona | number = (defaults to 10)
# 






