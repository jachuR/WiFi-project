

temp <- predict(BFit3SVMSig,vData_refID_WAPu_NA1000)
temp

confusionMatrix(data = temp[[1]],reference = factor(vData_refID_WAPu_NA1000$BUILDINGID))

class(temp[[1]])
class(factor(vData_refID_WAPu_NA1000$BUILDINGID))
