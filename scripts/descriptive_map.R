#geocoding and stats
library(tidyverse)
library(sf)
library(geojsonsf)
library(leaflet)

file <- here("input/juveniles.RDS")
shapes <- here("shapes/cpd_districts.geojson")
cases <- read_rds(file)
cpd_district <- read_sf(shapes, crs = "+proj=longlat +datum=WGS84")

cpd_district <- cpd_district%>%
  filter(dist_num != 31)

view (cases)

cpd_pal <- colorFactor("viridis", domain = as.factor(cpd_district$dist_num))

#Should make a function -- have it somewhere, actually.
cases$race <- cases$race %>% str_replace_all("Black Hispanic /Latino", "Black Hispanic/Latino")
cases$race <- cases$race %>% na_if("N/A")
cases$race <- cases$race %>% str_replace_all("OTHR", "Other")

cases %>% group_by(zip) %>%
  summarise(n = n())

multiple_cases <- cases %>%
  group_by(client_no) %>%
  summarise(count = n()) %>% 
  arrange(desc(count))


case_location <- cases %>%
  select(client_no, lon, lat) %>%
  filter(!is.na(lon)) %>%
  st_as_sf(coords = c("lon", "lat"),
           crs = 4326)

cpd_district_counts <- cpd_district %>%
  mutate(counts = st_intersects(., case_location) %>% lengths(),
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
             label = paste(cpd_district_counts$dist_label, 
                           "District has a total of \n", 
                           cpd_district_counts$counts, "arrests", " "),
             labelOptions = labelOptions(noHide = TRUE))

class(count)
 
#   addMarkers(lng = cases$lon,
#              lat = cases$lat,
#              data = cases)
#   
