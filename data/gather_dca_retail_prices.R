# gather dca retail prices

library(readxl)
library(tidyverse)

read.dca1 <- function(yYYYY){
  df <- read_excel("data/rawdata/DCA-Onion-Retail.xlsx", sheet = yYYYY, 
                   col_types =rep(c("date", "numeric", "numeric"), 12))  
  df_fun = function(Cols) {
    df.1 = df[,Cols]
    names(df.1) <- c("date", "mumbai", "nagpur")
    return(df.1)
  }
  
  ColsList = list(c(1:3), c(4:6), c(7:9), c(10:12), c(13:15), c(16:18),
                  c(19:21), c(22:24), c(25:27), c(28:30), c(31:33), c(34:36))
  data = do.call("rbind", lapply(ColsList, df_fun))
  return(data)
}

data.dca1 = do.call("rbind", lapply(list("y2010", "y2011", "y2012", "y2013", "y2014", "y2015"), read.dca1))
data.dca1$pune <- data.dca1$nashik <- NA

read.dca2 <- function(yYYYY){
  df <- read_excel("data/rawdata/DCA-Onion-Retail.xlsx", sheet = yYYYY, 
                   col_types =rep(c("date", "numeric", "numeric", "numeric", "numeric"), 12))  
  df_fun = function(Cols) {
    df.1 = df[,Cols]
    names(df.1) <- c("date", "mumbai", "nagpur", "pune", "nashik")
    return(df.1)
  }
  
  ColsList = list(c(1:5), c(6:10), c(11:15), c(16:20), c(21:25), c(26:30),
                  c(31:35), c(36:40), c(41:45), c(46:50), c(51:55), c(56:60))
  data = do.call("rbind", lapply(ColsList, df_fun))
  return(data)
}

data.dca2 = do.call("rbind", lapply(list("y2016", "y2017", "y2018", "y2019", "y2020"), read.dca2))

read.dca3 <- function(yYYYY){
  df <- read_excel("data/rawdata/DCA-Onion-Retail.xlsx", sheet = yYYYY, 
                   col_types =rep(c("date", "numeric", "numeric", "numeric", "numeric"), 2))  
  df_fun = function(Cols) {
    df.1 = df[,Cols]
    names(df.1) <- c("date", "mumbai", "nagpur", "pune", "nashik")
    return(df.1)
  }
  
  ColsList = list(c(1:5), c(6:10))
  data = do.call("rbind", lapply(ColsList, df_fun))
  return(data)
}

data.dca3 = do.call("rbind", lapply(list("y2021"), read.dca3))

data.dca <- rbind(data.dca1, data.dca2, data.dca3) %>%
  filter(!is.na(.$date)) 

data.dca <- pivot_longer(data.dca, cols = mumbai:pune, names_to = "center", values_to = "dca_retail") %>%
  mutate(center = str_to_title(center))

saveRDS(data.dca, "data/cleandata/dca_retail_prices.rds")

