# Data handling & processing

The ‘esd’-package contains a set of different methods for handling and processing data and model results. All the processes, however, are designed to leave a ‘stamp’ that shows how the
objects have been created and is saved in the ‘history’ attribute of an object. The history can be extracted using the function ‘history()’. This is very useful as it makes the analysis more
transparent, traceable, and reproducible. One important objective of ‘esd’ is also to make data handling simple and intuitive, as well as efficient.
All ‘esd’ functionalities will use the same type of arguments and logic.
For instance, the argument ‘it’ is used to pass a time index to the call, whereas ‘is’ is used as a space index - these are for instance used to extract sub-samples from the data, e.g. when
one wants to work on a subset (in time and/or space) of the original data (e.g. a smaller region, a shorter interval, or a specific season/month; see below).

## Formulas & functions
### Small handy functions
The two functions ‘g2dl’ (Greenwich to dateline) and ‘sp2np’ (south-pole to north-pole) were included in ‘esd’ to organise and sort data in a consistent way. Many gridded data come
with different choices: some are ordered from north to south, others from south to north; some start from Greenwich (0 degrees east) whereas others start from the date line (180 degrees west).
Other functions to simplify data processing include ‘lon’ (longitude), ‘lat’ (latitude), ‘alt’ (altitude), ‘cntr’ (country),‘loc’ (location name), ‘varid’ (variable name), and ‘stid’ (sta-
tion number). Some of these only apply to ‘station’ objects. 

### Wet-means, frequencies, counts and spells
A number of functions have been introduced to make analysis of precipitation simpler, such as the estimation of wet-day mean (a threshold is set to 1mm/day as default) or wet-day fre-
quency. These functions include ‘wetmean’, ‘wetfreq’, ‘count’, ‘nv’, and ‘spell’, and can be used in association with ‘aggregate’. Some of these functions are wrappers for the function
‘exceedance’ which discards all data with a value lower than a given threshold value. Table 2 gives an overview and some examples are provided in Example 3.1 and 3.2.

Table 2: A list of specialised functions in ‘esd’ designed to make climate analysis simple and user-friendly.

| `wetmean()` | Estimate the wet-day mean µ. Default threshold is 1mm/day. |
| `wetfreq()` | Estimate the wet-day frequency fw. Default threshold is 1mm/day. |
| `exceedance`  | Select the data with values exceeding a critical threshold value. |
| `count` | Count data points in sample. |
| `C.C.eq`  | Clausius-Clapeyron equation. |
| `NE`  | Predict number of events, given a frequency and a sample size. |
|`spell`  | Estimate the spell lengths (consecutive days/straights) of events. |
|`precip.vul` | Simple vulnerability index associated with precipitation: Vp = µ/fw. |
|`t2m.vul`  | Simple vulnerability index associated with temperature based on consecutive number of hot days above a critical threshold (default 30 degrees C): VT = nchd. |
|`precip.rv`  | Simple and rough estimate of return value for weak-to-moderate ‘extremes’: xτ = − ln(1/(fwτ ))µ. |
|`nv` | Number of valid data points in sample. |
|`precip.Pr`  |Simple and crude estimate of the probability of precipitation exceeding a threshold (default: 10mm/day): P r(X > x) = fw exp(−x/µ) assumes exponential distribution.|
|`t2m.Pr()` |Simple and crude estimate of the probability of temperature exceeding a threshold (default: 30 degree C): P r(X > x) = N (µ, σ) assumes normal distribution.|

Example 3.1. # Load data for Bjornholt 
```R
data(bjornholt)
y <- bjornholt
# Annual wet-mean:
mu <- annual(y,FUN=’wetmean’)
# Plot the result for the period 1883 to 2014
plot(mu,ylim=c(4,14))
# Annual wet-freq:
fw <- annual(y,FUN=’wetfreq’)
# Plot the result for the period 1883 to 2014
plot(subset(fw,it=c(1883,2014)),ylim=c(0.2,0.5))
# Annual number of events with y > 10mm/day:
nw <- annual(y,FUN=’count’,threshold=10)
# Plot the result for the period 1883 to 2014
plot(subset(nw,it=c(1883,2014)),ylim=c(10,60))
# Compute wet/dry spells
sp <- spell(y,threshold=1)
# Plot the result
plot(sp)
```

Figure 9: Plots of precipitation statistics at Bjornholt such as a) wet-day mean (µ), b) wet-day
frequency (fw), c) number of events with precipitation higher than 10mm, and d) wet/dry spells.



