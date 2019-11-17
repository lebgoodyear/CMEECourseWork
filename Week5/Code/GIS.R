##############################################################
##################### Using GIS data in R ####################
##############################################################

# Creates maps from GIS data using different methods

# clear workspace
rm(ls=(list))
graphics.off()

# load packages
library(raster) # core raster GIS data package
library(sf) # core vector GIS data package
library(viridis) # colour scheme
library(units) # automatically converts units
library(rgeos) # extends vector data functionality
library(lwgeom) # extends vector data functionality


########################### VECTORS ##################################


# create population density map for British Isles
# first create data frame with population densities
pop_dens <- data.frame(n_km2 = c(260, 67, 151, 4500, 133),
                       country = c('England', 'Scotland', 'Wales', 
                                   'London', 'Northern Ireland'))
print(pop_dens)

# create coordinates for each country
# this is a list of sets of coordinates forming the edge of the polygon
# note that they have to *close* (have the same coordinates at either end)
scotland <- rbind(c(-5, 58.6), # rbind creates matrix by combining vectors as rows
                  c(-3, 58.6), 
                  c(-4, 57.6),
                  c(-1.5, 57.6), 
                  c(-2, 55.8), 
                  c(-3, 55), 
                  c(-5, 55), 
                  c(-6, 56), 
                  c(-5, 58.6))

england <- rbind(c(-2,55.8),
                 c(0.5, 52.8), 
                 c(1.6, 52.8), 
                 c(0.7, 50.7), 
                 c(-5.7,50), 
                 c(-2.7, 51.5),
                 c(-3, 53.4),
                 c(-3, 55), 
                 c(-2,55.8))

wales <- rbind(c(-2.5, 51.3),
               c(-5.3,51.8), 
               c(-4.5, 53.4),
               c(-2.8, 53.4),  
               c(-2.5, 51.3))

ireland <- rbind(c(-10,51.5), 
                 c(-10, 54.2), 
                 c(-7.5, 55.3),
                 c(-5.9, 55.3), 
                 c(-5.9, 52.2), 
                 c(-10,51.5))

# convert these coordinates into feature geometries
# these are simple coordinate sets with no projection information
# the command 'st' creates a simple feature from a numeric vector, matrix or list
scotland <- st_polygon(list(scotland))
england <- st_polygon(list(england))
wales <- st_polygon(list(wales))
ireland <- st_polygon(list(ireland))

# combine geometries into a simple feature column
# crs retrieves, sets or replaces a coordinate reference system
# crs = 4326 is a shortcut for the WGS84 gepgraphic coordinate system
# it is a unique numeric code in the EPSG database of spatial coordinate systems
# and acts as a shortcut for the often complicated sets of parameters and 
# transformations associated with a particular projection (these sets are called proj4 strings)
uk_eire <- st_sfc(wales, england, scotland, ireland, crs = 4326)
plot(uk_eire, asp = 1)

# create point locations for capital cities
uk_eire_capitals <- data.frame(long = c(-0.1, -3.2, -3.2, -6.0, -6.25),
                               lat = c(51.5, 51.5, 55.8, 54.6, 53.50),
                               name = c('London', 'Cardiff', 'Edinburgh', 'Belfast', 'Dublin'))
# st_as_sf converts a foreign object to a sf object,
# where an sf object is a simple feature collection (dataframe-like and contains simple feature list columns)
uk_eire_capitals <- st_as_sf(uk_eire_capitals, coords=c('long', 'lat'), crs = 4326)

# use a buffer operation to create a polygon for London
# (defined as anywhere within a quarter of a degree from St Pauls Cathedral)
# since units of geographic coordinate systems are angles of longitude and latitude, not
# constant units of distance, this is a daft thing to do because the physical length of a degree (longitude) 
# decreases nearer the poles so the data will be distorted
st_pauls <- st_point(x = c(-0.098056, 51.513611))
london <- st_buffer(st_pauls, 0.25)

# use difference operation to remove London from England polygon so we can set
# different population densities
# note here the order is important
england_no_london <- st_difference(england, london)

# count the points and show the number of rings within the polygon features
lengths(scotland)
lengths(england_no_london)

