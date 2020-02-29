map_errors_training <- readRDS(file = "Data/Results/FinnalTable_F_C.RDS")

#map_errors_training - można znaleźć w X1_floor_S

p <- plot_ly(map_errors_training %>% filter(FLOOR <2), x = ~LONGITUDE, y = ~LATITUDE, z = ~FLOOR, 
             marker = list(color = ~WAP310, colorscale = c('#FFE1A1', '#683531'), showscale = TRUE),
             mode = 'markers', symbol = ~corect, symbols = c('x','circle','cross-dot'))%>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'Weight'),
                      yaxis = list(title = 'Gross horsepower'),
                      zaxis = list(title = '1/4 mile time'))
  )

p


p <- plot_ly(map_errors_training %>% filter(FLOOR <2), x = ~LONGITUDE, y = ~LATITUDE, z = ~FLOOR, 
             marker = list(color = ~WAP108, colorscale = c('#FFE1A1', '#683531'), showscale = TRUE),
             mode = 'markers')%>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'Weight'),
                      yaxis = list(title = 'Gross horsepower'),
                      zaxis = list(title = '1/4 mile time'))
  )

p