Example 3.2.
```R
# Load ECAD dataset over Norway recording a 100 years of daily data
ecad <- station(param="precip",src="ecad",cntr="Norway",nmin=100)
# Map the vulnerability index:
map(ecad,FUN=’precip.vul’,cex=1.2,xlim=c(-10,40), col="black",colbar=list(col=heat.colors(20)))
# Map approximate 10-year return values:
map(ecad,FUN=’precip.rv’,cex=1.2,xlim=c(-10,40), col="black",colbar=list(col=heat.colors(20)))
```
Figure 10: An example of a plot of the vulnerability index µ/fw (left) and an approximation of daily 10-year return values (right) for a selection of station from the ECA&D recording at least
a 100 years of data.

## re-gridding
Gridded data often come on different spatial grids and/or resolutions, such as re-analyses, global climate models (GCMs) and regional climate models (RCMs). In order to compare these
or apply a common set of analyses to the different model results or reanalysis, it is necessary to present the data on a common grid resolution first. This is achieved via the function called
‘regrid’ which performs a bilinear interpolation from the original grid resolution to a new one. ‘regrid’ is also an S3-built in function and can be applied on all ‘esd’ objects. Another
strength of ‘regrid’ is that it allows also interpolating from gridded data or GCM/RCM model results into a specific location or station. Regrid can take several minutes and is time consuming
depending on the selected region and grid resolution.
Again, the common syntax for the argument ‘is’ is shown, where ‘is’ refers to spatial indexing whereas ‘it’ is for temporal indexing. The methods have been designed with some
flexibility in mind, so that when ‘is’ is assigned another field type, it will interpolate the data onto that specific grid. Similarly, if ‘is’ is given a station object, then it will interpolate the
data to the same coordinate as the station (the output will then be a station object). The general syntax of ‘regrid’ is as follows regrid(x,is,...)
There is a difference between ‘is’ and ‘it’ because the spatial indexing can include both longitude and latitude dimensions, as well as a number of stations. Hence, the ‘is’ is often
given a ‘list’ object (Example 3.3).

Example 3.4 shows the re-gridding between the NCEP reanalysis and NorESM.M global climate model result for an area covering Europe (30W–30E/40N–70N). In this particular case,
both the gridded products (NCEP and NorESM.M) have the same spatial resolution of 2.5
degrees, but ‘regrid’ works also with different grid resolutions.

### How the re-gridding works
The re-gridding is based on a bi-linear interpolation according to the linear algebra expression 
X′ = W X (1)
W is a sparse matrix of weights since each new grid cell is a weighted sum of the four surrounding grid cells. The sparse character saves computer resources compared to the full
weight matrix which would have the dimensions of the product of X′ and X. Thus, the re-gridding becomes more efficient by (a) utilising the information about the sparseness (i.e. only
needs the weights and the index of the surrounding grid cells to the point of interest) and (b) computing the weights only once, then use using the ‘apply’ function rather than for loops to
weight all time steps.

## Nearest data point
An alternative to re-gridding is to select the nearest data point, as a bi-linear interpolation will have an influence on extremes through the estimation of values in terms of weighted sums
of nearby points. The ‘esd’ package provides the function ‘nearest’ that selects a subset of the nearest point as `obs <- nearest(obs,is="any rcm or gcm object")`

## Subsetting
It is sometimes necessary to limit the range of data, either by selecting an interval in time or a subregion of the data. The method ‘subset’ in the ‘esd’ tool extends the R-base ‘subset’
method to ‘esd’ objects and classes and can be used to extract a time interval or a specific date, month, season, sub-group of stations, or a smaller region of a field. Its use is meant to be
versatile and is based on the two arguments ‘it’ and ‘is’ to make a selection possible as `subset(x,it=NULL,is=NULL,...)`

The subsetting works for both fields and group of stations. In the examples below, Y can be a (group of) station(s) or a field object. In Example 3.5, the argument ‘it’ is used to extract
a specific time interval of the input data Y. It is also possible to select a subset according to a second data object as

```R
# Select the same time period as covered by data object X
y <- subset(Y,it=X))
# Select the same spatial region/group of stations as in X
y <- subset(Y,is=X))
```
or to combine several selection criteria as in Example 3.6.
It is usually wise to use ‘subset’ before other data processing (e.g. aggregate) to reduce computation time.

Example 3.3.
```R
# Load NCEP 2m air temperature
t2m <- t2m.NCEP(lon=c(-30,30),lat=c(40,70))
# map the original field
map(t2m)
# Regrid based on the new lon and lat values
y <- regrid(t2m,is=list(lon=seq(-5,15,by=0.5),lat=seq(55,65,by=0.5)))
# Map on the new grid
map(y)
```

