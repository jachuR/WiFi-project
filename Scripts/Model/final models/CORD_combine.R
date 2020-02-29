FinnalTableX2LONGITUDE <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/FinnalTableX2LONGITUDE.RDS")
FinnalTableX0LATITUDE <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/FinnalTableX0LATITUDE.RDS")
FinnalTableX0LONGITUDE <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/FinnalTableX0LONGITUDE.RDS")
FinnalTableX1LATITUDE <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/FinnalTableX1LATITUDE.RDS")
FinnalTableX1LONGITUDE <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/FinnalTableX1LONGITUDE.RDS")
FinnalTableX2LATITUDE <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/FinnalTableX2LATITUDE.RDS")



FinnalTable_F_C_X0 <- cbind(FinnalTableX0LATITUDE, LONGITUDE_PRED = FinnalTableX0LONGITUDE$pred_loc) %>%  rename(LATITUDE_PRED = pred_loc)
FinnalTable_F_C_X1 <- cbind(FinnalTableX1LATITUDE, LONGITUDE_PRED = FinnalTableX1LONGITUDE$pred_loc) %>%  rename(LATITUDE_PRED = pred_loc)
FinnalTable_F_C_X2 <- cbind(FinnalTableX2LATITUDE, LONGITUDE_PRED = FinnalTableX2LONGITUDE$pred_loc) %>%  rename(LATITUDE_PRED = pred_loc)


FinnalTable_F_C <- rbind(FinnalTable_F_C_X0,FinnalTable_F_C_X1,FinnalTable_F_C_X2)


 postResample(FinnalTable_F_C$LATITUDE_PRED, FinnalTable_F_C$LATITUDE)
 postResample(FinnalTable_F_C$LONGITUDE_PRED, FinnalTable_F_C$LONGITUDE)

saveRDS(FinnalTable_F_C,"Data/Results/FinnalTable_F_C.RDS")


load

FFit3knn_X1_S
FFit3svm_X0_S
FFit3knn_X2_S




confusionMatrix(data = FinnalTable_F_C$BuilPRED,reference = as.factor(FinnalTable_F_C$BUILDINGID))
