# K.Palof 
# 3-20-18
# Goal: to assist in sample size determination and analysis of merus length vs. carapace width study.
#   PIs on study are Lee Hulbert and Chris Siddon.  See literature folder for references which study is based on.

# all measurements are in mm - millimeters unless otherwise noted. 

# Load Packages ------
library(tidyverse)
options(scipen=999)
library(xlsx)

# Data -------
dat <- read.xlsx("./data/Donaldson Blackburn 1989 Data.xlsx", sheetName = "rinput")

# plot data -----
ggplot(dat, aes(width, raw_merus)) + 
         geom_point(size =2) +
         geom_smooth(method =lm)
         



# Regression ---
# carapace width (width) vs. raw_merus length

fit1 = lm(raw_merus ~ width, data = dat) 
summary(fit1)
plot(fit1)

# confidence interval -----
new.dat <- data.frame(width = seq(from =135, to = 215, length.out = 181))
conf_inter <- predict(fit1, newdata = new.dat, interval = 'confidence')


# prediction interval ------


# function ----
mean.pred.intervals(dat$width, dat$raw_merus, new.dat)