# correct England-Wales border
wales <- st_difference(wales, england)

# use intersection operation to spearate Northern Ireland and Ireland
# a rough polygon that includes Northern Ireland and surrounding sea
# note the alternative way of providing coordinates
ni_area <- st_polygon(list(cbind(x=c(-8.1, -6, -5, -6, -8.1), y=c(54.4, 56, 55, 54, 54.4))))

northern_ireland <- st_intersection(ireland, ni_area)
eire <- st_difference(ireland, ni_area)

# combine the final geometries into simple feature column
uk_eire <- st_sfc(wales, england_no_london, scotland, london, northern_ireland, eire, crs = 4326)
plot(uk_eire, asp = 1)
plot(uk_eire_capitals, add=T)

# make UK into a single feature
uk_country <- st_union(uk_eire[-6]) # list index 6 is Eire, which we are removing
# compare six polygon features with one multipolygon feature with commands:
print(uk_eire)
print(uk_country)

# plot on the same plotting matrix
# par uses graphical commands to set the global state of a plotting matrix
par(mfrow=c(1,2), # create a 1 by 2 plotting matrix to be filled by row
    mar=c(3,3,1,1)) # specifies number of lines of margin on all 4 sides of plot
plot(uk_eire, asp = 1, col = rainbow(6))
plot(st_geometry(uk_eire_capitals), add=T)
plot(uk_country, asp = 1, col = 'lightblue')

# use sf object type: add a simple feature column
uk_eire <- st_sf(name=c('Wales', 'England','Scotland', 'London', 
                        'Northern Ireland', 'Eire'),
                 geometry = uk_eire)
plot(uk_eire, asp = 1)

# since an sf object is an extended dataframe, we can add attributes by adding fields directly
uk_eire$capital <- c('London', 'Edinburgh', 'Cardiff', NA, 'Belfast', 'Dublin')

# use merge to combine dataframes, using by.x and by.y to indicate which columns to match
uk_eire <- merge(uk_eire, pop_dens, by.x='name', by.y='country', all.x=TRUE)
# all.x = TRUE or Eire will be dropped since we have no pop dens data for it
print(uk_eire)

# we can also find spatial attributes of geometries
# e.g. find out the centroids of features
# note sf package warnings because there is actually not a good way to calculate
# a true centroid for geographic coordinates
uk_eire_centroids <- st_centroid(uk_eire)
st_coordinates(uk_eire_centroids)

# we can also find the length and area of a feature
# note that sf package gives us back accurate distances and areas using metres, not degrees
# this is because it notes that we have specified geographic coordinate system
uk_eire$area <- st_area(uk_eire)

# the length of a polygon is the perimeter length
# note that this includes the length of internal holes
uk_eire$length <- st_length(uk_eire)
print(uk_eire)

# note sf package often creates data with explicit units, using the units package
# but you can change units "manually"
uk_eire$area <- set_units(uk_eire$area, 'km^2')
uk_eire$length <- set_units(uk_eire$length, 'km')
# note that this won't let you make a silly error like turning a length into weight
# e.g. uk_eire$are <- set_units(uk_eire$area, 'kg')

# or you can simply convert the 'units' version to simple numbers
uk_eire$length <- as.numeric(uk_eire$length)
print(uk_eire)

# sf can also give the closest distance between geomtries
# note this might be zero if two features are touching
st_distance(uk_eire)
st_distance(uk_eire_centroids)
# again sf is noting that have a geographic coordinate system
# and internally calculating distances in metres

# the default for plotting an sf object is to plot a map for every attribute
# the column to be shown is picked using square brackets
# now show a map of population density
plot(uk_eire['n_km2'], asp = 1)

# note you can plot geometries without any labelling or colours by using the 
# st_geometry function to temporarily strip off attributes

# change the scale on the plot
# use can either use the 'logz' argument
plot(uk_eire['n_km2'], asp = 1, logz = TRUE)
# or log the actual data
uk_eire$log_n_km2 <- log10(uk_eire$n_km2)
plot(uk_eire['log_n_km2'], asp = 1)

