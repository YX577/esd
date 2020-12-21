---
layout: default
title: Functionalities
nav_order: 2
permalink: /functions/
---

# Functionalities
A short and single line in R produces a complex figure with various information: the generic ‘plot’ yields a plot as seen in the left panel of Figure 4 or can make a graphical presentation of downscaled results that both shows the numbers as well as their quality. How is that possible?
The trick is to define different data object types, known as ‘classes’ in R and define a specific data reference syntax (DRS) or common information model (CIM) that includes the meta-data in the working computer memory as well as in files stored on discs. This is all done automatically on-the-fly behind the scene, so that the user does not have to worry about these matters (it is of course possible to change the meta-data to e.g. correct for potential errors).
The command library(‘esd’) must be given at any new open R session. The R-package can be installed directly from Github (https://github.com/metno/esd) or
Figshare for Mac/Linux11 and Windows12)

## Retrieving data: I/O
There are different types of data that can be handled by the ‘esd’ tool: station data, gridded data, and (storm) trajectories. Station data contain meteorological observations recorded at weather (or hydrological) stations, while gridded data can comprise various analyses (e.g. E-OBS gridded version of the European and Climate Assessment data set), reanalyses (e.g. NCEP, ERA, ...) or global/regional climate model results (e.g. CMIP3/5 experiment). Trajectories are
mainly used for analysis of storm tracks (e.g. IMILAST13). There are two main methods for retrieving data in the ‘esd’ tool: ‘station’ and ‘retrieve’.
It is also possible to read data using the R-built in functions and convert it to esd data format. This requires more effort from the user using the ‘esd’ pre-defined functions `as.station`, `as.field`), and `as.trajectory`. The package comes with a set of sample data mainly included for demonstration purposes,
testing, or troubleshooting. For gridded data, these are filtered data (mainly for reducing the size of the data objects) and should not be used as predictors in the actual analysis. For instance, air temperature reanalysis data are stored as a set of 20 empirical orthogonal functions (EOFs) with global coverage, which are then transformed to a field object upon a retrieval. However, the sample station data can be used without restrictions and corresponds to observed values at a specific location (e.g. `data(Oslo)` or `nacd=station(src='nacd')`).

11http://figshare.com/articles/esd\_for\_Mac\_amp\_Linux/1160493
12http://figshare.com/articles/esd\_for\_windows/1160494
13http://www.proclim.ch/imilast/index.html

### Function `retrieve()`
The ‘retrieve’ is designed to read data from NetCDF files following the standard Climate and Forecast (‘CF’) conventions and ordered on a longitude-latitude grid. The latter could be regular or irregular grid (e.g. the output of the Weather Research and Forecasting model (WRF) or any outputs on a rotated grid from RCMs). The function ‘retrieve’ also performs quick checks of the data itself to verify that the meta data and data are consistent. For instance, in case the frequency of the data is missing, `retrieve()` will try to detect the frequency automatically form the data itself. The function `retrieve` returns two types of objects depending on the type of the spatial grid. For instance, data stored on a regular grid is returned as `field` objects including attributes containing meta data, and data stored on irregular grid - such as rotated longitude-latitude grids - are returned as a `station` objects. 

The function `retrieve()` has also been adapted to read global climate data from the CMIP3/5 experiments, most of the global reanalysis such as those provided by the European Centre for Medium-Range Weather Forecasts (ECMWF) known as ERA-40 and ERA-INTERIM, the National Center for Environmental Prediction (NOAA) known as NCEP/NCAR reanalysis, the Japan Meteorological Agency (Japanese Reanalysis JRA-25,55), and the NASA GSFC Global Modeling and Assimilation Office (GMAO) known as MERRA reanalysis. A full overview of all available reanalysis can be found at http://reanalysis.org/atmosphere/overview-current-reanalyses.
As for now, `retrieve()`, does not display a list of missing attributes that are mandatory for further post-processing of the data. The user must add the missing attributes manually. The strength of `retrieve()` is that it can read and return formatted objects with common attributes for post-processing, visualising and making outputs comparable (e.g. re-gridding the field objects into the same grid resolution). Basically, all reanalysis, general circulation models (GCMs), and regional climate models (RCMs) can be read using the ‘esd’ tool and further combined into one object, or analysed, albeit with some limitations due to the size of
the returned object.

