# libraries
if (require(pacman) == FALSE) {
  install.packages("pacman")
}
pacman::p_load(tidyverse, rpart,readr)
vData_refID_WAPu_NA_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/vData_refID_WAPu_NA_N.RDS")
testing1F <- read_rds("Data/models/testing1F.RDS")


# app creation ------------------------------------------------------------



F_pred_f <- function(test_data, model, type = "raw", file_name = deparse(substitute(model))) {
  # test_data - dane testowe do walidacji wyników predykcji, domyślnie "testing")
  # model - model który ma zotstaać użyty
  # type - "raw" (domyslny), "prob" - wynik procentowego prawdopodobieństwa
  # file_name - nazwa pod którą ma być zapisany wynik, domyslnie nazwa modelu
  
  
  # predictions
  pred_loc <<- predict(object = model, newdata = test_data, type = type) # <<- save to global envi
  # store results
  write_rds(pred_loc, paste0("data/clean/model_results_",file_name,".rds"))
  
  if (type == "raw") {
    confusionMatrix(data = pred_loc, as.factor(test_data$FLOOR))  #normalnie to: pred_loc[[1]] nie jest potrzebne, ale cos sie gdzies zjebalo i bez tego pokazuje ze faktory nie maja jednakowych poziomow
    
  }
  
}

saveRDS(F_pred_f, "Scripts/pre proces//F_pred_f.RDS")

# MODELS ------------------------------------------------------------------

FFit1SVMSig7ID1 <- read_rds("Data/models/FFit1SVMSig7ID1.rds") #av=(a=0.9,k=86)
FFit1SVM_subset #t= 1 v=(a=0.9,k=86) # bez roznicy czy trenuje na calym dataset czy na 75% wyniki takie same :/
FFit1SVMX0 #t=1 v=0.96
FFit1SVMX1 #t=0.976 v= 0.79 av=0.79 testing errors(2) - "Data/Clean/FFit1SVMX1_train_subset_ERRORS.RDS" 
FFit1SVMX2 #t=1 v=0.89

# validate against testing dataset    
F_pred_f(model = FFit1SVMX1, test_data = testingX1)

# check errors
#pred_loc_prob <- pred_loc
map_errors <- cbind(testingX1,pred_loc =pred_loc) #pred_loc_prob
map_errors <-  map_errors %>%  mutate(corect = FLOOR == pred_loc)
names_WAPs <- vars_select(colnames(map_errors), starts_with("WAP")) #lista wszystkich wapów
map_errors_r <-  map_errors %>% select(-names_WAPs)

plot_ly(map_errors, x= ~LONGITUDE, y = ~LATITUDE, color = ~ corect, colors = "Set1")

#Validate against VALIDATION dataset-----------------------------------------------------------------------

#vData_refID_WAPu_NA$BUILDINGID <- make.names(vData_refID_WAPu_NA$BUILDINGID)
F_pred_f(model = FFit1SVMX1, test_data =  vData_refID_WAPu_NA_N %>%  filter(BUILDINGID == "X1"))

# check errors
#pred_loc_prob <- pred_loc
map_errors <- cbind(vData_refID_WAPu_NA_N,pred_loc =pred_loc[[1]]) #pred_loc_prob
map_errors <-  map_errors %>%  mutate(corect = FLOOR== pred_loc) %>% arrange(corect)
map_errors_r <-  map_errors[312:323]

plot_ly(map_errors, x= ~LONGITUDE, y = ~LATITUDE, color = ~ corect, colors = "Set1")










