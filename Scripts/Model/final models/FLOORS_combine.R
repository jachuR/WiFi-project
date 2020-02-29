FinnalTableX0F <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/FinnalTableX0F.RDS")
FinnalTableX1F <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/FinnalTableX1F.RDS")
FinnalTableX2F <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/FinnalTableX2F.RDS")

FinnalTable_F <- rbind(FinnalTableX0F,FinnalTableX1F,FinnalTableX2F)

confusionMatrix(data =  FinnalTable_F$FLOOR_PRED, reference = factor(FinnalTable_F$FLOOR))

saveRDS(FinnalTable_F,"Data/Results/FinnalTable_F.RDS")





# models ------------------------------------------------------------------


FFit3svm_X0_S <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/models/FFit3svm_X0_S.RDS")
FFit3knn_X2_S <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/models/FFit3knn_X2_S.RDS")
FFit3knn_X1_S <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/models/FFit3knn_X1_S.RDS")

FFit3svm_X0_S
FFit3knn_X1_S
FFit3knn_X2_S


confusionMatrix(data =  FinnalTableX0F$FLOOR_PRED, reference = factor(FinnalTableX0F$FLOOR))
confusionMatrix(data =  FinnalTableX1F$FLOOR_PRED, reference = factor(FinnalTableX1F$FLOOR))
confusionMatrix(data =  FinnalTableX2F$FLOOR_PRED, reference = factor(FinnalTableX2F$FLOOR))

