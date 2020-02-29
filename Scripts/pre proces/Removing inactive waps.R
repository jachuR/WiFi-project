
# load --------------------------------------------------------------------

tData_refID <- read_rds("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/Data_refID.RDS")
vData <- readRDS("Data/Clean/vData.rds")




# Removing inactive waps-------------------------------------------------------------------------
#####
# sprawdzamy wariancje, jeśli wynosi zero to znaczy to przyjmujemy ze dany nadajnik w ogóle nie nadaje w danym zestawie danych
# potem usówamy z obu zestawów danych wszystkie nadajniki które nadają tylko w jenym zestawie
#####


###var tData
acctiveWAP_tdata <- apply(select(tData_refID,starts_with("WAP")),2,var)!=0 #zastosuj funkcje var do każdej kolumny(2) która spełnia warunek
sum(acctiveWAP_tdata )


# select(tData,starts_with("WAP")) - każda golumna która zaczyna się od "WAP"



###var vData 

acctiveWAP_vdata <- apply(select(vData,starts_with("WAP")),2,var)!=0
sum(acctiveWAP_vdata )


tData_refID_WAPu <- cbind(select(tData_refID,starts_with("WAP"))[,acctiveWAP_tdata & acctiveWAP_vdata],
                          select(tData_refID,-starts_with("WAP")))

vData_refID_WAPu <- cbind(select(vData,starts_with("WAP"))[,acctiveWAP_tdata & acctiveWAP_vdata],
                          select(vData,-starts_with("WAP")))

# Outputs -----------------------------------------------------------------

saveRDS(tData_refID_WAPu,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/tData_refID_WAPu.RDS") 
saveRDS(vData_refID_WAPu,"C:/Users/jator/Desktop/Ubiqum/3.2/Data/Clean/vData_refID_WAPu.RDS") 

