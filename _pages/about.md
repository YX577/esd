---
layout: default
title: Empirical-Statistical Downscaling
nav_order: 2 
permalink: /about/
---

# Introduction
{: .no_toc}

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

## The need for climate information
A call for climate services and other initiatives and programmes to provide climate informa-
tion to stake holders and the general public has been made over the recent decades (e.g. the
WMO global framework for climate services (GFCS), the CORDEX program, and the Joint
Programming Initiative (JPI-Climate)). The urgency of their mission has been emphasised by
recent extreme weather events and the publication of a number of climate research reports (e.g.
Hov et al. (2013); Field et al. (2012); Stocker et al. (2013)).
The development of efficient and versatile tools for climate analysis are essential to this effort.
For instance, there is always a need for extracting relevant climate information, reading data,
and testing and visualising the results. The present ‘esd’ tool has been developed to meet these
requirements.
The ‘esd’ tool is being used in different projects such as FP7 SPECS and CLIPC1, COST-
VALUE2, INDICE3, CixPAG4, MIST-II 5, CLIMATRANS6, and EU-CIRCLE 7 to establish
networks and standards for assessment and validation of model results needed for climate ser-
vices.

## Motivation
Open, efficient, flexible, and intuitive tools making use of state-of-the-art statistical know-how
have long been needed for the purpose of climate analysis. Often the lack of resources (man
power) dedicated to such work limits the possibilities of offering tailor-made user-relevant infor-
mation. There is a wide range of requirements, from climate data handling and analysis, and
validation/diagnostics to bias adjustment of model results and downscaling (including predic-
tion and projection). Even if the main purpose may be just to carry out empirical-statistical
downscaling (ESD; Benestad et al. (2008)), many other tasks are necessary to prepare the anal-
ysis and understand the results. The need to analyse multi-model ensembles rather than single
model (Benestad , 2011) also makes additional demands on the tools. In other words, ‘esd’ is
a tools for ’Big data’ climate analysis.
1CLIPC will provide access to climate information of direct relevance to a wide variety of users, from scientists
to policy makers and private sector decision makers.
2The COST Action VALUE (2012-2015) aims at providing a European network to develop downscaling meth-
ods, validate them, and improve the collaboration between the research communities and stakeholders.
3INDICE is a collaboration between Norway and India that studies the hydrological consequences of climate
change on the Hindu-Kush region in Himalaya
4CiXPAG project aims at investigating the complex interactions between climate extremes, air pollution and
agricultural ecosystems.

This project aims at providing reliable projections to be used by STATKRAFT as a leading company in
hydro-power internationally and Europe’s largest generator of renewable energy.
6CLIMATRANS project aims at investigating the complex interactions between climate extremes, air pollution
and transportation in Indian mega-cities.
7EU-CIRCLE project aims at developing a Climate Infrastructure Resilience Platform (CIRP) as an end-to-end
modelling environment.

An important aspect of any climate analysis tool is data input-output (I/O) and handling data.
Although model results are meant to be provided in a standard format (e.g. the Coupled Model
Inter-comparison Project8 - CMIP - following the ‘Climate and Forecast’ (CF) convention),
experience shows that there are often differences that can cause problems. For instance, the
CMIP5 ensemble of models involves 4 different types of calendars.
Data files are often organised in accordance with some kind of Common Information Model9
(CIM) or a Data Reference Syntax10 (DRS), but there is also a benefit in standard structures in
the working computer memory when using programming environments such as R. A well-defined
and standardised data structure makes it possible to create a generic climate analysis tool.
Searching for available and complete observational data sets is always a difficult and time
consuming task without prior knowledge about the quality of the retrieved data sets. In the
context of empirical-statistical downscaling, observations are needed both for validation of model
results and for calibrating models. Furthermore, there may be a need to aggregate annual mean
values rather than daily or monthly, and to extract subsets, for instance a given calendar month,
a limited interval, or a smaller spatial region.
The purpose of the ‘esd’ package is to offer an R-package that covers as many as possible of
these requirements, from acquiring data and converting to a standardised format, to performing
various statistical analyses, including statistical downscaling, all in a simple and user-friendly
way.

