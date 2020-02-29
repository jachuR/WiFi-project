

# load --------------------------------------------------------------------

DATA_FOR_MODEL <- read_rds("Data/Clean/DATA_FOR_MODEL.RDS")
DATA_FOR_MODEL_N <- read_rds("Data/Clean/DATA_FOR_MODEL_N.RDS")
names_WAPs <- vars_select(colnames(DATA_FOR_MODEL_N), starts_with("WAP")) #lista wszystkich wapów
tData_refID_WAPu_sesionID_rem_19_NA <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID_rem_19_NA.RDS")
  

# -------------------------------------------------------------------------
################################################################
#ostatecznie uzywam range zamiast sd, ale nazwa został sd #####
###############################################################

## define range limit and temp
sd_limit =0.7
temp <- DATA_FOR_MODEL_N
#MEDIAN_per_session_NA_name #50 19
#MEDIAN_per_session_NA_name #40 122
#MEDIAN_per_session_NA_name RANGE 50, PHONEID =19, USERID =1, temp2 #182 




#obliczanie range dla kazdej lokacji
temp <- temp %>%  group_by(location) %>%  summarise_at(names_WAPs,rangeVal)
#odlitrowanie wartości powyżej limitu
a <- temp[,names_WAPs] > sd_limit# 
# podliczenie ilości komórek spelniajacych warunek
sum(a, na.rm = T) #19 pozycji
#WOW! #dla każdego wiersz przeszkuja wszystkie kolumny WAP, jeśli w której kolwiek jest sd > 50 to dodaje
rows_sd_50 <-  temp %>% filter_at(vars(names_WAPs), any_vars( . >sd_limit)) 
#wyglada że niektóre wapy generuja te problemy, 23i 24 można by przefiltrować po wapach które mają sd większe niż 50

# peryklesa kod do tego samego (apply) --------------------------------------------

###
# list_ofB50 <- apply(temp[,names_WAPs], 1, max) > 50 # periclesa metoda na obejscie systemu, wyznacza najpierw max dla każdego wiersza i sprawdza czy jest większy od 50
# tempNA <- temp[list_ofB50,] # użycie tej listy do odfiltrowania pierwotnej listy
# tempNAn <-  tempNA %>%  filter(!is.na(location )) #usunięcie wszystkich wierszy  z NA
# wyglada że niektóre wapy generuja te problemy, 23i 24 można by przefiltrować po wapach które mają sd większe niż 50

# -------------------------------------------------------------------------


# wybór kolumn gdzie limit przekroczono
column_list <- vector()
for(i in 2:313){
  if(max(rows_sd_50[,i]) > sd_limit)
  {
    column_list <- c(column_list,colnames(rows_sd_50[,i]))
  }
}
row_col50 <- rows_sd_50 %>% select(location, column_list)

#addin location index
tData_location <- tData_refID_WAPu_sesionID_rem_19_NA %>% mutate(location = paste(sep = "_",paste0("X",BUILDINGID),FLOOR, SPACEID, RELATIVEPOSITION,
                                                                       str_sub(string = as.character(LATITUDE), start = 4, end = 7), 
                                                                       str_sub(string = as.character(LONGITUDE), start = 3, end = 8)))
## all active waps in one location


One_location <- tData_location  %>% filter(str_detect(location, "X2_3_137_2_4794_317.52") | str_detect(location, "X2_3_137_2_4794_317.52	"))	%>%  
  select(sesion_ID, TIMESTAMP, names_WAPs) %>%  arrange(sesion_ID)

Loc_active_waps <- apply(select(One_location,starts_with("WAP")),2,var)!=0 #zastosuj funkcje var do każdej kolumny(2) która spełnia warunek
sum(Loc_active_waps )

One_location_waps <- cbind(sesion_ID = One_location$sesion_ID,TIMESTAMP = One_location$TIMESTAMP, select(One_location,starts_with("WAP"))[,Loc_active_waps])
write.csv(One_location_waps,"One_location_waps.csv")

## selected WAPs in all locations
waps_to_check = c("WAP109","WAP110","WAP112","WAP315")
Selected_waps <-  tData_location %>% mutate(TIMESTAMP = TIMESTAMP) %>%
  select(sesion_ID, location,USERID, PHONEID, TIMESTAMP,waps_to_check) %>%  filter(location %in% row_col50$location)
 write.csv(Selected_waps,"Selected_waps.csv")


## all resoult for selected sesion
One_session <- tData_location  %>% filter(sesion_ID == "1_0_202_2_4829_454.23_7_6")	%>%  select(sesion_ID, TIMESTAMP, names_WAPs )
write.csv(One_session,"One_sesion.csv")



rm(temp, row_col50, rows_sd_50,a)


