

# load --------------------------------------------------------------------
tData_refID_WAPu_sesionID_rem_19 <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID_rem_19.RDS")



# vdata -------------------------------------------------------------------


temp <- vData_refID_WAPu_NA %>%  filter(PHONEID==20)
a <-vData_refID_WAPu_NA[,1:312] >-25
sum(a) #0 - żadnych podejrzanie niskich wartości dla vDataset :)





# tdata -------------------------------------------------------------------


a <- tData_refID_WAPu_sesionID_rem_19[,1:312] >-15 & tData_refID_WAPu_sesionID_rem_19[,1:312]  < 1
sum(a) #27 phoneID ==7

temp <- a %>% 
  as_tibble() %>% 
  tibble::rowid_to_column(var = "id") %>% 
  filter_all(any_vars(. == TRUE))
temp2 <- tData_refID_WAPu_sesionID_rem_19[temp$id[c(2:nrow(temp))],]
write.csv(temp2,"temp2.csv")

#sprawdzić jak usunięcie phoneID ==7 wpłynie na reszte. Zmapować ID7 i all - ID7

temp <- tData_refID_WAPu_sesionID_rem_19 %>%  filter(PHONEID==7)
plot_ly(temp, x= ~LONGITUDE, y= ~LATITUDE)
temp2 <- tData_refID_WAPu_sesionID_rem_19 %>%  filter(PHONEID!=7)
plot_ly(temp2, x= ~LONGITUDE, y= ~LATITUDE)

# nie wygląda żeby wpłyneło, usuwamy...


temp4 <- tData_refID_WAPu_sesionID_rem_19 %>% filter(PHONEID!=7)

tData_refID_WAPu_sesionID_rem_19_7 <- temp4

saveRDS(tData_refID_WAPu_sesionID_rem_19_7,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID_rem_19_7.RDS")

rm(temp,temp2,temp3,temp4)

#sprawdzenie pozostałych

a <- tData_refID_WAPu_sesionID_rem_19_7[,1:312] >-30 & tData_refID_WAPu_sesionID_rem_19_7[,1:312]  < 1
sum(a) #15 - wszystkie między -25 a -30 więc chyba wiarygodne
rm(a)