# reproject UK and Eire map onto a local projected coordinate system
# we can do this using the shortcut codes in the EPSG database of spatial coordinate systems
# good choice: British National Grid
uk_eire_BNG <- st_transform(uk_eire, 27700)
# the bounding box of the data shows the change in units
st_bbox(uk_eire)
st_bbox(uk_eire_BNG)
# bad choice: UTM50N (local Borneo) projection
uk_eire_UTM50N <- st_transform(uk_eire, 32650)
# plot the results
par(mfrow = c(1, 3), mar = c(3, 3, 1, 1))
plot(st_geometry(uk_eire), asp = 1, axes = TRUE, main = 'WGS 84')
plot(st_geometry(uk_eire_BNG), axes = TRUE, main = 'OSGB 1936 / BNG')
plot(st_geometry(uk_eire_UTM50N), axes = TRUE, main = 'UTM 50N')

# fix St Pauls distortion issue
# first let's see the issue in numbers
# set up some points separated by 1 degree latitude and longitude from St Pauls
st_pauls <- st_sfc(st_pauls, crs = 4326)
one_deg_west_pt <- st_sfc(st_pauls - c(1, 0), crs = 4326) # near Goring
one_deg_north_pt <- st_sfc(st_pauls + c(0, 1), crs = 4326) # near Peterborough
# calculate distance between St Pauls and each point
st_distance(st_pauls, one_deg_west_pt)
st_distance(st_pauls, one_deg_north_pt)
# notes that the great circle distance (accounting for curvature of the earth) between London
# and Goring is about 17m longer than the distance between the same coordinates projected 
# onto the British National Grid (BNG)
st_distance(st_transform(st_pauls, 27700), # transforms coordinates of a simple feature
            st_transform(one_deg_west_pt, 27700))
# to fix the issues transform London to the BNG projection
london_BNG <- st_buffer(st_transform(st_pauls, 27700), 25000)
# simultaneously transform England and remove London
england_no_london_BNG <- st_difference(st_transform(st_sfc(england, crs = 4326), 27700), london_BNG)

# add this to a new, more accruate map
# first transform all other features to BNG projection
others_BNG <- st_transform(st_sfc(eire, northern_ireland, scotland, wales, crs = 4326), 27700)
# combine updated features
new_map <- c(others_BNG, london_BNG, england_no_london_BNG)
# plot new map
par(mar=c(3,3,1,1))
plot(new_map, main = '25km radius London', axes = T)


###################### RASTERS ################################


# Rasters are another major type of spatial data and consist of
# a regular grid in sapce, defined by a coordinate system, an origin
# point, a resolution and a number of rows and columns (effectively
# holding a matrix of data). A raster holds values in a regular grid.

# note the raster package doesn't support ESPG codes as number so
# they need to be formatted as a text string

# build a simple raster dataset from scratch by setting
# projection, bounds,resolution and finally associating data with it

# create an empty raster object covering UK and Eire
uk_raster_WGS84 <- raster(xmn = -11, 
                          xmx = 2, 
                          ymn = 49.5, 
                          ymx = 59,
                          res = 0.5,
                          crs = "+init=EPSG:4326")

# check whether raster object has associated values (answer is false)
hasValues(uk_raster_WGS84)

# add data to raster
# add sequential numbers from 1 to number of cells

values(uk_raster_WGS84) <- seq(length(uk_raster_WGS84))

# create a basic map of this with country borders overlaid

plot(uk_raster_WGS84)
plot(st_geometry(uk_eire),
     add = T,
     border = 'black', # colour of country borders
     lwd = 2, # line width of country borders
     col = '#FFFFFF44') # this colour code gives 
                        # a transparent grey fill for the polygon

### changing the resolution of a raster

# think about what the data is and what it means to aggregate or
# disaggregate the values
# exmaples of when to change resolution:
# - need different data sources to have same resolution for an analysis
# - the data is more detailed than you need or can analyse

# define a simple 4 x 4 square raster
m <- matrix(c(1, 1, 3, 3,
              1, 2, 4, 3,
              5, 5, 7, 8,
              6, 6, 7, 7),
            ncol = 4,
            byrow = T)

square <- raster(m)

## aggregating rasters

