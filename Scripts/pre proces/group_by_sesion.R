
# DATA --------------------------------------------------------------------
library(dplyr)


tData_refID_WAPu_sesionID <- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID.RDS") #10sek
tData_refID_WAPu_sesionID <- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID_3.RDS") #3sek




records_per_session<- tData_refID_WAPu_sesionID %>%  group_by(sesion_ID,group) %>% summarise(num=n())

## najlepiej zostać przy 10sec



n1 <- records_per_session %>%  filter (num %in% c(1,2))

temp <-  tData_refID_WAPu_sesionID  %>%  filter (sesion_ID == "0_2_138_2_4977_628.13_11_13")



temp <- tData_refID_WAPu_sesionID %>% filter(sesion_ID %in% n1$sesion_ID)	# z tego co widze to lepiej wywalić te pojedyńcze (ok 70 wyników)
write.csv(temp,"temp.csv")

records_per_session
