# remove session with only one or two record


df <-  tData_refID_WAPu_sesionID
to_remove <- n1


df <- df %>%  mutate(paste0(sesion_ID,group))
to_remove <- to_remove %>%  mutate(paste0(sesion_ID,group))



result <-  df %>% filter(!(`paste0(sesion_ID, group)` %in% to_remove$`paste0(sesion_ID, group)`))



tData_refID_WAPu_sesionID_rem <- result


rm(df,to_remove,result)


saveRDS(tData_refID_WAPu_sesionID_rem,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID_rem.RDS") 


rm(tData_refID_WAPu_sesionID_rem)
