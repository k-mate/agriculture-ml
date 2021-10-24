# program to gather rainfall data
rm(list = ls())
library(readxl)
library(tidyverse)
library(zoo)

read.rain <- function(filename){
  FILEPATH = file.path("data/rawdata/rainfall", filename)
  data <- read_excel(FILEPATH, skip = 0)
  data <- data[,-1]
  data <- t(data)
  colnames(data) <- tolower(as.character(data[1,]))
  colnames(data)[c(1:2, dim(data)[2])] <- c("date", "case", "india")
  data <- data[-1,]
  data <- as.data.frame(data)
  data$date <- na.locf(data$date)
  data <- data %>% pivot_longer(-c("date", "case"), names_to = "district", values_to = "rainfall")
  data$rainfall <- as.numeric(data$rainfall)
  return(data)
}

files = list.files("data/rawdata/rainfall")
listfiles = lapply(files, read.rain)
data = do.call("rbind", listfiles)

data = filter(data, date != "Cumulative")

data <- pivot_wider(data, names_from = case, values_from = rainfall)
colnames(data)[3:5] <- c("actual", "normal", "deviation")
# data$date = format(dmy(data$date),"%d-%b-%Y")
data$date = as.Date(data$date, "%d %b %Y")
str(data)
data = mutate(data, year = format(date, "%Y"), month = format(date, "%m"), 
              day = format(date, "%d"), district = str_to_title(district))
saveRDS(data, file = "data/cleandata/rainfall_data.rds")



