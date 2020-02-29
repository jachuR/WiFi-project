

# load Data ---------------------------------------------------------------


MEDIAN_per_session_NA_name <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/MEDIAN_per_session_NA_name.RDS") 
tData_refID_WAPu_sesionID_rem_19_NA <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID_rem_19_NA.RDS")



# -------------------------------------------------------------------------


temp <-  MEDIAN_per_session_NA_name %>% mutate(location= paste(sep = "_",BUILDINGID,FLOOR, SPACEID, RELATIVEPOSITION,
                                                               str_sub(string = as.character(LATITUDE), start = 4, end = 7), 
                                                               str_sub(string = as.character(LONGITUDE), start = 3, end = 8)))





names_WAPs <- vars_select(colnames(MEDIAN_per_session_NA_name), starts_with("WAP")) #lista wszystkich wapów

sd_limit =25
#MEDIAN_per_session_NA_name #50 19
#MEDIAN_per_session_NA_name #40 122
#filter %>% (USE)


temp <- temp %>%  group_by(location) %>%  summarise_at(names_WAPs,c(min,max))#obliczanie sd dla kazdej lokacji #RANGE zamiast SD!!! abs(max-min)

temp %>% 
  group_by(location) %>% 
  summarise_all(min)

wap_temp <- temp[42,]

wap_gath <- wap_temp %>% 
  pivot_longer(cols = starts_with("WAP"), names_to = "WAP", values_to = "values") %>% 
  group_by(location, WAP) 
%>% 
  summarise(min = min(values))



a <- temp[,names_WAPs] > sd_limit# 
sum(a, na.rm = T) #19 pozycji

rows_sd_50 <-  temp %>% filter_at(vars(names_WAPs), any_vars( . >sd_limit)) #WOW! #dla każdego wiersz przeszkuja wszystkie kolumny WAP, jeśli w której kolwiek jest sd > 50 to dodaj
#wyglada że niektóre wapy generuja te problemy, 23i 24 można by przefiltrować po wapach które mają sd większe niż 50

# peryklesa kod do tego samego (apply) --------------------------------------------

###
# list_ofB50 <- apply(temp[,names_WAPs], 1, max) > 50 # periclesa metoda na obejscie systemu, wyznacza najpierw max dla każdego wiersza i sprawdza czy jest większy od 50
# tempNA <- temp[list_ofB50,] # użycie tej listy do odfiltrowania pierwotnej listy
# tempNAn <-  tempNA %>%  filter(!is.na(location )) #usunięcie wszystkich wierszy  z NA
# wyglada że niektóre wapy generuja te problemy, 23i 24 można by przefiltrować po wapach które mają sd większe niż 50

# -------------------------------------------------------------------------

column_list <- vector()
for(i in 2:313){
  if(max(rows_sd_50[,i]) > sd_limit)
  {
    column_list <- c(column_list,colnames(rows_sd_50[,i]))
  }
}

row_col50 <- rows_sd_50 %>% select(location, column_list)


tData_location <- tData_refID_WAPu_sesionID_rem_19_NA %>% mutate(location = paste(sep = "_",paste0("X",BUILDINGID),FLOOR, SPACEID, RELATIVEPOSITION,
                                                                                  str_sub(string = as.character(LATITUDE), start = 4, end = 7), 
                                                                                  str_sub(string = as.character(LONGITUDE), start = 3, end = 8)))

One_location <- tData_location  %>% filter(str_detect(location, "X0_0_114") | str_detect(location, "X0_0_115"))	%>%  
  select(sesion_ID, names_WAPs) %>%  arrange(sesion_ID)

Loc_active_waps <- apply(select(One_location,starts_with("WAP")),2,var)!=0 #zastosuj funkcje var do każdej kolumny(2) która spełnia warunek
sum(Loc_active_waps )
One_location_waps <- cbind(select(One_location,starts_with("WAP"))[,Loc_active_waps],One_location$sesion_ID)
write.csv(One_location_waps,"One_location_waps.csv")


One_session <- tData_location  %>% filter(sesion_ID == "0_0_115_2_4979_605.41_1_14")	%>%  select(sesion_ID, names_WAPs )




rm(temp, row_col50, rows_sd_50,a)