# choose aggregation factor (how many cells to group)
# e.g. factor of 2 will aggregate blocks of 2 x 2 cells

# then assign a value to these blocks, for example, the mean, maximum or mode
# note it is harder conceptually understand the assigning of values 
# to represent categories, e.g. Forest(2) or Moorland(3) - what would this actually mean?

# average values
square_agg_mean <- aggregate(square, fact = 2, fun = mean)
values(square_agg_mean)

# maximum values
square_agg_max <- aggregate(square, fact = 2, fun = max)
values(square_agg_max)

# modal values for categories
square_agg_modal <- aggregate(square, fact = 2, fun = modal)
values(square_agg_modal)
# note for cells with no mode, you can choose 'first' or 'last'
# to specify which value gets chosen but there is no actual mode

## disaggregating rasters
# the factor here is the square root of the number of cells to create from each existing cell
# assign a value to the blocks either by
# - copying parent cell value into each of the new cells
# - interpolate between values to provide a smoother gradient 
# (note interpolation does not make sense for cateogrical variables)

# disaggregate by copying parents values
square_disagg <- disaggregate(square, fact = 2)
# disaggregate by interpolation
square_disagg_interp <- disaggregate(square, fact = 2, method = 'bilinear')

# note origin or alignments are not changed at all when changing resolution
# to change these (e.g. if you need to match datasets with different origins and/or 
# alignments), use the more complex 'resample' function
# this is bascailly a simpler case of reprojecting a raster

### reprojecting a raster

# a series of raster cell values in one projection are represented by
# inserted representative values into a set of cells on a different projection

# note that we can use vector grids to represent two raster grids in order
# to overplot them

# make two simple feature columns containing points in the
# lower left and top right of the two grids
uk_pts_WGS84 <- st_sfc(st_point(c(-11, 49.5)),
                       st_point(c(2, 59)),
                       crs = 4326)
uk_pts_BNG <- st_sfc(st_point(c(-2e5, 0)),
                     st_point(c(7e5, 1e6)),
                     crs = 27700)

# use st_make_grid command to quickly create a polygon grid with the
# right cell size
uk_grid_WGS84 <- st_make_grid(uk_pts_WGS84, cellsize = 0.5)
uk_grid_BNG <- st_make_grid(uk_pts_BNG, cellsize = 1e5)

# reporject BNG grid into WGS84
uk_grid_BNG_as_WGS84 <- st_transform(uk_grid_BNG, 4326)

# plot the features
plot(uk_grid_WGS84, 
     asp = 1, 
     border = 'grey',
     xlim = c(-13, 4))
plot(st_geometry(uk_eire), 
     add=T,
     border = 'darkgreen',
     lwd = 2)
plot(uk_grid_BNG_as_WGS84,
     border = 'red',
     add = T)

# use the projectRaster function to either interpolate a representative
# value from the source data (bilinear method) or pick the cell value 
# from the nearest neighbour to the cell centre (ngb method)

# first create target raster to use as a template for the projected data
uk_raster_BNG <- raster(xmn = -200000, xmx = 700000,
                        ymn = 0, ymx = 1000000,
                        res = 100000,
                        crs = '+init=EPSG:27700')
uk_raster_BNG_interp <- projectRaster(uk_raster_WGS84, 
                                      uk_raster_BNG, 
                                      method = 'bilinear')
uk_raster_BNG_ngb <- projectRaster(uk_raster_WGS84,
                                   uk_raster_BNG,
                                   method = 'ngb')
# compare values in the top row
round(values(uk_raster_BNG_interp)[1:9], 2)
values(uk_raster_BNG_ngb)[1:9]
# note that NA values are due to the centres of cells on the top grid
# that do not overlie the original grid

# plot the two outputs from the two different projectRaster methods to see 
# the more abrupt changes when using the nearest neighbour projection
par(mfrow=c(1,3), mar=c(1,1,2,1))
plot(uk_raster_BNG_interp, 
     main='Interpolated', 
     axes=FALSE, 
     legend=FALSE)
plot(uk_raster_BNG_ngb, 
     main='Nearest Neighbour',
     axes=FALSE, 
     legend=FALSE)


