
# load --------------------------------------------------------------------


tData <- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData.RDS")


# code --------------------------------------------------------------------


##add reffer name
summary(tData$LONGITUDE)
summary(tData$LATITUDE)

tData_refID <- tData %>%  
  mutate(refID = paste(sep = "_",BUILDINGID,FLOOR, SPACEID, RELATIVEPOSITION,
                       str_sub(string = as.character(LATITUDE), start = 4, end = 7), 
                       str_sub(string = as.character(LONGITUDE), start = 3, end = 8)))


## number of instances for evry reference of reference points (933)
refer_name_count <- tData_refID %>% 
  group_by(refID) %>% 
  count() %>% ungroup()

##validation add location name
vData_refID_WAPu_NA <-  vData_refID_WAPu_NA %>%  
  mutate(location= paste(sep = "_",BUILDINGID,FLOOR, SPACEID, RELATIVEPOSITION))

# output ------------------------------------------------------------------


saveRDS(tData_refID ,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/Data_refID.RDS")