### Function `station`
The package ‘esd’ includes the function ‘station’ for obtaining historical climate data by querying various web portals, for instance, the MET Norway archive (KDVH) provided by the Norwegian Meteorological Institute14. Data from MET climate web service ‘eKlima’ needs to be adapted manually, the Global Historical Climate Network (GHCN, (Peterson and Vose,1997)) provided by the American National Climatic Data Center15, and the European Climate
Assessment and Dataset (ECA&D, (Klein Tank et al., 2002)) made available by the Royal Netherlands Meteorological Institute (KNMI) (http://eca.knmi.nl/). Some of the data that is 14http://eklima.met.no; however, this function only works within the firewall included in the package has been pre-formatted within the ‘clim.pact’ package and adapted to meet the new ‘esd’ data format requirements.

15http://www1.ncdc.noaa.gov/pub/

SOURCE(S) :  ECAD/GHCNM/METNOD/METNOM/NACD/NORDKLIM
T2M/
14632
2014 / 1773
ESD package − map.station() − MET Norway 2014 (www.met.no)
Figure 1: Map of available weather stations recording temperature that are included in the meta-data
of the ‘esd’ package.

### Quick search - Function ‘select.station’
The sample data includes also a meta-data object (`stationmeta`) that can be loaded directly and contains meta data such as name of the `loc`*ation and its `id`*entification number, geographical coordinates such as `lon`*gitude, `lat`*itude, and `alt`*itude), `country` name, `param`*eter name of recorded weather variables (e.g. temperature and precipitation), data source (`src`) or provider for almost 100000 stations all over the world (Figures 1 and 2).
These meta-data have been imported from existing meta data from the different data source providers. It has to be noted also that most of the available stations are managed by the World Meteorological Organisation (WMO) and made available by the American National Climate Data Centre (NCDC) for scientific research only. The meta data has been merged from the different sources mentioned earlier. Also, other additional data sources can be easily included into the package.

SOURCE(S) :  ECAD/GHCND/METNOD/METNOM/NACD/NORDKLIM
PRECIP/
97202
2014 / 1854
ESD package − map.station() − MET Norway 2014 (www.met.no)
Figure 2: Map of available weather stations recording precipitation that are included in the meta-data
of the ‘esd’ package.

There are two ways of obtaining station data using `station()` method. The first option, which we recommend, is to select a subset of stations from the meta data using the function `select.station()` from a set of criteria. Among these criteria, the minimum length of the recorded data (‘nmin’) can be specified to get, for instance, a subset of stations recording for at least a minimum number of (e.g. 100) years of data (e.g. `select.station(nmin=100)`). Thus, a subsample of the meta data is returned and can be checked for duplications of stations from the various sources. Afterwards, users can start downloading the data for the selected stations. It has to be mentioned that the downloading process for the GHCN and ECA&D is different as the data is stored differently. For the GHCN data sets, each station is stored separately and a direct retrieval can be made. We highly recommend that users perform a prior selection of stations for the GHCN data sets before starting the downloading process. For the ECA&D data sets on the other hand, all stations are downloaded and stored locally as zip files at first call, after which data is extracted for the selection of stations. Other data sets, such as the NACD (Frich et al., 1996), NARP (Førland ), and Nordklim (Tuomenvirta et al., 2001) are stored entirely in ‘esd’ (only holds monthly values of a limited set).

