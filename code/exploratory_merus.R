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
library(pwr)
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
#plot(fit1)

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
        geom_point(size =2, pch = 1) +
        geom_line(data = confidenceI, aes(width, fit), color = "black", size = 1) +
        geom_line(data = confidenceI, aes(width, lwr), color = "red", lty = 2, size = 1) +
        geom_line(data = confidenceI, aes(width, upr), color = "red", lty =2, size = 1) +
        geom_line(data = predictionI, aes(width, lwr), color = "blue", lty = 3, size = 1) +
        geom_line(data = predictionI, aes(width, upr), color = "blue", lty =3, size = 1) +
  xlab("carapace width (mm)") + ylab("merus length (mm)") + ggtitle("carapace width vs raw merus length") +
  geom_vline( xintercept = 177.8)


# min and max values for graphing ------
dat %>% 
  group_by(legal) %>% 
  summarise(min = min(raw_merus), max = max(raw_merus))

dat %>% 
  filter(raw_merus >124 & legal =="N") %>% 
  summarise(min = min(width))

dat %>% 
  filter(legal == "Y" & raw_merus <144) %>% 
  summarise(max = max(width))

newdata2 = data.frame(width = c(165, 177.8))
# y intercept when x = 165 and 177.8
predict(fit1, newdata = newdata2, interval = 'prediction')

## power analysis ------------
# power analysis to determine sample size needed to predict if legal or not.
# seperate data into legal and non groups
dat %>% 
  mutate(legal = ifelse(width < 178, "N", "Y")) -> dat

# average merus length by legal or not
dat %>% 
  group_by(legal) %>% 
  summarise(average = mean(raw_merus), SD = sd(raw_merus)) ->legal_sum

#average merus length overall
dat %>% 
  summarise(average = mean(raw_merus), SD = sd(raw_merus))


# power to detect difference in mean between two groups
d = (legal_sum$average[2] - legal_sum$average[1])/sd(dat$raw_merus)
f = 0.5*d
pwr.t.test(d= 0.3, power = .85, sig.level = 0.05, type = "two.sample", alternative = "two.sided")
# power to detect small effect size between two means 85% power at 95% significance level.