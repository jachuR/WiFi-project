# Save multiple objects
F_save_models <- function(... , folder= paste0("Data/models/")) {
  objects <- list(...)
  object_names <- sapply(substitute(list(...))[-1], deparse)
  sapply(1:length(objects), function(i) {  ## co to za cuda??
    filename = paste0(object_names[i], ".rds")
    saveRDS(objects[[i]],file =  paste0(folder, filename))
  })
}


#https://stackoverflow.com/questions/43304135/save-multiple-objects-using-saverds-and-lapply

########

# -------------------------------------------------------------------------
#moje testy:

# F_save_models <- function(models) {
#   #models - lista modeli do zapisania
#   
#   for (model in models) {
#     write_rds(model, paste0("data/models/",deparse(substitute(model)),".rds"))
#     
#     
#   }
#   
#   
# }
# 
# models <- list(BFit1KKNN,BFit1rpart) 
# 
# 
# 
# 
# 
# 
# 
# for (model in models) {
#   write_rds(model, paste0("data/models/",model,".rds"))
#   
#   
# }
# 
# 
# for (model in models) {
#   (substitute(model))
#   
#   
# }