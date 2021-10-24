# to gather data from rawdata folder
library(readxl)
library(tidyverse)
library(zoo)
library(ggplot2)

read.agri <- function(filename){
  FILEPATH = file.path("data/rawdata/onion_mandi/", filename)
  data = read_excel(FILEPATH, range = "A5:G5000", 
        col_types = c("text","date", "numeric", "text", "numeric","numeric", "numeric"))

  colnames(data) <- c("market", "date", "arrivals", "variety", "min_price", "max_price", "modal_price")
  rowSums(is.na(data))==7
  data = drop_na(data, c("arrivals", "variety", "min_price", "max_price", "modal_price"))
#  data = data[rowSums(is.na(data))<7,]
  data$filename = as.character(filename)
  return(data)
}

files = list.files("data/rawdata/onion_mandi/")
listfiles = lapply(files, read.agri)
data = do.call("rbind", listfiles)

data$market <- na.locf(data$market)
data$date <- na.locf(data$date)
data <- data[!duplicated(data),]

saveRDS(data,file = "data/cleandata/mandi_data.rds")

# cleaning data
mandi_data <- readRDS("data/cleandata/mandi_data.rds")
mandi_data$market[grep("Pune", mandi_data$market)] <- "Pune"
mandi_data$market[grep("Mumbai", mandi_data$market)] <- "Mumbai"
mandi_data$market[grep("Lasalgaon", mandi_data$market)] <- "Lasalgaon"
mandi_data$market[grep("Newasa", mandi_data$market)] <- "Newasa"
mandi_data$market[grep("Amrawati", mandi_data$market)] <- "Amarawati"

mandi_data$market[grep("Chandrapur", mandi_data$market)] <- "Chandrapur"
mandi_data$market[grep("Dindori", mandi_data$market)] <- "Dindori"
mandi_data$market[grep("Jalgaon", mandi_data$market)] <- "Jalgaon"
mandi_data$market[grep("Malegaon", mandi_data$market)] <- "Malegaon"
mandi_data$market[grep("Nashik|Nasik", mandi_data$market)] <- "Nashik"
mandi_data$market[grep("Kolhapur", mandi_data$market)] <- "Kolhapur"

mandi_data$market[grep("Junnar", mandi_data$market)] <- "Junnar"
mandi_data$market[grep("Karjat", mandi_data$market)] <- "Karjat"
mandi_data$market[grep("Rahuri", mandi_data$market)] <- "Rahuri"
mandi_data$market[grep("Kurdwadi", mandi_data$market)] <- "Kurdwadi"
mandi_data$market[grep("Shrigonda", mandi_data$market)] <- "Shrigonda"

mandi_data$market[grep("Jalna|Jalana", mandi_data$market)] <- "Jalna"
mandi_data$market[grep("Pimpalgaon", mandi_data$market)] <- "Pimpalgaon"
mandi_data$market[grep("Khed", mandi_data$market)] <- "Khed"
mandi_data$market[grep("Sangli", mandi_data$market)] <- "Sangli"

manditop10 <- mandi_data %>%
  group_by(market) %>%
  summarise(arrivals = sum(arrivals, na.rm = T)) %>%
  arrange(desc(arrivals)) 
(manditop10 <- manditop10$market[1:10])

mandi_data <- mandi_data %>%
  filter(market %in% manditop10) %>%
  group_by(market, date) %>%
  summarise(arrivals = sum(arrivals, na.rm = T),
            max_price = max(max_price, na.rm = T),
            min_price = min(min_price, na.rm = T),
            mod_price = mean(modal_price, na.rm = T)) %>% 
  ungroup()

# data corrected
data <- mandi_data %>%
  mutate(year = format(date, "%Y")) %>%
  mutate(month = format(date, "%m"), day = format(date, "%d"))
data[which(data$max_price > 30000 & data$market == "Lasalgaon"), ]$max_price <- 3182.5
data[which(data$year == "2019" & data$market == "Lasalgaon" & data$month == "05" & data$day == "28"),]$max_price <- 1301.2
data[which(data$year == "2019" & data$market == "Mumbai" & data$month == "01" & data$day == "17"),]$max_price <- 900.0

saveRDS(data, "data/cleandata/mandi_top10_data.rds")
