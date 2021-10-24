library(tidyverse)
library(lubridate)

weatherData = read_csv("data/rawdata/weather/Temp_2000_2021(feb).csv", skip = 17)
weatherData <- weatherData %>%
  mutate(date = make_date(YEAR, as.numeric(MO), as.numeric(DY)))
saveRDS(weatherData, "data/cleandata/nasa_weatherdata.rds")
