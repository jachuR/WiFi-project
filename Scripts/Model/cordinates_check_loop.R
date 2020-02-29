
loc_pred_f <- function(test_data, model, type = "raw", file_name = deparse(substitute(model)),LONGLAT = substr(model, 13, 25)) { #substr probuje wyciagnac dane z nazwy modelu, ale jesli zmieni sie jego długość to przestanie działać)
  # test_data - dane testowe do walidacji wyników predykcji, domyślnie "testing")
  # model - model który ma zotstaać użyty
  # type - "raw" (domyslny), "prob" - wynik procentowego prawdopodobieństwa
  # file_name - nazwa pod którą ma być zapisany wynik, domyslnie nazwa modelu
  
  
  # predictions
  pred_loc <<- predict(object = model, newdata = test_data, type = type) # <<- save to global envi
  # store results
  write_rds(pred_loc, paste0("data/clean/model_results_",file_name,".rds"))
  
  if (type == "raw") {
    pResamp <<- postResample(pred  = pred_loc, obs = test_data[[LONGLAT]])  #normalnie to: pred_loc[[1]] nie jest potrzebne, ale cos sie gdzies zjebalo i bez tego pokazuje ze faktory nie maja jednakowych poziomow
    pResamp
  }
  
}
col_name <- c()
saveRDS(loc_pred_f, "Scripts/Preparetion/loc_pred_f.RDS")
compare.model <- c()
model_list <-  ls() %>% vars_select(starts_with("CORD")) %>%  vars_select(ends_with("TUDE"))
val_list <- ls() %>% vars_select(starts_with("validation")) 
#https://rstudio-pubs-static.s3.amazonaws.com/452662_496cf20b11b24e4296e85cf9e0fd6d35.html
for (model in model_list) {
  id <- substr(model, 10, 11)
  
  val_set <- val_list %>% vars_select(ends_with(id)) 
  print(paste(val_set,substr(model, 13, 25)))
  print(loc_pred_f(model = eval(parse(text = model)), test_data = eval(parse(text = val_set)),LONGLAT = substr(model, 13, 25)))
  col_name <- append(col_name, paste(substr(val_set,12,20),substr(model, 13, 25)))
  compare.model <- cbind(compare.model,pResamp)
  #append(paste(val_set,substr(model, 13, 25, temp ))
}


colnames(compare.model) <- col_name


name_model <- "knn_00_nFLOOR"

assign(name_model, data.frame(compare.model))
knn_00_nFLOOR$model <- name_model
knn_00_nFLOOR

results_cord1 <- rbind(results_cord,)
# SAVE --------------------------------------------------------------------


saveRDS(knn_00_nFLOOR,file = paste0("Data/Results/",name_model ,".RDS"))
saveRDS(CORD_table,file = "Data/Results/CORD_table.RDS")
write.csv(CORD_table,"csv_outputs/CORD_table.csv")
# -------------------------------------------------------------------------

#eval(parse(text = val_set))[[substr(model, 13, 25]]



# loc_pred_f(model = FLLfit1KNN_X2_4_LONGITUDE, test_data = validation_X2_4, LONGLAT = "LONGITUDE")
# loc_pred_f(model = model, test_data = validation_X2_4, LONGLAT = "LONGITUDE")
# 
# loc_pred_f(model = eval(parse(text = model)), test_data = eval(parse(text = val_set)), LONGLAT = column )
# 
# validation_X0_1$LONGITUDE
# pred_loc
# 
# substr("FLLfit1KNN_X2_4_LONGITUDE", 13, 26)
# 
# 
# substr("FLLfit1KNN_X2_4_LONGITUDE", 12, 15)
# 
# validation_X2_4$LONGITUDE
# validation_X2_4[["LONGITUDE"]]

#loc_pred_f(model = FLLfit1KNN_0_X0_LATITUDE_nFLOO,)
knn
