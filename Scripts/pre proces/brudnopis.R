any(tData[,1:520] > 100 | tData[,1:520] < -104) #OK
which(tData[,1:520] > 100 | tData[,1:520] < -100,arr.ind = T) # arr.ind daje informacje o row i columny zamiast podawać bezużyteczny numer obserwacji



refer_name %>%  filter(refID=="0_0_102_2_4949_637.25") %>% select (WAP033,PHONEID)




## unikalane nazwy punktów referencyjnych
refer_name_unique <- distinct(tData_refID , refID, .keep_all = TRUE)


BFit1KKNN
BFit1PLS
BFit1rpart





plot_ly(MEDIAN_per_session_NA_name %>%filter(USERID == 1), x =~LONGITUDE, y = ~ LATITUDE)
