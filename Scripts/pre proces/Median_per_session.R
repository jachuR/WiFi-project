tData_refID_WAPu_sesionID <- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID.RDS") #10sek

names_WAPs <- colnames(select(tData_refID_WAPu_sesionID,starts_with("WAP")))

#MEDIAN_per_session_wap1<- tData_refID_WAPu_sesionID %>%  group_by(sesion_ID,group) %>% summarise(median(WAP001)) #one wap

MEDIAN_per_session_rem_NA<- tData_refID_WAPu_sesionID_rem_19_7_NA %>%  
  group_by(LONGITUDE, LATITUDE, BUILDINGID, FLOOR, SPACEID, PHONEID, USERID, RELATIVEPOSITION, sesion_ID,group) %>% #wszystkie pozostałe kolumny do group_by zeby zachowac je w wynikowej kolumnie
  summarise_at(names_WAPs,median) %>%  ungroup()




MEDIAN_per_session_rem_NA
saveRDS(MEDIAN_per_session_rem_NA,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/MEDIAN_per_session_rem_NA.RDS") 





# -------------------------------------------------------------------------


