# gather monthly onion exports data

library(readxl)
library(zoo)
library(tidyverse)

read.onionexport <- function(filename){
  FILEPATH = file.path("data/rawdata/onion_export/", filename)
  data <- read_excel(FILEPATH,range = "B3:G15")
  data$date = as.yearmon(paste(data$Year, data$Month, sep = "-"), "%Y-%B")
  return(data)
}

files = list.files("data/rawdata/onion_export/")
listfiles = lapply(files, read.onionexport)
data = do.call("rbind", listfiles)

data[,4:6] = sapply(data[,4:6], as.numeric)
data = data[complete.cases(data),]
colnames(data) <- c("year", "month", "source", "quantity", "value", "puv", "date")

saveRDS(data, "data/cleandata/onionExports_data.rds")
