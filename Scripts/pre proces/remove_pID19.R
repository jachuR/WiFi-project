

# szukamy ile mamy zer w df
a <- tData_refID_WAPu_sesionID_rem[,1:312] == 0
sum(a) #102

#joan 
# dodajemy rowID jako kolumne (przyda sie poźniej żeby odnaleźć te wiersze w data set).
# filtrujemy wszystkie wiersze w poszukiwaniu TRUE, jeśli gdzieś występuje to dodajemy do temp
temp <- a %>% 
  as_tibble() %>% 
  tibble::rowid_to_column(var = "id") %>% 
  filter_all(any_vars(. == TRUE))

# problemem jest to że 1 = TRUE, więc wiersz z ID 1 też jest dodany choć nie ma żadnego TRUE
# tu to sprawdzamy:
t(temp[1,]) #t- matrix transpose 

# tu pericles sprawdzał, czy w którymś wierszu są same FALSE, ale z pominięciem pierwszej kolumny (id)
sum(apply(temp[,c(2:ncol(temp))], 1, sum) == 0)

# tu wykluczamy pierwszy wiersz(ten dodany tylko dlatego że ID=1) dla pliku wynikowego
temp2 <- tData_refID_WAPu_sesionID_rem[temp$id[c(2:nrow(temp))],]

write.csv(temp2,"temp2.csv")

# wszystkie problemy powoduje PHONEID == 19, oprócz zer zdażają mu się inne zawyżania wartości (Nexus 4, 4.2.2 6)
temp3 <- tData_refID_WAPu_sesionID_rem %>% filter(PHONEID==19)
nrow(temp3) ## 980 (chyba trzeba wszystkie usunąć)

temp4 <- tData_refID_WAPu_sesionID_rem %>% filter(PHONEID!=19)

tData_refID_WAPu_sesionID_rem_19 <- temp4

saveRDS(tData_refID_WAPu_sesionID_rem_19,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu_sesionID_rem_19.RDS")

rm(temp,temp2,temp3,temp4)
