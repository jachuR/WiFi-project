output <-  map_errors %>%  filter(BUILDINGID == "X0")
write.csv(output, "error.csv")

One_location <- tData_location  %>% filter(location == "X0_0_115_2_4979_605.41")	%>%  select(sesion_ID, column_list)
One_location <- tData_location  %>% filter(str_detect(location, "X1"))   
write.csv(One_location,"one_location2.csv")

bad_session <- tData_refID_WAPu_sesionID_rem_19_NA %>% filter(sesion_ID =="0_0_115_2_4979_605.41_1_14")