## History
Most of the previous work on ESD carried out at MET Norway has been based on the R-
package ‘clim.pact’ (Benestad et al., 2008) from the early 2000s. This tool had evolved into
a large set of methods and functions over time, but without a ‘strict discipline’. Hence, the
functions would use a range of different set-ups and lacked a streamlined finish. Therefore, it
was not very user friendly. The idea is that any climate data analysis should be quick, easy, and
efficient, with a bare minimum effort going into coding and reformatting of data sets. It should
be intuitive and easy to remember how to perform the analysis. This way, more of the time can
be devoted to do the analysis itself and writing reports, rather than rewriting code, debugging,
testing, and verifying the process. While much of the methods needed in climate analysis were
included in ‘clim.pact’, it was evident that the most efficient solution was to create a new
R-package from scratch with a more purposeful and well-defined data structure. Much of the
methods, however, are based on functions in ‘clim.pact’, although the benefit of experience
from developing that package has been utilised from the start of the creation of ‘esd’.
8http://cmip-pcmdi.llnl.gov/
9https://www.earthsystemcog.org/projects/downscalingmetadata/
10http://cmip-pcmdi.llnl.gov/cmip5/output_req.html

Since it is creation, the ‘clim.pact’ package has been widely used by the climate community
for research purposes and has been a valuable asset for assessment studies (Winkler et al.,
2011). For instance, Spak et al. (2007) compared statistical and dynamical downscaling of
surface temperature in North America using results obtained from the ‘clim.pact’ tool, and
Girma et al. (2010) used the ‘clim.pact’ tool to downscale rainfall in the upper Blue Nile
basin for hydrological modelling.
The R-package was used by Sch¨
oner and Cardoso (2005) to downscale air temperature mean
and precipitation sums from regional model as well as directly from ERA-40 fields, and Tyler
et al. (2007) used it to produce temperature scenarios by downscaling output from 17 different
global climate. However, Estrada et al. (2013) pointed out that ‘clim.pact’ and similar tools
do not provide the necessary tests to ensure the statistical adequacy of the model and therefore
misleading results could be expected. We will address some of the issues that Estrada et al. (2013)
highlighted later on.

## The new tool: ‘esd’
The new tool ‘esd’, like its predecessor ‘clim.pact’, is based on a ‘plug-and-play Lego
principle’, where data are seen as an object that is used as input and new results are returned
as output following a standard data structure. This means that different functionalities can
be combined where the output from one process is used as input to the next. In ‘esd’ the
data structure has changed from that in ‘clim.pact’, and uses more attributes and less list
objects. Furthermore, the data objects build on the time series object ‘zoo’, which takes care
of much of the chronology. A consequence of using ‘zoo’ as a basis also is that it implies
adopting S3-methods, which also makes the tool more flexible and user-friendly. Through the S3-
methods, new plotting methods have been made available for station and field objects, empirical
orthogonal functions (EOFs), and other types. The use of S3-methods implies the definition of
new classes describing the data types. It can also make the tool work more seamlessly with
other R-packages and other structures if appropriate conversion tools are made.
The development of the ‘esd’ software fits in with the trend of the R-language’s increasing
role in the climate change debate (Pocernich, 2003) and as an open science platform (Pebesma
et al., 2012). Furthermore, both R and the ‘esd’ R-package are valuable tools for linking
high education and research (IBARRA-BERASTEGI et al.). The ‘esd’-package has already
been used as material for capacity building in connection with the bilateral INDICE project
between Norway and India (http://www.nve.no/en/Projects/INDICE/), and the CHASE-PL
project between Norway and Poland
(http://www.isrl.poznan.pl/chase/index.php/project/).
The wide range of functionalities included in the ‘esd’ tool makes it suitable for process-
ing results from global and regional models. The tool also includes methods for plotting and
generating various info-graphics: time series, maps, and visualisation of complex information.

The data processing aspects include re-gridding, sub-setting, transformations, computing em-
pirical orthogonal functions (EOFs) and principal component analysis (PCA) for stations and
gridded data on (ir)regular grids, regression, empirical-statistical downscaling, canonical correla-
tion analysis (CCA) and multi-variate regression (MVR). The tool also offers several diagnostic
methods for quality assessment of the data and downscaled results. The ‘esd’ methods can be
tailored to meet with specific user needs and requirements.
As the library was built for the R computing environment (R Core Team, 2014), it inherits
from the large number of R built-in functions and procedures. It also includes an additional
set of predefined objects and classes, sample and structured data and meta-data, and uses the
S3-methods to ensure that information is appropriately maintained. Finally, the ‘esd’ library
has been built with the emphasis of traceability, compatibility, and transparency of the data,
methods, procedures, and results, and is made freely available for use by the climate community
and can be installed from the MET Norway Github account (https://github.com/metno/esd)
or Figshare (http://dx.doi.org/10.6084/m9.figshare.1160493).
The remainder of this report describes technical issues related to the ‘esd’ tool. A listing of
the syntax and examples are also included in this report.