########## CONVERTING BETWEEN VECTOR AND RASTA DATA TYPES ###########

## Vector to raster

# provide the target raster and the vector data and put it through
# the 'rasterize' function

# note that vector attributes are chosen to assign cell values in their raster
# 'rasterize' has an argument that allows you to set rules to decide which
# value is attributed if a cell has more than one possible value

# rasterize uk_eire_BNG vecotr data onto 20km raster grid
# create target raster
uk_20km <- raster(xmn = -200000,
                  xmx = 650000,
                  ymn = 0,
                  ymx = 1000000,
                  res = 20000,
                  crs = '+init=EPSG:27700')

# rasterizing polygons
uk_eire_poly_20km <- rasterize(as(uk_eire_BNG, # convert data from the older spatial type 
                                  'Spatial'), # to sf because raster predates sf
                               uk_20km, 
                               field = 'name')

# rasterizing lines
# first tell sf the attributes are constant between geometries
# so it won't warn us that they might not be
st_agr(uk_eire_BNG) <- 'constant'
# here we use 'st_cast' to change the polygon data into lines
uk_eire_BNG_line <- st_cast(uk_eire_BNG, 'LINESTRING')
uk_eire_line_20km <- rasterize(as(uk_eire_BNG_line, 'Spatial'),
                               uk_20km,
                               field = 'name')

# rasterizing points
# the cast takes two steps for points and the name factor must
# be converted to numeric
uk_eire_BNG_point <- st_cast(st_cast(uk_eire_BNG, 'MULTIPOINT'), 'POINT')
uk_eire_BNG_point$name <- as.numeric(uk_eire_BNG_point$name)
uk_eire_point_20km <- rasterize(as(uk_eire_BNG_point, 'Spatial'),
                                uk_20km,
                                field = 'name')

# plot the different outcomes
par(mfrow = c(1, 3),
    mar = c(1, 1, 1, 1))

plot(uk_eire_poly_20km,
     col = viridis(6, alpha = 0.5),
     legend = F,
     axes = F)
plot(st_geometry(uk_eire_BNG), add = T, border = 'grey')

plot(uk_eire_line_20km,
     col = viridis(6, alpha = 0.5),
     legend = F,
     axes = F)
plot(st_geometry(uk_eire_BNG), add = T, border = 'grey')

plot(uk_eire_point_20km,
     col = viridis(6, alpha = 0.5),
     legend = F,
     axes = F)
plot(st_geometry(uk_eire_BNG), add = T, border = 'grey')

## Raster to vector
# there are two ways to do this using the raster package
# 1 - view the value as representing the whole cell (polygon)
# 2 - view the value as representing a point in the centre (point)

# rasterToPolygons returns a polygon for each cell and returns a Spatial object
poly_from_rast <- rasterToPolygons(uk_eire_poly_20km)
poly_from_rast <- as(poly_from_rast, 'sf') # turn into sf object

# we can set this to dissolve the boundaries between cells with identical values
poly_from_rast_dissolve <- rasterToPolygons(uk_eire_poly_20km, dissolve = TRUE)
poly_from_rast_dissolve <- as(poly_from_rast_dissolve, 'sf')

# rasterToPoints returns a matrix of coordinates and values
points_from_rast <- rasterToPoints(uk_eire_poly_20km)
points_from_rast <- st_as_sf(data.frame(points_from_rast), coords = c('x', 'y'))

# plot the outputs
par(mfrow = c(1, 3), mar = c(1, 1, 1, 1))
plot(poly_from_rast['layer'], 
     key.pos = NULL, # supporess key
     reset = FALSE) # stop plot.sf altering the par() options
plot(poly_from_rast_dissolve, 
     key.pos = NULL, 
     reset = FALSE)
plot(points_from_rast, 
     key.pos = NULL, 
     reset = FALSE)

# note that it is uncommon to have raster data representing linear features
# (like uk_eire_line_20km)


####################### USING DATA IN FILES #############################

## Saving vector data

# use st_read in sf package to read vector data
# use raster in raster package to read raster data

# the most common vector data file format is the shapefile
# note that shapefiles save the data as a number of files with different extensions

