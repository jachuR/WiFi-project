


# load --------------------------------------------------------------------
source("Scripts/Preparetion/funk_save_models.R")
library(caret)
library(mlbench)
library(LiblineaR)
set.seed(123)
DATA_FOR_MODEL_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/DATA_FOR_MODEL_N.RDS") 
vData_refID_WAPu_NA_N<- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/vData_refID_WAPu_NA_N.RDS")
names_WAPs <- vars_select(colnames(DATA_FOR_MODEL_N), starts_with("WAP")) #lista wszystkich wapów

### treshold for v and t dataset
DATA_FOR_MODEL_N_S <- DATA_FOR_MODEL_N
vData_refID_WAPu_NA_N_S <- vData_refID_WAPu_NA_N

a <- DATA_FOR_MODEL_N_S[,names_WAPs]
a[a < 0.85] <-0 
DATA_FOR_MODEL_N_S[,names_WAPs] <- a
b <- vData_refID_WAPu_NA_N_S[,names_WAPs]
b[b < 0.85] <-0 
vData_refID_WAPu_NA_N_S[,names_WAPs] <- b
rm(a,b)


# model building -------------------------------------------------------------------
# control

ctrl <- trainControl(method = "repeatedcv", repeats = 3,verboseIter = TRUE) #crossvalidation 3 razy powtórzona | number = (defaults to 10)

 ### for evry building evry floor(real FLOOR, not predicted)


for (B in c("X0","X1","X2")) {
  data_buil <- DATA_FOR_MODEL_N_S %>% filter(BUILDINGID == B) 
  for (Fl in c(unique(DATA_FOR_MODEL_N_S %>% filter(BUILDINGID == B) %>%  select(FLOOR))[[1]])) { #uniqu bo rózne budynki maja różną liczbę pięter 0-3 lub 0-4
  data_buil <- DATA_FOR_MODEL_N_S %>% filter(FLOOR == Fl) 
    
  funk <- c("LONGITUDE ~ .", "LATITUDE ~ .") # jedyny sposob jaki znalazłem żeby w petli uzyc caret dla roznych kolumn
  column <- c("LONGITUDE", "LATITUDE")
  name_v <- paste("validation",B,Fl, sep = "_")
  vData_B_Fl <- vData_refID_WAPu_NA_N_S %>% filter(BUILDINGID == B & FLOOR == Fl) 
  assign(name_v , vData_B_Fl)
    for (i in 1:2) { # 1 i 2 uzywane jako index w funk i column
        set.seed(123)
        FLLfit1KNN <- train(
          formula(funk[i]), #formula()!
          data = data_buil  %>% select(starts_with("WAP"),column[i]),
          method = "knn",
          #preProc = c("center", "scale"),
          tuneGrid = expand.grid(k = c(4:11,15)),
          trControl = ctrl
          )
        name_mod <- paste("FLLfit1KNN",B,Fl,column[i], sep = "_")
        assign(name_mod , FLLfit1KNN) 
        
}}}



# -------------------------------------------------------------------------

# Save multiple objects  ###NIE DZIAŁA###
F_save_models_from_list <- function(objects) {
  
  object_names <- sapply(substitute(list(...))[-1], deparse)
  sapply(1:length(objects), function(i) {  ## co to za cuda??
    filename = paste0("data/models/", object_names[i], ".rds")
    saveRDS(objects[i], filename)
  })
}

F_save_models_from_list(val_list) #lists from model1C_LOOP
