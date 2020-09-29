#stream from Socrata
require(RSocrata)
dat <- read.socrata("https://data.cityofchicago.org/resource/24zt-jpfn.json") %>% as_tibble()

glimpse(dat)
names(cpd_district)

cpd_district %>% 
  mutate(geometry = map(the_geom.coordinates,
                        ~map(.,
                             ~do.call(rbind, .) %>%
                        ) %>%
                          st_multipolygon(.)
  )
  ) %>%
  st_as_sf()


cpd_district %>% 
  mutate(geometry = map(the_geom.coordinates, st_multipolygon())) %>% 
  st_as_sf()

cpd_district$the_geom.type