The ‘station’ method can retrieve station data from a range of different sources, many over the web (GHCN and ECA&D). Example 2.1 demonstrates how to select, retrieve and plot temperature observations from a single station. The ‘esd’ tool holds meta-data for various data sources, which makes it quick and easy to
search for weather data recorded at stations according to the parameter, the geographical location (region, country, and coordinates (single or a range of longitude and latitude values) and altitude, and time interval.

## Data structures
Most data objects handled by ‘esd’ are typically time series, and hence based on the `zoo` class. The `zoo` class extends the tseries class from regular to irregular time series. In the ‘esd’ tool, additional categories or classes have been defined dealing with temporal resolution distinguishing daily (‘day’), monthly (`month`), seasonal (`season`), and annual (`annual`) data (as temporal classes) and spatial resolution distinguishing location (`station`) and field 
(`field`) classes.
Data on sub-daily scales may be represented in the ‘day’ class but the ‘esd’ tool has not been tested yet for this time scale. The way R handles different classes and objects can sometimes be confusing. The first element in a list of different classes is used to identify the appropriate method to be used for that specific object. For instance, if a data object belongs to the classes (‘field’,‘zoo’), then, appropriate methods for ‘field’ objects are used rather than those for
the ’zoo’ objects. Different types of data objects are processed and handled differently, and the way ‘esd’ keeps track of the different types is through the so-called ‘S3-method’ and classes. The ‘esd’ tool follows the same R programming functionalities and uses the first element of the class of an object to define the appropriate method to be used. The built-in R functions `class` and `inherits` are used to check whether an object inherits from any of the classes specified in the ‘esd’ package. 

Example 2.2 shows some of the classes used in ‘esd’.

The different data objects come bundled with relevant meta-data, stored as data attributes. These are shown using the `str`*ucture function, as displayed in Example 2.3 for a station object.
The various attributes have different functions, e.g. for handling the data, traceability, identification, and visualisation. The idea is that they are based on a standard terminology for which the terms are commonly agreed on and follow standard definitions. A common core set of attributes will make it easier to share data and methods. The attribute `history` contains the call(s) (`call`), time stamp(s), and session info that have been used to create and process the data itself.

## Function `summary()`
The S3 method ‘summary’ has been extended to the classes defined in ‘esd’ in order to
provide more tailor-made information. Example 2.4 shows summary statistics for each calendar
month of a daily station object.

Example 2.1.
# Select a station across India recording daily maximum temperature
# from the global historical climate network-daily
ss <- select.station(cntr=’India’,param=’tmax’,src=’ghcnd’)
ss.new <- subset(ss,subset=!duplicated(ss$location))
map(ss.new,cex=1.2,col="red",bg="pink",add.text=TRUE)
ss <- select.station(stid=’IN022021900’,cntr=’india’,param=’tmax’)
y <- station(ss)
#>[1] "Retrieving data ..."
#>[1] "1 TMAX IN022021900 NEW DELHI/S INDIA GHCND"
# Display the name of the location
loc(y)
# Highlights the location on the map
points(lon(y),lat(y),pch=19,col="blue",cex=2)
# aggregate daily values to annual values
ya <- annual(y,FUN=’mean’,nmin=100)
# Subset for the period 1970 to 2012
ya <- subset(ya,it=c(1970,2012))
# plot the time series including the error bar
plot(ya,ylim=c(29.5,32.5))
# Add the linear trend as
lines(trend(ya),col="red",lwd=2)
a)
b)
Maximum temperature
SRI
JAM
32.5
BIL
SHI
CHA
AMB
PAT
DEH
GAN
HIS
NEW
BAR
BIK
KHE
BAH
32.0
MAI
NORDIB
JAI
JAI
DHO
LUC
GOR
SIL
TEZ
JOD
GWA
GAU
BAR
PAT
VAR
KO
K T
O
BHA MAL
UDA
UDA
GUN
GAY
JHA
SAT
IMP
DAL
DUM
AGA
31.5
BHO
UMA
RAN
BHU
M.O
PAN
AHM
JAB
IND
PEN
JAM
CAL
RAJ
BAR
PAC
MID
KHA
BET
JHA
BAL
SUR
RAI
VER
NAG
AKO
SAN
NAS
BHU
A JAL
UR
°C
31.0
BOM
JAG
GOP
RAM
POO
KAL
SHO
VIS
RAT SAN
KAK
KOL
VIJ
MAC
BEL
VEN
KUR
GOA
GAD
30.5
PBO
NEL
HON
CHI
MAN
BAN
VELMAD
CUD
KAL
SAL
POR
KOZ
30.0
M.O
COI
TIR KAR
FOR
MAD
THI
29.5
1980
1990
2000
2010
NEW DELHI/S: 77.2E/28.58N (216 masl)
Figure 3: Map showing available stations across India from the GHCN-D dataset and b) a plot of
the annual maximum temperature recorded at New Delhi weather station (blue point) including
linear trend line.

