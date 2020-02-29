
# load Data ---------------------------------------------------------------


MEDIAN_per_session_NA_name <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/MEDIAN_per_session_NA_name.RDS") # to jest już po usunięciu 19 #plik pochodzi z model5
tData_refID_WAPu_sesionID_rem_19_NA <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID_rem_19_NA.RDS") #plik pochodzi z model5
names_WAPs <- vars_select(colnames(MEDIAN_per_session_NA_name), starts_with("WAP")) #lista wszystkich wapów
ultra_signal_rows <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/ultra_signal_rows.RDS")

# -------------------------------------------------------------------------





## odfiltrowujemy wszystko co uznajemy za śmieci (sesje z mniej niż 3 wynikami i phon ID19 odfiltrowane juz wcześniej).
# * USER ID 1 - niezgodne totalnie wyniki z innymi pomiarami w tych samych lokacjach. (exel X0)
# ultra_signal_rows - część sesji dla UID 14/PID7 gdzie padały wyniki powyżej -15
DATA_FOR_MODEL <-  MEDIAN_per_session_NA_name %>% filter(USERID != 1)  %>% mutate(paste0(sesion_ID,group)) %>% 
  filter(!(`paste0(sesion_ID, group)` %in% ultra_signal_rows$`paste0(sesion_ID, group)`)) %>% 
  mutate(location= paste(sep = "_",BUILDINGID,FLOOR, SPACEID, RELATIVEPOSITION,
                         str_sub(string = as.character(LATITUDE), start = 4, end = 7), 
                         str_sub(string = as.character(LONGITUDE), start = 3, end = 8)))


# output ------------------------------------------------------------------

saveRDS(DATA_FOR_MODEL,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/DATA_FOR_MODEL.RDS")
