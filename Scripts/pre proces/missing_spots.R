
temp2a <- tData %>% mutate(location= paste(sep = "_",paste0("X",BUILDINGID),FLOOR, SPACEID, RELATIVEPOSITION,
                                         str_sub(string = as.character(LATITUDE), start = 4, end = 7), 
                                         str_sub(string = as.character(LONGITUDE), start = 3, end = 8)))
temp2 <- temp2 %>% group_by(location) %>%  summarise_at(names_WAPs,var)


# -------------------------------------------------------------------------


temp <-  MEDIAN_per_session_NA_name %>% mutate(location= paste(sep = "_",BUILDINGID,FLOOR, SPACEID, RELATIVEPOSITION,
                                                               str_sub(string = as.character(LATITUDE), start = 4, end = 7), 
                                                               str_sub(string = as.character(LONGITUDE), start = 3, end = 8)))


temp <- temp %>% group_by(location) %>%  summarise_at(names_WAPs,var)

a <- temp2$location[!(temp2$location %in% temp$location )] #12 brakujacych lokalizachi




temp2aF <-  temp2a %>%  filter(location %in% a)



FF=4

temp2aPLOT <- MEDIAN_per_session_NA_name %>% filter(FLOOR ==FF)
temp2aFPLOT <- temp2aF %>% filter(FLOOR ==FF)

plot_ly(temp2aPLOT) %>% 
  add_trace(x = temp2aPLOT$LONGITUDE, y= temp2aPLOT$LATITUDE, colors = "red", text= temp2aPLOT$location ) %>% 
  add_trace(x = temp2aFPLOT$LONGITUDE, y = temp2aFPLOT$LATITUDE, colors ="blue", text= temp2aFPLOT$location ) %>% 
  layout(title = 'missing locations',
         xaxis = list(title = "Lat"),
         yaxis = list(side = 'left', title = 'Long', showgrid = FALSE, zeroline = FALSE),
         yaxis2 = list(side = 'right', overlaying = "y", title = 'Event Type', showgrid = FALSE, zeroline = FALSE))
  
 
