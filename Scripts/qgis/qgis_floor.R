#######
#Przygotowanie plików dla jednego WPA dla różnych pięter
#######


## zaokrąglenie Lat i Long żeby wypadały na różnych piętrach w tym samym miejscu
tData_refID$LATITUDE <- round(refer_name$LATITUDE,0)
tData_refID$LONGITUDE <- round(refer_name$LONGITUDE,0)


signal_map  <- tData_refID

# średni sygnał z danej lokalizacji dla danego wapa
signal_map_WAP33 <-  signal_map %>%  group_by(refID,PHONEID,USERID,) %>%  summarise(median(WAP033))
signal_map_WAP33 <-  cbind(signal_map_WAP33,refer_name_unique[,c("LONGITUDE","LATITUDE","FLOOR","BUILDINGID","SPACEID","RELATIVEPOSITION","TIMESTAMP")])

signal_map_WAP33_0 <- signal_map_WAP33 %>%  filter(FLOOR==0)
signal_map_WAP33_1 <- signal_map_WAP33 %>%  filter(FLOOR==1) 
signal_map_WAP33_2 <- signal_map_WAP33 %>%  filter(FLOOR==2)
signal_map_WAP33_3 <- signal_map_WAP33 %>%  filter(FLOOR==3)
signal_map_WAP33_4 <- signal_map_WAP33 %>%  filter(FLOOR==4)

write.csv(signal_map_WAP1, file="C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/signal_map_WAP1.csv")
write.csv(signal_map_WAP1_0, file="C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/signal_map_WAP1_0.csv")
write.csv(signal_map_WAP1_1, file="C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/signal_map_WAP1_1.csv")
write.csv(signal_map_WAP1_2, file="C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/signal_map_WAP1_2.csv")
write.csv(signal_map_WAP1_3, file="C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/signal_map_WAP1_3.csv")
write.csv(signal_map_WAP1_4, file="C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/signal_map_WAP1_4.csv")



write.csv(signal_map_WAP33_0, file="C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/signal_map_WAP33_0.csv")
write.csv(signal_map_WAP33_1, file="C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/signal_map_WAP33_1.csv")
write.csv(signal_map_WAP33_2, file="C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/signal_map_WAP33_2.csv")
write.csv(signal_map_WAP33_3, file="C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/signal_map_WAP33_3.csv")
write.csv(signal_map_WAP33_4, file="C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/signal_map_WAP33_4.csv")