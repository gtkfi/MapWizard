## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_chunk$set(collapse = TRUE)
knitr::opts_chunk$set(fig.height = 4.5)
knitr::opts_chunk$set(fig.width = 6)
set.seed(13579)
EVAL = x = suppressWarnings(require(starsdata, quietly = TRUE)) && sf::sf_extSoftVersion()["GDAL"] >= "2.2.0"

## ----eval=FALSE---------------------------------------------------------------
#  install.packages("starsdata", repos = "http://pebesma.staff.ifgi.de", type = "source")

## -----------------------------------------------------------------------------
library(stars)
tif = system.file("tif/L7_ETMs.tif", package = "stars")
rasterio = list(nXOff = 6, nYOff = 6, nXSize = 100, nYSize = 100, bands = c(1, 3, 4))
(x = read_stars(tif, RasterIO = rasterio))
dim(x)

## -----------------------------------------------------------------------------
st_dimensions(read_stars(tif))

## -----------------------------------------------------------------------------
rasterio = list(nXOff = 6, nYOff = 6, nXSize = 100, nYSize = 100,
                nBufXSize = 20, nBufYSize = 20, bands = c(1, 3, 4))
(x = read_stars(tif, RasterIO = rasterio))

## -----------------------------------------------------------------------------
rasterio = list(nXOff = 6, nYOff = 6, nXSize = 3, nYSize = 3,
   nBufXSize = 100, nBufYSize = 100, bands = 1)
x = read_stars(tif, RasterIO = rasterio)
dim(x)
plot(x)

## -----------------------------------------------------------------------------
rasterio = list(nXOff = 6, nYOff = 6, nXSize = 3, nYSize = 3,
   nBufXSize = 100, nBufYSize = 100, bands = 1, resample = "cubic_spline")
x = read_stars(tif, RasterIO = rasterio)
dim(x)
plot(x)

## ---- eval=EVAL---------------------------------------------------------------
granule = system.file("sentinel/S2A_MSIL1C_20180220T105051_N0206_R051_T32ULE_20180221T134037.zip", package = "starsdata")
s2 = paste0("SENTINEL2_L1C:/vsizip/", granule, "/S2A_MSIL1C_20180220T105051_N0206_R051_T32ULE_20180221T134037.SAFE/MTD_MSIL1C.xml:10m:EPSG_32632")
(p = read_stars(s2, proxy = TRUE))

## ----eval=EVAL----------------------------------------------------------------
system.time(plot(p))

## ----eval = FALSE-------------------------------------------------------------
#  p = read_stars(s2, proxy = FALSE)

## -----------------------------------------------------------------------------
methods(class = "stars_proxy")

## ----eval=EVAL----------------------------------------------------------------
x = c("avhrr-only-v2.19810901.nc",
"avhrr-only-v2.19810902.nc",
"avhrr-only-v2.19810903.nc",
"avhrr-only-v2.19810904.nc",
"avhrr-only-v2.19810905.nc",
"avhrr-only-v2.19810906.nc",
"avhrr-only-v2.19810907.nc",
"avhrr-only-v2.19810908.nc",
"avhrr-only-v2.19810909.nc")
file_list = system.file(paste0("netcdf/", x), package = "starsdata")
y = read_stars(file_list, quiet = TRUE, proxy = TRUE)
names(y)
y["sst"]

## ----eval=EVAL----------------------------------------------------------------
bb = st_bbox(c(xmin = 10.125, ymin = 0.125, xmax = 70.125, ymax = 70.125))
ysub = y[bb]
st_dimensions(ysub)
class(ysub) # still no data here!!
plot(ysub, reset = FALSE) # plot reads the data, at resolution that is relevant
plot(st_as_sfc(bb), add = TRUE, lwd = .5, border = 'red')

## ----eval=EVAL----------------------------------------------------------------
yy = adrop(y)
yyy = yy[,1:10,1:10,]
class(yyy) # still no data
st_dimensions(yyy) # and dimensions not adjusted
attr(yyy, "call_list") # the name of object in the call (y) is replaced with x:

## ----eval = FALSE-------------------------------------------------------------
#  plot(st_apply(x, c("x", "y"), range))

## ----eval=EVAL----------------------------------------------------------------
(x = st_as_stars(yyy)) # read, adrop, subset

## ----eval=EVAL----------------------------------------------------------------
# S2 10m: band 4: near infrared, band 1: red.
ndvi = function(x) (x[4] - x[1])/(x[4] + x[1])
rm(x)
(s2.ndvi = st_apply(p, c("x", "y"), ndvi))
system.time(plot(s2.ndvi)) # read - compute ndvi - plot 

