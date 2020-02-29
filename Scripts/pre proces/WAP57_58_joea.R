tData_refID_WAPu_sesionID_rem_19_NA %>% 
  gather(starts_with("WAP"), key = "WAP", value = "value") %>% 
  filter(WAP %in% c("WAP057", "wAP058") & value != -120) %>% # sprwadzenie w których budynakch był odbieraany 
  distinct(LONGITUDE, LATITUDE, FLOOR, BUILDINGID) #unique - pojedyńczy wiersz dla danej konfiguracji wartości


temp <- tData_refID_WAPu_sesionID_rem_19_NA %>% 
  filter(WAP057 != -120 & WAP058 != -120) 
train_activated <- temp[,-nearZeroVar(temp)] # sprawdzenie jakie wapy są aktywne kiedy aktywny jest wap 57 i 58
