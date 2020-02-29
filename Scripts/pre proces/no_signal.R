tData_refID_WAPu_sesionID_rem_19_7 <- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID_rem_19_7.RDS") #10sek
vData_refID_WAPu<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/vData_refID_WAPu.RDS")
WAP_cols_list <-vars_select(colnames(tData_refID_WAPu_sesionID_NA), starts_with("WAP")) #lista wszystkich wapów

#tdata
tData_refID_WAPu_sesionID_rem_19_7_NA <- tData_refID_WAPu_sesionID_rem_19_7 
tData_refID_WAPu_sesionID_rem_19_7_NA <- replace.value(tData_refID_WAPu_sesionID_rem_19_7_NA, WAP_cols_list , from = 100, to = - 120)

#vdata
vData_refID_WAPu_NA <- vData_refID_WAPu
vData_refID_WAPu_NA <- replace.value(vData_refID_WAPu_NA, WAP_cols_list , from = 100, to = - 120)


saveRDS(tData_refID_WAPu_sesionID_rem_19_7_NA,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID_rem_19_7_NA.RDS")
saveRDS(vData_refID_WAPu_NA,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/vData_refID_WAPu_NA.RDS")

#### TESTS ####
# temp <- tData_refID_WAPu_sesionID
# temp[(vars_select(colnames(temp), starts_with("WAP")))]&[temp== 100] <- -1000
# temp[vars_select(colnames(temp), starts_with( "WAP"))]
# temp[temp == 100]
# 
#  
# 
# 
# 
# 
# junk$nm[junk$nm == "B"] <- "b"
