### zlepek róznych kodów, ale ostatecznie prawie daje to co potrzebuje, obrys budynku! 
#gdzies gubi jedna wsporzedna po drodze row36 zamienia sie na Na i musiałem go wywalic :/





library(XML)
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_101') # for 64-bit version %>% 
library(OpenStreetMap)
library(lubridate)
## 
## Attaching package: 'lubridate'
## The following object is masked from 'package:base':
## 
##     date
library(ggmap)
## Loading required package: ggplot2
library(ggplot2)
library(raster)
## Loading required package: sp
library(sp)
#Now, we define a function that shifts vectors conveniently:
  
  shift.vec <- function (vec, shift) {
    if(length(vec) <= abs(shift)) {
      rep(NA ,length(vec))
    }else{
      if (shift >= 0) {
        c(rep(NA, shift), vec[1:(length(vec)-shift)]) }
      else {
        c(vec[(abs(shift)+1):length(vec)], rep(NA, abs(shift))) } } }
  
  options(digits=10)
  # Parse the GPX file
  pfile <- htmlTreeParse(file = "C:/Users/jator/Desktop/export.gpx", error = function(...) {
  }, useInternalNodes = T)
  # Get all elevations, times and coordinates via the respective xpath
  elevations <- as.numeric(xpathSApply(pfile, path = "//trkpt/ele", xmlValue))
  times <- xpathSApply(pfile, path = "//trkpt/time", xmlValue)
  coords <- xpathSApply(pfile, path = "//trkpt", xmlAttrs)
  
  
  str(coords)
  lats <- as.numeric(coords["lat",])
  lons <- as.numeric(coords["lon",])
  
  
  geodf <- data.frame(lat = lats, lon = lons)
  rm(list=c("elevations", "lats", "lons", "pfile", "times", "coords"))
  head(geodf)
  
  geodf$lat.p1 <- shift.vec(geodf$lat, -1)
  geodf$lon.p1 <- shift.vec(geodf$lon, -1)
  head(geodf)
  
  plot(rev(geodf$lon), rev(geodf$lat), type = "l", col = "red", lwd = 3, bty = "n", ylab = "Latitude", xlab = "Longitude")
  
  # References:
  # http://lists.maptools.org/pipermail/proj/2001-September/000248.html (has typos)
  # http://www.remotesensing.org/geotiff/proj_list/swiss_oblique_cylindrical.html
  #
  # Input coordinates.
  #
  x <- geodf$lon.p1[1:35]
  y <- geodf$lat.p1[1:35]
  #
  # Define the coordinate systems.
  #
  library(rgdal)  ## 
  d <- data.frame(lon=x, lat=y)
  coordinates(d) <- c("lon", "lat")
  proj4string(d) <- CRS("+init=epsg:4326") # WGS 84
  CRS.new <- CRS("+init=epsg:3857") ## web mercator 
  # (@mdsumner points out that
  #    CRS.new <- CRS("+init=epsg:2056")
  # will work, and indeed it does. See http://spatialreference.org/ref/epsg/2056/proj4/.)
  d.ch1903 <- spTransform(d, CRS.new)
  #
  # Plot the results.
  #
  # par(mfrow=c(1,3))
  # plot.default(x,y, main="Raw data", cex.axis=.95)
  # plot(d, axes=TRUE, main="Original lat-lon", cex.axis=.95)
  # plot(d.ch1903, axes=TRUE, main="Projected", cex.axis=.95)
  # building <- unclass(d.ch1903)
  # 
  plot(d.ch1903, axes=TRUE)
  plot(rev(geodf$lon), rev(geodf$lat), type = "l", col = "red", lwd = 3, bty = "n", ylab = "Latitude", xlab = "Longitude")
  plot(rev(building_object$lon), rev(building_object$lat), type = "l", col = "red", lwd = 3, bty = "n", ylab = "Latitude", xlab = "Longitude")
  building_object$lon
  
  # brakuje czesci kodu:/ na pewno trzeba uzyc gdzies @ zeby z obiektu typu S4(?) wyciagnac tabel z dlugoscia i szerokoscia
  @