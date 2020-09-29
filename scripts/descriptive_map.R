#geocoding and stats
library(tidyverse)
library(sf)
library(geojsonsf)

cases <- read_rds("input/juveniles.RDS")

view (cases)

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

cpd_district <- read_sf("shapes/cpd_districts.geojson")