Example 2.2.
# Example of monthly station data:
> data(Oslo)
> class(Oslo)
[1] "station" "month"
"zoo"
# Example of daily station data:
> data(ferder)
> class(ferder)
[1] "station" "day"
"zoo"
# Example of annual station data:
> class(annual(ferder))
[1] "station" "annual"
"zoo"
# Example of a field object
> t2m <- t2m.NCEP(lon=c(-30,30),lat=c(40,70))
> class(t2m)
[1] "field" "month" "zoo"
> class(EOF(t2m))
[1] "eof"
"field" "month" "zoo"
Example 2.3. # Load the data for Ferder weather station
data(ferder)
# Display the structure of the data as
> str(ferder)
’zoo’ series from 1900-01-01 to 2013-12-04
Data: atomic [1:41611] 2.1 -1.8 -0.9 -3 -7.2 -6.5 -2.6 -2.4 -1.6 -0.3 ...
- attr(*, "location")= chr "Ferder lighthouse"
- attr(*, "station_id")= num 27500
- attr(*, "wmo_id")= num 1482
- attr(*, "longitude")= num 10.5
- attr(*, "latitude")= num 59
- attr(*, "altitude")= num 6
- attr(*, "variable")= chr "t2m"
- attr(*, "unit")= chr "deg C"
- attr(*, "country")= chr "Norway"
- attr(*, "source")= chr "MET Norway eklima"
- attr(*, "long name")= chr "daily mean temperature"
- attr(*, "URL")= chr "http://eKlima.met.no"
- attr(*, "calendar")= chr "gregorian"
- attr(*, "quality")= logi NA
- attr(*, "aspect")= chr "original"
- attr(*, "type")= chr "observation"
- attr(*, "reference")= chr "MET Norway climate archive"
- attr(*, "info")= logi NA
- attr(*, "method")= chr "mean estimated from thermometer measurements"
- attr(*, "history")=List of 3
..$ call
: chr "1 0"
..$ timestamp
: chr "Fri Dec 13 15:51:49 2013"
..$ sessioninfo:List of 3
.. ..$ R.version
: chr "R version 3.0.2 (2013-09-25)"
.. ..$ esd.version: chr "esd_0.2-1"
.. ..$ platform
: chr "x86_64-pc-linux-gnu (64-bit)"
Index:
Date[1:41611], format: "1900-01-01" "1900-01-02" "1900-01-03" "1900-01-04" ...
11
Example 2.4.
## Load data for Ferder
> data(ferder)
## Display the summary of statistics
> summary(ferder)
Min. 1st Qu. Median
Mean 3rd Qu. Max. NA’s
Jan -21.2
-3.100
0.0 -0.3226
2.900
9.0
13
Feb -17.1
-3.400
-0.6 -0.9718
2.000
7.7
25
Mar -12.9
-0.700
1.2
0.9619
3.025 11.7
14
Apr
-6.0
3.200
4.8
4.8250
6.400 13.8
NA
May
1.0
8.100
10.0 10.1000
12.000 20.3
NA
Jun
6.3
12.800
14.2 14.5200
16.100 24.2
NA
Jul
10.6
15.500
16.9 17.0500
18.400 24.9
NA
Aug
10.0
15.100
16.3 16.5600
17.800 24.8
2
Sep
3.6
11.900
13.4 13.2700
14.800 20.7
NA
Oct
-1.3
7.000
9.4
8.9340
11.100 15.4
8
Nov
-7.3
2.375
4.8
4.5730
7.200 16.3
24
Dec -15.6
-1.200
1.9
1.5340
4.700
9.7
29
12
Table 1: Data objects in ‘esd’ are determined by a set of classes, listed in this table. This may
be extended in the future to include radiosonde and radar data objects.
‘station’
Class defining station objects. Can be single or multiple stations with daily,
monthly, seasonal or annual temporal resolution.
‘spell’
Looks similar to the station class, but the events are irregularly spaced and
contains both duration of wet/hot as dry/cold spells. The distinction also
enables ‘esd’ to apply different plotting and analysis methods than those for
regular stations.
‘field’
Currently represents time series of 2D variables, but may in principle contain
any number of spatial dimensions.
‘eof’
Class defining an EOF describing the spatial patterns (EOFs), the temporal
variations (PCs), and the eigenvalues.
‘pca’
Class defining a PCA is similar to the eof class, but allows for irregular grid
of stations.
‘cca’
Class that defines the results of a CCA, containing a pair of patterns and the
canonical correlations.
‘ds’
Class for DS results.
‘dsensemble’
Class for downscaled ensembles.
‘diagnose’
Class for diagnostic results.
‘trajectory’
Class for trajectories.
‘xval’
Class for cross-validation.
‘xsection’
Class for cross-sections (Hovmuller diagrams).
‘mvr’
Class for multivariate regression (MVR) objects, which hold the matrices that
maps one data set onto the data space of another.

