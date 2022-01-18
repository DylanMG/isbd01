#class notes

#load packages
library(tidyverse)
library(rstan)

#load and reshape
dice <- read.csv("data/loaded_dice.csv") %>%
  mutate(is_six = ifelse(outcome == 6, 1,0)) #flip to numeric b/c Stan don't like T/F

y <- pull(dice, is_six) #grab the vector of data from the dice_df

#do a model - create a new stan file via File > New File > Stan File
dice_1_model <- stan('my_notes/dice_1.stan', data = list(y = y, N = length(y)))
  #R knows 

dice_1_model