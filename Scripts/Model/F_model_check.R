# libraries
if (require(pacman) == FALSE) {
  install.packages("pacman")
}
pacman::p_load(tidyverse, rpart,readr)
vData_refID_WAPu_NA_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/vData_refID_WAPu_NA_N.RDS")
 #make.names() dodanie litery do liczby ("X1") żeby dało się użyć classProbs



# app creation ------------------------------------------------------------



F_pred_b <- function(test_data=testing, model, type = "raw", file_name = deparse(substitute(model))) {
  # test_data - dane testowe do walidacji wyników predykcji, domyślnie "testing")
  # model - model który ma zotstaać użyty
  # type - "raw" (domyslny), "prob" - wynik procentowego prawdopodobieństwa
  # file_name - nazwa pod którą ma być zapisany wynik, domyslnie nazwa modelu
  
  
  # predictions
    pred_loc <<- predict(object = model, newdata = test_data, type = type) # <<- save to global envi
  # store results
    write_rds(pred_loc, paste0("data/clean/model_results_",file_name,".rds"))
    
    if (type == "raw") {
      confusionMatrix(data = pred_loc, as.factor(test_data$BUILDINGID))  #normalnie to: [[1]] nie jest potrzebne, ale cos sie gdzies zjebalo i bez tego pokazuje ze faktory nie maja jednakowych poziomow
      
    }
    
 }


# -------------------------------------------------------------------------

saveRDS(F_pred_b,"Data/Results/functions/fun_pred_check_building.RDS")

# validate against testing dataset    
F_pred_b(model = BFit4SVMSig7)

# check errors
#pred_loc_prob <- pred_loc
map_errors <- cbind(testing,pred_loc) #pred_loc_prob
map_errors <-  map_errors %>%  mutate(corect = BUILDINGID == pred_loc)
map_errors_r <-  map_errors[,c(1:10,323:324)]

plot_ly(map_errors, x= ~LONGITUDE, y = ~LATITUDE, color = ~ corect, colors = "Set1")

#Validate against VALIDATION dataset-----------------------------------------------------------------------

#vData_refID_WAPu_NA$BUILDINGID <- make.names(vData_refID_WAPu_NA$BUILDINGID)
F_pred_b(model = BFit6SVMSig7ID1, test_data =  vData_refID_WAPu_NA_N)

# check errors
#pred_loc_prob <- pred_loc
map_errors <- cbind(vData_refID_WAPu_NA,pred_loc) #pred_loc_prob
map_errors <-  map_errors %>%  mutate(corect = BUILDINGID == pred_loc) %>% arrange(corect)
map_errors_r <-  map_errors[312:323]

plot_ly(map_errors, x= ~LONGITUDE, y = ~LATITUDE, color = ~ corect, colors = "Set1")


BFit1rpart
BFit2rpart
BFit1KKNN
BFit2KNN
BFit2KKNN
BFit2SVM
BFit2SVMSig
BFit3SVMSig #v=9982
BFit3SVMSig_prob
BFit4SVMSig  #t= 1 v= 0.9982
BFit4SVMSig7 #t= 1 v = 0.9991 aV= 0.9991
BFit4KNN7 #v = 0.9937 
BFit4knn #t = 0.9955 v= 0.9928 
BFit6SVMSig7ID1 #v=1







