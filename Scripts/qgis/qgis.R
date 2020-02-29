library(dplyr)
library(lubridate) #detach("package:lubridate")
library(anytime)




# treaning ----------------------------------------------------------------

gisData <- tData_refID_WAPu_sesionID_rem_19_NA %>%  filter(BUILDINGID == 1 & FLOOR == 0) %>%  
  select(sesion_ID,names_WAPs[Loc_active_waps],LONGITUDE,LATITUDE,USERID,TIMESTAMP)





write.csv(gisData, file="C:/Users/jator/Desktop/Ubiqum/3.2/Data/qgis/gisData10.csv")


# validation --------------------------------------------------------------

gisDataV <- vData_refID_WAPu_NA  %>% select(-names_WAPs,names_WAPs[Loc_active_waps]) %>%  filter(vData_refID_WAPu_NA$BUILDINGID =="X1" & FLOOR == 0)
write.csv(gisDataV, file="C:/Users/jator/Desktop/Ubiqum/3.2/Data/qgis/gisDataV10.csv")


