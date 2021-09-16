library(tidyverse)
library(lubridate)
library(readxl)
library(parsedate)
library(googledrive)
library(here)

# Read in raw data sheet and create a new eventDate column in UTC that assumes the original timezone was UTC +12
sheet1 <- read_csv(here("original_data", "raw_data", "POM_tidy-Sheet1.csv")) %>% 
  mutate(Time = format(Time, "%H:%M:%S"),
         eventDate = format_iso_8601(as.POSIXct(paste(Date, Time),
                                                format="%Y-%m-%d %H:%M:%S",
                                                tz = "Asia/Kamchatka")), 
         eventDate = str_replace(eventDate, "\\+00:00", "Z"))

#Per correspondence with the data provider (Brian Hunt), it's likely that a typo was made when transcribing the longitude value for Station 60 because it does not align with the station's coordinates from other datasets. We're making the correction in the data wrangle script to preserve the integrity of the raw data file.
sheet1 <- sheet1 %>%
  mutate(Longitude = ifelse(station == "GoA2019_Stn60", "-136.997", Longitude))

write_csv(sheet1, here("original_data", "IYS_2019_POM.csv"))
