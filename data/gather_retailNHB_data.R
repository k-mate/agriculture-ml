# program to gather retail NHB data

rm(list = ls())
# to gather data from rawdata folder
library(readxl)
library(tidyverse)
library(zoo)
library(ggplot2)

read.retail.year <- function(yearurl){
  url = yearurl # "data/rawdata/Onion_Retail/2018/"
  read.agri <- function(filename){
    FILEPATH = file.path(url, filename)
    data = read_excel(FILEPATH)
    return(data)
  }
  files = list.files(url)
  listfiles = lapply(files, read.agri)
  data = do.call("rbind", listfiles)
  return(data)
}

data2008 = read.retail.year("data/rawdata/Onion_Retail_NHB/2008/")
data2009 = read.retail.year("data/rawdata/Onion_Retail_NHB/2009/")
data2010 = read.retail.year("data/rawdata/Onion_Retail_NHB/2010/")
data2011 = read.retail.year("data/rawdata/Onion_Retail_NHB/2011/")
data2012 = read.retail.year("data/rawdata/Onion_Retail_NHB/2012/")
data2013 = read.retail.year("data/rawdata/Onion_Retail_NHB/2013/")
data2014 = read.retail.year("data/rawdata/Onion_Retail_NHB/2014/")
data2015 = read.retail.year("data/rawdata/Onion_Retail_NHB/2015/")
data2016 = read.retail.year("data/rawdata/Onion_Retail_NHB/2016/")
data2017 = read.retail.year("data/rawdata/Onion_Retail_NHB/2017/")
data2018 = read.retail.year("data/rawdata/Onion_Retail_NHB/2018/")
data2019 = read.retail.year("data/rawdata/Onion_Retail_NHB/2019/")
data2020 = read.retail.year("data/rawdata/Onion_Retail_NHB/2020/")


data = rbind(data2008, data2009, data2010, data2011, data2012, data2013, data2014,
             data2015, data2016, data2017, data2018, data2018, data2019, data2020)

data1 = data[,c(3, 11, 5:9)]
colnames(data1) = c("centre", "date", "min_price", "max_price", "mod_price", "arrivals", "retail_price")

data2 = data1 %>% separate(centre, c("centre", "second")) %>% 
  select(-second) %>%
  mutate(date = as.Date(date, format = "%d/%m/%Y")) %>%
  mutate(centre = str_to_title(centre))


data2$centre[data2$centre=="Nasik"] <- "Nashik"

saveRDS(data2, file = "data/cleandata/retailNHB_data.rds")