Example 3.4.
```R
# Get NCEP data
> ncep <- t2m.NCEP(lon=c(-15,45),lat=c(35,70))
# Display the latitude values
> lat(ncep)
# Compute the grid resolution
> diff(lat(ncep))
# Display the longitude values
> lon(ncep)
# Compute the resolution in the lon axis
> diff(lon(ncep))
# Get GCM data
> gcm <- t2m.NorESM.M(lon=c(-15,45),lat=c(35,70))
> lat(gcm)
> diff(lat(gcm))
> lon(gcm)
> diff(lon(gcm))
# Do the re-gridding # this line does not work
> gcm.regrid <- regrid(gcm, is=ncep)
# Make sure that both longitudes are set to data line (i.e. greenwich=FALSE)
> ncep <- g2dl(ncep,greenwich=FALSE)
> gcm <- g2dl(gcm,greenwich=FALSE)
# Do the re-gridding
> gcm.regrid <- regrid(gcm, is=ncep)
> lat(gcm.regrid)
> lon(gcm.regrid)
```

Example 3.5.
```R
data(Oslo)
# Extract an interval:
y <- subset(Oslo,it=as.Date(c("1883-01-01","2013-12-05")))
# Extract only the winter data (use aggregate for winter statistics)
djf <- subset(y,it=’djf’)
# Extract data for May:
may <- subset(y,it=’May’)
```

Example 3.6.
```R
# Retrieve stations across Scandinavian regions from the
# ECA$\&$D dataset with a minimum of 50 years of data
y <- station(src="ecad",cntr="norway",nmin=50)
# Show the selected stations including all available stations
map(y,cex=1.4,col="red",bg="pink",showall=TRUE)
# Subset stations with altitude higher than 100m
y1 <- subset(y,is=list(alt=100))
# Show the stations with elevation greater than 100m above sea level:
map(y1,cex=1.4,col="darkred",bg="red",showall=TRUE)
# Show the stations with elevation below 100m above sea level:
y2 <- subset(y,is=list(alt=-100))
map(y2,cex=1.4,col="darkred",bg="orange",showall=TRUE)
```

Figure 11: Maps of available weather stations from the ECA&D with a minimum of 50 year recorded values including a sub-selection of stations showing higher (b) and lower (c) elevation
than 100m a.s.l.

## 3.5 Combining and synchronising
It is important to combine different data objects and make sure that they are synchronised before the analysis can be made to identify links and dependencies. It may also be necessary
to combine several station objects into a group of objects, for instance in order to perform a canonical correlation analysis (CCA)CCA. The method is ‘combine’.
The function ‘matchdate’ is used to synchronise any object `x` with the time index specified by `it` as 
```R
matchdate(x,it=y)
```
`matchdate()` will return the subset of `x` that matches the time index of `y`.

## 3.6 Anomalies
Geophysical data tends to have a strong seasonal cycle, and often the seasonal variations are of less interest than year-to-year variations. Anomalies are the variations after the seasonal
cycle has been removed. The method ‘anomaly’ can be applied to stations and field objects, for daily, monthly, and seasonal data. The converse is ‘climatology’.


## 3.7 Aggregate: monthly, seasonal and annual statistics
It is also convenient to compute trends on annual values rather than daily values, as the latter are noisy. To do so the S3-built in method ‘aggregate’ is used which allows splitting the
data into subsets (e.g. years) and computes summary statistics for each subset (e.g. maximum values) as `aggregate(x,by=year,FUN=’max’,...)`

Aggregate has been extended to deal with ‘esd’ objects, and returns the result as an identical ‘esd’ object with updates. Classes and attributes are updated accordingly (see Example 3.7).
The aggregate function can also be used to create coarser grids where the boxes contain spatially aggregated values from a higher grid resolution (Example 3.8).

## 3.8 Spatial averaging of field objects - aggregate.area
It is interesting to investigate if there are any global signals affecting the local climate. For this purpose, the ‘esd’ package makes it convenient to compute statistics on spatial averaging of an
object over a specific spatial domain or an area of interest. The function `aggregate.area()` is used to compute an area aggregate (e.g. average means, maximum, sum, ...) taking into account
that the grid box area varies with latitude. The following equations are used:


I
J
1 X
X
X
¯
x =
(ϕ
ϕ
I

i xi,j )/

i=1
j=1
ϕi = cos(2 π lati / 360)
where i and j are indices in the longitude and latitude respectively, and lati is the latitude value at point i.

