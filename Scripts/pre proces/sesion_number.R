#

# -------------------------------------------------------------------------
# ###########
# Każde łączenie się z bazą to około 10 rekordów, 
# teraz chcemy połączyć je wszystkie razem, żeby wyeliminować z nich wartości odstające.
# Tutaj nadajemy grupy wg tego klucza. 
# Wszystkie dane dla danej lokalizacji, przez tą samą osobę. pobrane w przęciągu 10sek sa w jednej grupie.
# #############



# Input -------------------------------------------------------------------

library(data.table)
tData_refID_WAPu <- read_rds("Data/Clean/tData_refID_WAPu.RDS")




# CODE --------------------------------------------------------------------

#stworzenie ID dla miejsca,tel i osoby
tData_refID_WAPu_sID  <- tData_refID_WAPu %>% mutate(sesion_ID=paste(refID,USERID,PHONEID, sep = "_"))
#sortowanie wg czasu
tData_refID_WAPu_sID_sort <- tData_refID_WAPu_sID %>%  arrange(refID) %>%  arrange(TIMESTAMP)
# lista unikalnych ID dla for loop
reference_temp <- unique(tData_refID_WAPu_sID_sort$sesion_ID)
# stworzeenie nowej kolumny
tData_refID_WAPu_sID_sort$group <- NA


#pusta tabela
  result <- tData_refID_WAPu_sID_sort[0,]
## magiczna pętla która sprawdza co jest razem w 10s przedziałach  
  for (i in reference_temp)
  {
    #sub dataset dla jednego sesion_ID
    tData_refID_WAPu_sort_filter <- tData_refID_WAPu_sID_sort %>% filter(sesion_ID==i)
                                               
    #nadanie grup
    tData_refID_WAPu_sort_filter$group <- cumsum(ifelse(difftime(tData_refID_WAPu_sort_filter$TIMESTAMP,
                                      shift(tData_refID_WAPu_sort_filter$TIMESTAMP,
                                            fill = tData_refID_WAPu_sort_filter$TIMESTAMP[1]), 
                                      units = "secs") >= 10
                             ,1, 0)) + 1
    #output
    result <- rbind(result,tData_refID_WAPu_sort_filter )
    
  }

  

# Output ------------------------------------------------------------------

  
  tData_refID_WAPu_sesionID <-  result
  saveRDS(tData_refID_WAPu_sesionID,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID.RDS")
  saveRDS(tData_refID_WAPu_sesionID_4,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID_4.RDS")
  saveRDS(tData_refID_WAPu_sesionID_3,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID_3.RDS")
  


  