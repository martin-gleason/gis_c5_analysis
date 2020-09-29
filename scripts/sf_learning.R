dat <- tibble::tribble(
  ~code,    ~geometry,
  "MIE",    list(c(1.24, 45), c(1.25, 45), c(1.25, 46), c(1.24, 45)),
  "MIS",    list(c(1.23, 44), c(1.23, 45), c(1.24, 45), c(1.23, 44))
)


dat %>%
  mutate(geometry = map(geometry,
                        ~ do.call(rbind, .) %>% # make each list a matrix
                          list() %>% # st_polygon() requires a list
                          st_polygon()
  )
  ) %>% 
  st_as_sf()


dat$geometry

cpd_district$the_geom.coordinates
