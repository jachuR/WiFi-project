FinnalTable_F_C <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/FinnalTable_F_C.RDS")


mp <- openmap(c(39.99410,-0.06990),
              c(39.99156,-0.06481),18,"bing") #19 jest ładne ale wolne

#("osm", "maptoolkit-topo", "bing", "stamen-toner", "stamen-watercolor", "esri", "esri-topo", "nps", "apple-iphoto", "skobbler")
r <- sample(1:1111, 1)
aaa <-  FinnalTable_F_C[r,313:325]

p <- autoplot(mp,expand=T) + 
  geom_point(aes(x=LONGITUDE_PRED,y=LATITUDE_PRED), data=aaa,shape = 21,color = "deepskyblue",size =3, fill = "blue", stroke = 4) + 
  geom_point(aes(x=LONGITUDE,y=LATITUDE),data=aaa, size =2,fill = "red", shape = 23)+ 
  theme_void() # usuwanie osi #theme_bw() - czarna ramka
p



# mp_bing <- openmap(c(53.38332836757155,-130.517578125),
#                    c(15.792253570362446,-67.939453125),4,'bing')
# states_map <- map_data("state")
# states_map_merc <- as.data.frame(
#   projectMercator(states_map$lat,states_map$long))
# states_map_merc$region <- states_map$region
# states_map_merc$group <- states_map$group
# 
# 
# 
# autoplot(mp)
# 
# 
# p <- autoplot(mp,expand=FALSE) + geom_point(aes(x=LONGITUDE_PRED,y=LATITUDE_PRED),
#                                             data=aaa) + theme_bw()
# print(p)
# 
# 
# aaa <-  FinnalTable_F_C[1,]
