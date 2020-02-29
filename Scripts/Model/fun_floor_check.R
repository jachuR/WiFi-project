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