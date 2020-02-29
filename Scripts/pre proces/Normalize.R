
# input -------------------------------------------------------------------



DATA_FOR_MODEL <- read_rds("Data/Clean/DATA_FOR_MODEL.RDS")
vData_refID_WAPu_NA <- read_rds("Data/Clean/vData_refID_WAPu_NA.RDS")

names_WAPs <- vars_select(colnames(DATA_FOR_MODEL), starts_with("WAP")) #lista wszystkich wapów


# nomalize_it -------------------------------------------------------------




normalize_it <- function(x){
  (x-min(x))/(max(x)-min(x))
}


# Tdata
DATA_FOR_MODEL_N <- DATA_FOR_MODEL
DATA_FOR_MODEL_N[, names_WAPs] <- t(apply(DATA_FOR_MODEL_N %>% select(starts_with("WAP")), 1, normalize_it))


# 0 variance rows ---------------------------------------------------------
sum(is.na(DATA_FOR_MODEL_N)) # 0 variance gives NAs
rows_variance_0 <-  DATA_FOR_MODEL_N %>% filter_at(vars(names_WAPs), any_vars(is.na(.))) 
#1_3_006_2_4864_469.92_17_22


# remove 0 variance row ---------------------------------------------------

DATA_FOR_MODEL_N <- DATA_FOR_MODEL_N %>%  filter(sesion_ID !="1_3_006_2_4864_469.92_17_22")



# Vdata -------------------------------------------------------------------

vData_refID_WAPu_NA_N <- vData_refID_WAPu_NA
vData_refID_WAPu_NA_N[, names_WAPs] <- t(apply(vData_refID_WAPu_NA_N %>% select(starts_with("WAP")), 1, normalize_it))



# output ------------------------------------------------------------------

saveRDS(DATA_FOR_MODEL_N,"Data/Clean/DATA_FOR_MODEL_N.RDS")
saveRDS(vData_refID_WAPu_NA_N, "Data/Clean/vData_refID_WAPu_NA_N.RDS")