# save uk_eire data to a shapefile
st_write(uk_eire, '../Results/uk_eire_WGS84.shp')
st_write(uk_eire_BNG, '../Results/uk_eire_BNG.shp')

# save uk_eire data to a GeoJSON instead (saves data as a single text file)
st_write(uk_eire, '../Results/uk_eire_WGS84.geojson')
# or save to a GeoPackage (stores data in a single SQLite3 database file)
st_write(uk_eire, '../Results/uk_eire_WGS84.gpkg')

# sf package chooses output file based on file extension but you can 
# specify a driver directly
st_write(uk_eire, '../Results/uk_eire_WGS84.json', driver = 'GeoJSON')

## Saving raster data

# GeoTIFF is the most common GIS raster data format
# GeoTIFF is essentially a TIFF image that contains embedded data describing the origin,
# resolution and coordinate reference system of the data
# sometimes a .tfw file (a 'world' file) exists, which contains the same information
# as the GeoTIFF and should be kept with it

# raster package chooses output file based on file extension but you can 
# specify a driver directly by using the 'format' argument

# save raster to a GeoTIFF
writeRaster(uk_raster_BNG_interp, '../Results/uk_raster_BNG_interp.tif')

# save an ASCII format file (but note this format does not contain projection details)
writeRaster(uk_raster_BNG_ngb, '../Results/uk_raster_BNG-ngb.asc', format = 'ascii')

## Loading vector data

# practice loading use the 1:110m scale Natural Earth data on countries
# load a vector shapefile
ne_110 <- st_read('../Data/ne_110m_admin_0_countries/ne_110m_admin_0_countries.shp')

# also load some WHO data on 2016 life expectancy
life_exp <- read.csv(file = "../Data/WHOSIS_000001.csv")

# merge the two datasets so that the ne_110 data frame includes life expectancy
ne_110_merge <- merge(ne_110, life_exp, 
                      by.x = 'ISO_A3_EH', 
                      by.y = 'COUNTRY',
                      all.x = TRUE)

# set the breaks to determine colour variation across values
bks <- seq(50, 85, by = 0.25)

# generate plotting area
par(mfrow = c(2, 1), 
    mar = c(1, 1, 1, 1))

# plot global GDP
plot(ne_110['GDP_MD_EST'], 
     asp = 1, 
     main = 'Global GDP', 
     logz = TRUE,
     key.pos = 4)

# plot life expectancy data
plot(ne_110_merge['Numeric'],
     asp = 1,
     main = 'Global 2016 Life Expectancy (Both sexes)',
     key.pos = 4,
     pal = viridis, # sets the colour palette
     breaks = bks)                  

# loading data from a table
# read in Southern Ocean example
so_data <- read.csv('../Data/Southern_Ocean.csv', header = T)

# convert dataframe to sf object
so_data <- st_as_sf(so_data, coords = c('long', 'lat'), crs = 4326)

## Loading raster data

# load some global topographic data
etopo_25 <- raster('../Data/etopo_25.tif')

# plot the data
plot(etopo_25)

# a more useful plot of the same data
l_col <- terrain.colors(24)
o_col_pal <- colorRampPalette(c('darkslateblue', 'steelblue', 'paleturquoise'))
o_col <- o_col_pal(40)
brks <- seq(-10000, 6000, by = 250)
plot(etopo_25,
     axis.args=list(at=seq(-10000, 6000, by = 2000), lab = seq(-10, 6, by = 2)),
     axes = F,
     breaks = brks,
     col = c(o_col, l_col))

## Raster stacks

# raster data can contain multiple layers (called multiple bands) of information 
# for the cells in the raster grid

# download bioclim data: global maximum temperature at 10 arc minute resolution
# note this only downloads once and after will just load the local copy
tmax <- getData('worldclim', 
                download = T, 
                path = '../Data',
                var = 'tmax',
                res = 10)

# note it is very common for GIS data to be stored in a form that needs scaling
# by the end user - this is to minimise disk use since integer data is stored more compactly than
# float data ( 2 bytes per number vs 4 bytes per number)
# the metadata for a raster data set should include any scale
# and offset values needed

