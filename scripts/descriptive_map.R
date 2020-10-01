#geocoding and stats
library(tidyverse)
library(sf)
library(geojsonsf)
library(leaflet)

file <- here("input/case_locations.RDS")
shapes <- here("shapes/cpd_districts.geojson")
cases <- read_rds(file)

cpd_district <- read_sf(shapes, crs = "+proj=longlat +datum=WGS84")

cpd_pal <- colorFactor("viridis", domain = as.factor(cpd_district$dist_num))




cpd_district_counts <- cpd_district %>%
  mutate(counts = st_intersects(., cases) %>% lengths(),
         center = st_centroid(.$geometry))


base_chicago <- leaflet() %>% 
  setView(lat = "41.8781", lng = "-87.6298", zoom = 10) %>%
  addProviderTiles("Stamen.Terrain")

arrest_count <- base_chicago %>%
  addPolygons(data = cpd_district_counts,
              group = 1,
              color = "black",
              fillColor = ~cpd_pal(cpd_district$dist_num),
              label = cpd_district$dist_label,
              fillOpacity = 0.3,
              weight = 2) %>%
  addMarkers(data = cpd_district_counts$center,
             label = paste0(cpd_district_counts$dist_label, 
                           "district has a total of", 
                           cpd_district_counts$counts, "cases.", sep = " "),
             labelOptions = labelOptions(noHide = TRUE))


 
#   addMarkers(lng = cases$lon,
#              lat = cases$lat,
#              data = cases)
#   
