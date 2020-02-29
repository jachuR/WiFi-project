## stworzenie tabeli z id sesji w tórych padały wyniki wyższe niż -15, potrzebna żeby później je wywalić z finalnej df


# load --------------------------------------------------------------------

tData_refID_WAPu_sesionID_rem_19_NA <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID_rem_19_NA.RDS")
names_WAPs <- vars_select(colnames(MEDIAN_per_session_NA_name), starts_with("WAP")) #lista wszystkich wapów


# -------------------------------------------------------------------------
# namierzenie i policzynie wyników > -15
ultra_signal <- tData_refID_WAPu_sesionID_rem_19_NA[,names_WAPs] >-15
sum(ultra_signal) #27 phoneID ==7

#odfiltrowanie tylko tych wierszy w których sygnał jest silniejszy niż -15
temp <-ultra_signal %>% 
  as_tibble() %>% 
  tibble::rowid_to_column(var = "id") %>% 
  filter_all(any_vars(. == TRUE))
temp2 <- tData_refID_WAPu_sesionID_rem_19_NA[temp$id[c(2:nrow(temp))],]


# output ------------------------------------------------------------------

ultra_signal_rows <- temp2

saveRDS(ultra_signal_rows,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/ultra_signal_rows.RDS")

#write.csv(temp2,"temp2.csv")