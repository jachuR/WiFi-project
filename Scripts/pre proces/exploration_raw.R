
# -------------------------------------------------------------------------
# GOAL: Find paterns in Data
# DESCRIPTION:
# Tue Dec 17 11:16:04 2019 ------------------------------
# -------------------------------------------------------------------------
# load library
library(lubridate) #detach("package:lubridate")
library(stringr)
# -------------------------------------------------------------------------
# load data
tData <- readRDS("Data/Clean/tData.rds")
vData <- readRDS("Data/Clean/vData.RDS")
# -------------------------------------------------------------------------
# proces

any(is.na(tData)) #FALSE

identical(colnames(tData),colnames(vData)) #TRUE

tDataSummary <- as.data.frame(summary(tData))

## check range
any(tData[,1:520] > 100 | tData[,1:520] < -104) #OK

# groupby checks (same: point, device, user): 1801 difrent results
instances_number <- tData %>%  
  group_by( LONGITUDE, LATITUDE, FLOOR, BUILDINGID, SPACEID, RELATIVEPOSITION, USERID, PHONEID) %>%
  summarise(n())
## example with two different reference points for two different entrances for one room
try_number_13202.2 <- tData %>%  
  filter( FLOOR==3, BUILDINGID==1, SPACEID==202, RELATIVEPOSITION==2, USERID==9, PHONEID==14) %>%
  select(521:529)


# -------------------------------------------------------------------------
#### check similar values of localisation
unique8 <- unique(str_sub(string = as.character(tData$LONGITUDE), start = 1, end = 8))
unique11 <- unique(tData$LONGITUDE)
unique11 <- data.frame(unique11) %>%  mutate(n8=str_sub(string = as.character(unique11), start = 1, end = 8))
duplicates <- unique11[which(duplicated(unique11$n8)),]
temp <- unique11[unique11$n8 %in% duplicates$n8,]
similar_loc <- tData[tData$LONGITUDE %in% temp$unique11,521:529]
similar_loc_unique <- distinct(similar_loc , LONGITUDE, .keep_all = TRUE)



# -------------------------------------------------------------------------
# output
## qgis file
write.csv(try_number_13202.2, file="C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/try_number_13202.2.csv")
write.csv(similar_loc_unique, file="C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/similar_loc_unique.csv")
write.csv(refer_name_unique[,521:530], file="C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/refer_name_unique.csv")

# -------------------------------------------------------------------------