`aggregate.area(x,is=NULL,it=NULL,FUN=’sum’,na.rm=TRUE,smallx=FALSE)`

Example 3.9 shows the spatial averaging of the projected global mean temperature from the CMIP5 NorESM-M RCP4.5 experiment.

It is also convenient to compare the global mean temperature as produced by several GCMs (Figure 12). A demo script is made available in the demo ‘esd’ package called “global tas anomaly.R”.
The script computes the global mean anomaly temperature for all CMIP3 and CMIP5 experiments provided by the KNMI Climate-Explorer web portal. All GCM data need to be down-
loaded locally before the script is run. The results can then be compared to the Figure 1 of Knutti and Sedl´aˇcek (2013) which shows the evolution of the global temperature change (mean
and one standard deviation as shading) relative to 1986–2005 for the SRES scenarios run by the CMIP3 and the RCP scenarios run by the CMIP5 experiments. This figure gives a good
summary of the global mean warming signal predicted by both experiments and the inter-model spread. Note that the shaded area would be different if it was based on the ensemble model outputs for each CMIP experiment as the authors gave a confidence interval based on one standard
deviation of the ensemble mean.

Figure 12: Global mean temperature change for the SRES scenarios run by CMIP3 and the RCP scenarios run by CMIP5 experiments, respectively, relative to the period 1986-2005. The shaded
area shows one standard deviation from the mean based on all scenarios for each experiment.

Example 3.7.
```R
# Load data for "Bjornholt" station
data(bjornholt)
# Check the class of the object
class(bjornholt)
## [1] "station" "day"
"zoo"
# Aggregate on annual maximum values
bjornholt <- annual(bjornholt,FUN=’max’)
# Check the class of the aggregated object
class(bjornholt)
## [1] "station" "annual"
"zoo"
# Plot the results
plot(bjornholt)
```

Figure 13: Plotting the annual maximum values of daily precipitation recorded at ‘Bjornholt’
weather station.

Example 3.8.
```R
# Load 2m air temperature from NCEP reanalysis on a resoltuion of 2.5 deg.
t2m <- t2m.NCEP()
# Do the spatial aggregation
x <- aggregate(t2m,by=list(lon=seq(0,360,by=10),lat=seq(0,360,by=10)),FUN=’mean’)
# Map the results
map(x)
```

Figure 14: Maps of the original (a) and aggregated (b) spatial field of NCEP 2m air temperature.

Example 3.9.
```R
# Load 2m air temperature from the NorESM.M global climate model
t2m <- t2m.NorESM.M()
# Compute the areal mean over the whole domain
T2m <- aggregate.area(t2m,FUN=’mean’)
# Plot the annual aggregated values
plot(annual(T2m),ylim=c(11.5,17.5))
```

Figure 15: Global average of 2m air temperature from the NorESM global climate model. The
error bars show 2 times the standard deviation computed based on observations.

## 3.9 Transformations and conversions: as.
A range of transformations between different type of objects can be done with the ‘as’ method.

Table 3: The ‘esd’ extension of the `as.` method. Some of these are the same as some other functions, e.g. `annual` and `as.annual` 
as.4seasons | as.field.station | as.4seasons.day | as.field.station | as.4seasons.default | 
as.field.zoo
as.4seasons.field
as.fitted.values
as.4seasons.spell
as.fitted.values.ds
as.4seasons.station
as.monthly
as.annual
as.original
as.annual.default
as.original.data
as.annual.integer
as.original.data.ds
as.annual.numeric
as.original.data.station
as.annual.spell
as.original.station
as.annual.yearqtr
as.pattern
as.anomaly
as.pattern.cca
as.anomaly.default
as.pattern.corfield
as.anomaly.field
as.pattern.ds
as.anomaly.station
as.pattern.eof
as.anomaly.zoo
as.pattern.field
as.appended
as.pattern.mvr
as.appended.ds.comb
as.pca
as.appended.eof.comb
as.pca.ds
as.appended.field.comb
as.pca.station
as.calibrationdata
aspect
as.calibrationdata.ds
as.residual
as.calibrationdata.station
as.residual.ds
as.climatology
as.residual.station
as.comb
as.seasons
as.comb.eof
as.stand
as.ds
as.stand.station
as.eof
as.station
as.eof.appendix
as.station.data.frame
as.eof.comb
as.station.ds
as.eof.eof
as.station.eof
as.eof.field
as.station.field
as.eof.zoo
as.station.list
as.field
as.station.pca
as.field.comb
as.station.spell
as.field.default
as.station.zoo
as.field.eof
as.eof.list
34
