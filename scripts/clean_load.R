#load file
library(here)
library(tidyverse)
library(readxl)
library(lubridate)
library(ggmap)

key <- read_lines('keys/gmaps_api.txt')

register_google(key)

clients <- read_xlsx('input/GIS Report.xlsx')

class(year(clients$`DOB Summary: DoB | Date`))
juveniles <- clients %>%
  filter(year(`DOB Summary: DoB | Date`) >= 2002 & year(`DOB Summary: DoB | Date`) <= 2020) %>%
  rename('client_no' = `Person Management: Client No.`,
         'dob' = `DOB Summary: DoB | Date`,
         'race' = `Physical Characteristics Summary: Primary Race`,
         'risk_level' = `Assessment: Risk level`,
         'street' = `Address Summary: Street`,
         'city' = `Address Summary: City`,
         'state' = `Address Summary: State`,
         'zip' = `Address Summary: Zip`) %>%
  arrange(desc(dob))

juveniles %>%
  filter(client_no == 68916)

#juveniles[juveniles$client_no == 68916, ]$dob <- as.Date("1996-09-26")

juveniles %>%
  ggplot(aes(x = dob, fill = race)) + geom_histogram(stat = "count")

  
juveniles_geocode1 <- juveniles %>% 
  filter(!is.na(zip)) %>%
  mutate(location = paste(.$street, .$city, ",", .$state, .$zip, sep = "  "))


geocoded <- juveniles_geocode1$location %>% geocode()

juveniles_geocode <- juveniles %>% 
  filter(!is.na(zip)) %>%
  bind_cols(geocoded)



write_rds(juveniles_geocode, "input/juveniles.RDS")

