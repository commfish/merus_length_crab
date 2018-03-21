# K.Palof 
# 3-20-18
# Goal: to assist in sample size determination and analysis of merus length vs. carapace width study.
#   PIs on study are Lee Hulbert and Chris Siddon.  See literature folder for references which study is based on.

# all measurements are in mm - millimeters unless otherwise noted. 

# Load Packages ------
library(tidyverse)
options(scipen=999)
library(xlsx)
library(extrafont)
loadfonts(device="win")
windowsFonts(Times=windowsFont("TT Times New Roman"))

theme_set(theme_bw(base_size=12,base_family='Times New Roman')+ 
            theme(panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank()))


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
conf_inter <- as.data.frame(conf_inter)

conf_inter %>% 
  bind_cols(new.dat) ->confidenceI

# prediction interval ------
pred_inter <- predict(fit1, newdata = new.dat, interval = 'prediction')
pred_inter <- as.data.frame(pred_inter)

pred_inter %>% 
  bind_cols(new.dat) ->predictionI


# visual of confidence and predictive intervals -----
ggplot(dat, aes(width, raw_merus)) +
        geom_point(size =2) +
        geom_line(data = confidenceI, aes(width, fit), color = "red", size = 1) +
        geom_line(data = confidenceI, aes(width, lwr), color = "red", lty = 2, size = 1) +
        geom_line(data = confidenceI, aes(width, upr), color = "red", lty =2, size = 1) +
        geom_line(data = predictionI, aes(width, lwr), color = "blue", lty = 3, size = 1) +
        geom_line(data = predictionI, aes(width, upr), color = "blue", lty =3, size = 1) 

# function ----
#mean.pred.intervals(dat$width, dat$raw_merus, new.dat)



# power analysis to determine sample size needed to predict if legal or not.