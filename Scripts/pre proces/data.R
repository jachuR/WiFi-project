library(readr)
library(anytime)
library(lubridate) #detach("package:lubridate")


#treaning data set
tData <- read_csv("Data/Raw/trainingData.csv")
tData$TIMESTAMP <- anytime(tData$TIMESTAMP, tz="CET")
saveRDS(tData,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData.rds")

#validation data set
vData <- read_csv("Data/Raw/validationData.csv")
vData$TIMESTAMP <- anytime(vData$TIMESTAMP, tz="CET")
saveRDS(vData,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/vData.RDS")






