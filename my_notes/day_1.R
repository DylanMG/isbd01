#class exercises

#load packages
library(tidyverse)
library(rstan)

#load and reshape
dice <- read.csv("data/loaded_dice.csv") %>%
  mutate(is_six = ifelse(outcome == 6, 1,0)) #flip to numeric b/c Stan don't like T/F

y <- pull(dice, is_six) #grab the vector of data from the dice_df

#do a model - create a new stan file via File > New File > Stan File
dice_1_model <- stan('my_notes/dice_1.stan', data = list(y=y, N=length(y)))
dice_1_model

dice_2_data <- list(y=y, N=length(y), a=2, b=3) #write the data as a list object rather
                                                  #than in function as above
dice_2_model <- stan('my_notes/dice_2.stan', data=dice_2_data)
dice_2_model

#next do a loop on theta model to speed up C++
dice_3_model <- stan('my_notes/dice_3.stan', data=dice_2_data)
dice_3_model

#then do a binomial instead of bernoulli 
dice_4_data <- list(m=sum(y), N=length(y), a=2, b=3) #write the data as a list object rather
dice_4_model <- stan('my_notes/dice_4.stan', data=dice_4_data)
dice_4_model

#then logistic - write it out as log odds 
dice_5_data <- list(y=y, N=length(y), sigma = 1) #write the data as a list object rather
dice_5_model <- stan('my_notes/dice_5.stan', data=dice_5_data) #WHY ERROR!?
dice_5_model #getting posterior over mu, but want it or theta