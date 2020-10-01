#cleaning, trying to mask client data
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

write_rds(case_location, "input/case_locations.RDS")