# for example, here the data has the range -478 to 489 so needs scaling
# different layers can be accessed using [[?]]
# aggregated functions (e.g. sum, mean) can also be used to extract information across layers

# scale the data
tmax <- tmax / 10
# extract January and July data and the annual maximum by location
tmax_jan <- tmax[[1]]
tmax_jul <- tmax[[7]]
tmax_max <- max(tmax)
# plot these maps
par(mfrow = c(3, 1), mar = c(2, 2, 1, 1))
bks <- seq(-500, 500, length = 101)
pal <- colorRampPalette(c('lightblue', 'grey', 'firebrick'))
cols <- pal(100)
ax.args <- list(at = seq(-500, 500, by = 100))
plot(tmax_jan, 
     col = cols, 
     breaks = bks,
     axis.args = ax.args,
     main = 'January maxiumum temperature')
plot(tmax_jul, 
     col = cols, 
     breaks = bks,
     axis.args = ax.args,
     main = 'July maxiumum temperature')
plot(tmax_max, 
     col = cols, 
     breaks = bks,
     axis.args = ax.args,
     main = 'Annual maxiumum temperature')


############## OVERLAYING RASTER AND VECTOR DATA ##############

## Cropping data

# if you only need a subset of the GIS dataset, you can crop the data to make 
# plotting easier and GIS operations faster

# crop the southern ocean raster data
so_extent <- extent(-60, -20, -65, -45)
so_topo <- crop(etopo_25, so_extent)

# crop the Natural Earth country data
ne_10 <- st_read('../Data/ne_10m_admin_0_countries/ne_10m_admin_0_countries.shp')
# use the st_crop function to reduce some higher resolution coastline data
st_agr(ne_10) <- 'constant'
so_ne_10 <- st_crop(ne_10, so_extent)
# note that although coorindates are long/lat, st_intersection assumes they are planar

# plot the data
pal <- colorRampPalette(c('grey30', 'grey50', 'grey70'))
plot(so_topo, 
     col = pal(100), 
     asp = 1,
     legend = F)
contour(so_topo, 
        levels = c(-2000, -4000, -6000), 
        add = T, 
        col = 'grey80')
plot(st_geometry(so_ne_10), 
     add = T, 
     col = 'grey90', 
     border = 'grey40')
plot(so_data['chlorophyll'], 
     add = T,
     logz = T,
     pch = 20,
     cex = 2,
     pal = viridis,
     border = 'white',
     reset = F)

.image_scale(log10(so_data$chlorophyll), 
             col = viridis(18),
             key.length = 0.8,
             key.pos = 4,
             logz = T)

######## SPATIAL JOINS AND RASTER DATA EXTRACTION ###########

### Spatial joining

# merging data spatially is called a spatial join
# extract Africa from the ne_110 data and keep the columns we want to use
africa <- subset(ne_110, 
                 CONTINENT == 'Africa',
                 select = c('ADMIN', 'POP_EST'))
# transform to the Robinson projection
africa <- st_transform(africa, crs = 54030)
# create a random sample of points
mosquito_points <- st_sample(africa, 1000)

# create plot
plot(st_geometry(africa),
     col = 'khaki')
plot(mosquito_points,
     col = 'firebrick',
     add = T)

# in order to combine the country data with the mosquito data, we need to turn
# mosquito_points from a sfc geometry column into a full sf dataframe so that it can
# have attributes and we can add the country name onto the points
mosquito_points <- st_sf(mosquito_points)
mosquito_points <- st_join(mosquito_points, africa['ADMIN'])

# plot the combined data
plot(st_geometry(africa), col = 'khaki')
plot(mosquito_points['ADMIN'], add = T)

# now aggregate the points within countries to give us a count of the number of points
# in each country and also convert multiple rows of "POINT" into a single "MULTIPOINT"
# feature per country
mosquito_points_agg <-aggregate(mosquito_points, 
                                by = list(country = mosquito_points$ADMIN),
                                FUN = length)
names(mosquito_points_agg)[2] <- 'n_outbreaks'

# combine the area as well
africa <- st_join(africa, mosquito_points_agg)
africa$area <- as.numeric(st_area(africa))

# plot the combined data
par(mfrow = c(1, 2), mar = c)



