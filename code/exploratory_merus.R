# K.Palof 
# 3-20-18
# Goal: to assist in sample size determination and analysis of merus length vs. carapace width study.
#   PIs on study are Lee Hulbert and Chris Siddon.  See literature folder for references which study is based on.

# all measurements are in mm - millimeters unless otherwise noted. 

# Load Packages ------
library(tidyverse)
options(scipen=999)


# Data -------
dat <- read.csv("./data/tanner_dockside_13_16.csv")