## Data visualisation
The main data visualisation is provided through plot and map methods, but there are other more specific methods for producing additional graphs.
### Function ‘plot’ 
The ‘plot’ method in ‘esd’ extends the S3 plot methods from package ‘graphics’ to new ‘esd’ classes (Table 1). ‘plot(x)’ and ‘plot.station(x)’ are equivalent if ‘x’ is an object of class ‘station’.
Various plotting outputs are generated depending on the class of the objects used as inputs. For instance, the ‘plot.station(x)’ function produces a figure based on the default ‘graphics’ and ‘zoo’ plots but adapted for the station object (Figure 4a). For some classes, plot can produce several or a combination of plots giving more description of the output. The argument ’plot.type’ is also used to distinguish between single or multiple plots in one window. The ‘plot’ function also inherits all graphical parameters from ‘par’ with additional parameters used by ‘esd’. An example of the function ‘plot’ applied to a station object is shown in Example 2.5 and Figure 4a. Although the plot itself gets more complicated for EOFs, the syntax remains as simple as for the station object (Example 2.6, Figure 5).

### Function ‘map’
The function ‘map’ is also an S3 built method and used to produce a map of geographical and geophysical data points and gridded data. ‘map’ can be seen as a spatial plotting method, while plot is mainly used for time series. Unlike ‘plot’, ‘map’ is proper to ‘esd’ and is an S3 method and do not extend the existing ‘map’ function from package ‘maps’ (http://CRAN.R-project.org/package=maps), which too works for the different ‘esd’ objects. When applied to one single station, map plots its location (Example 2.5, Figure 4b).

### Function ‘vec’
The function vec plots vectors of a 2D flow field (Example 2.7, Figure 6).

Example 2.5.
# Load bjornholt data set
data(bjornholt)
# plot the time series
plot(bjornholt)
# map the location
map(bjornholt)
a)
b)
precipitation
100
80
)yad 60
m
Bjornholt
(m
p
ci
e
40
pr
20
0
1900
1950
2000
Bjornholt: 10.7E/60.1N (360 masl)
Figure 4: Example of a station (a) and a map plot (b) for a single station ‘Bjornholt’.
15
Example 2.6.
#Get NCEP 2m air temperature for the selected spatial window defined by lon and lat
t2m <- t2m.NCEP(lon=c(-30,30),lat=c(40,70))
# Computes the EOFs
X <- EOF(t2m)
# Plot the result
plot(X)
surface air temperature 20 leading EOFs:  100 % of variance
T
(°
2m
C)
100
80
60
40
20
0
NCEP Reanalysis
surface air temperature 1 leading EOFs:  95.4 % of variance
0.06
0.04
0.02
0.00
−0.02
−0.04
−0.06
1950
1960
1970
1980
1990
2000
2010
NCEP Reanalysis t2m
Figure 5: An example of a plot results for an EOF object.
16
Example 2.7.
# Load 10m zonal and meridional wind components
u10 <- retrieve(’data/ERAINT/eraint_elnino.nc’,param=’u10’)
v10 <- retrieve(’data/ERAINT/eraint_elnino.nc’,param=’v10’)
# Map the data
map(u10,colorbar=FALSE)
# Display the vectors
vec(u10,v10,new=FALSE,a=2,length=0.05)
u10(m s)
[1979 1, 2014 6]
mean
Figure 6: The output of the example with ‘vec’. In this example, there are different plotting
windows for the vectors and the underlying map, but this can be adjusted in the arguments of
‘vec’.

### Info-graphics
One of the purposes of ‘esd’ is to easily produce visualisation and graphics to bring out new aspects of the information embedded in the data. The development of the info-graphics in this tool has also been inspired by Spiegelhalter et al. (2011), in order to distill the essence of the
analysis. 
The information stored in climate data can be extracted in various ways, with emphasis on different aspects, as can be seen in Example 2.8 and Figure 7. A ‘cumugram’ is shown, displaying the cumulative average value of some variable starting from the first day of the year. The results for the Oslo temperature in this example shows that 2014 has been the warmest year on record since the summer. A ‘rainbow structure’ is consistent with a gradual increase in the temperature.
The second diagram, ‘wheel’, emphasises the time of the year when the most extreme events have taken place, and ‘climvar’ to the right shows how the year-to-year variance varies with season with a minimum in late summer. The ‘diagram’ method can also be used to view the data by comparing day-by-day values of the present temperature with those of the previous years. The figure shows that there have been some exceptionally mild autumn temperatures in 2014. Other functions for making info-graphics include ‘vis’, which make alternative graphics output displaying different information. Trends can be estimated by linear regression using the simple ‘trend’ function. An alternative trend analysis can be done using the function ‘vis.trends’ which estimates linear regressions for sliding periods of various lengths (Example 2.9, Figure 8). The results are presented visually with the strength of the trends shown as a colour scale on a grid where the x- and y-axes represent the starting point and the length of each period, respectively. Periods with statistically significant trends are marked with black outlines. The advantage of ‘vis.trends’ is that it shows trends of various time scales, considering all variations of start- and end-points. The longest period is found in the upper left corner, representing the full length of the time series. The most recent period is shown in the bottom right corner. As demonstrated in Example 2.9,
the strength and significance of estimated trends are sensitive to the period considered. The multiple period trend analysis is therefore a more robust alternative to single period trend fitting.
18


Example 2.8.
# Get 2m temperature data for Oslo
# (works within MET Norway firewall only)
x
<- station(stid=18700,param=’t2m’,src=’metnod’)
x <- subset(x,it=c(1837,2014))
## Or gets data from ECA&D as
## x
<- station(loc="Oslo Blindern",param=’t2m’,src=’ecad’)
## x <- subset(x,is=duplicated(loc(x))) # to remove duplicated stations
# Cumulative average
cumugram(x)
# Seasonal wheel
wheel(x)
# seasonal variations of year-to-year variance
climvar(x)
# daily seasonal cycle for all years
diagram(x)
Seasonal ’wheel’ for OSLO − BLINDERN
January
Apr
il
September
2000
July
1980
ears
y
1960
1940
a)
b)
t2m
seasonal  sd  of t2m
raw data
harmonic fit
6
5
°C
4
3
2
0
100
200
300
c)
OSLO − BLINDERN
d)
Figure 7: Examples of ‘cumugram’, ‘wheel’, ‘climvar’, and ‘diagram’ plots. The ‘cumugram’ shows
how the mean value of some variable has evolved from the start of the year and compares this curve
to previous years. The graphics produced by ‘wheel’, on the other hand, emphasises how the seasonal
variations affect the variable, e.g. whether some extremes tend to be associated with a specific season.
Panel c shows results produced by ‘climvar’ shows the year-to-year statistics for a variable, e.g. the
standard deviation of the temperature on February 1st. The ‘diagram’ method can be used in different
context, and for a ‘station’ object, it produces graphics that compare the day-to-day values with those
of previous years.
19

Example 2.9.
# Get 2m temperature data for Ferder and calculate annual mean
data(ferder)
x <- annual(ferder)
# Plot the time series and add a trend line
plot(x,ylim=c(4,11))
lines(trend(x),col="red",lwd=2)
# Visualise trends for various periods 40 years or longer (minlen)
# and mark trends that are significant at the 1% level (pmax)
vis.trends(x,minlen=40,pmax=0.01)
t2m trend (deg C/decade)
110
0.4
significant trend (p<0.01)
0.2
103
0.0
96
−0.2
89
−0.4
ears)
82
iod (y
75
68
length of per
61
54
47
40
1900
1910
1917
1924
1931
1938
1945
1952
1959
1966
start year
Figure 8: Visualising the trend in the temperature time series from Ferder for the full period
(left panel) and simultaneously for different periods of various length (right panel). The trend
analysis indicates a significant increase in temperature at Ferder since the 1900s, but also shows
that the strength and significance of the trend is sensitive to the period considered because the
increase is not monotone.
20
