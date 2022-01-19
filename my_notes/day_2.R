#day 2 notes - making my own new file based on yesterday's b/c I can't handle too long
  #or cluttered environments... 
library(tidyverse)
library(rstan)
library(tidybayes)
library(brms)

dice <- read.csv("data/loaded_dice.csv") %>%
  mutate(is_six = ifelse(outcome == 6, 1,0)) #flip to numeric b/c Stan don't like T/F

y <- pull(dice, is_six) #grab the vector of data from the dice_df

dice_5_data <- list(y=y, N=length(y), sigma = 1) #write the data as a list object rather
dice_6_model <- stan('my_notes/dice_6.stan', data=dice_5_data) #WHY ERROR!?
dice_6_model #getting posterior over mu, but want it or theta

# summarizing -----------------------------------------------------------------------

summary(dice_6_model) #big array at end where "pages" are chains

#look at chain 4 only
summary(dice_6_model)$c_summary[,,4]  #c_summary is chain summary

#just look at theta
summary(dice_6_model, pars = c('theta', 'mu'))$summary

#specify intervals to look at 
summary(dice_6_model, pars = c('theta', 'mu'), probs =c(0.025, 0.0975))$summary

# Get the samples -------------------------------------------------------------------

rstan::extract(dice_6_model) #all the samples 

rstan::extract(dice_6_model, permuted = FALSE) 

rstan::extract(dice_6_model, pars = 'theta', permuted = FALSE, inc_warmup = TRUE) 

rstan::extract(dice_6_model, pars = 'theta', permuted = FALSE, inc_warmup = TRUE) %>%
  magrittr::extract(,,1) %>% #take the first chain
  as_tibble()

# tidybayes -------------------------------------------------------------------------

tidybayes::spread_draws(dice_6_model, mu, theta) #args for parms of interest

# plotting --------------------------------------------------------------------------

plot(dice_6_model) #median and defined CI levels

bayesplot::mcmc_areas(dice_6_model, pars = c('mu', 'theta')) 
bayesplot::mcmc_areas_ridges(dice_6_model, pars = c('mu', 'theta')) 
bayesplot::mcmc_combo(dice_6_model, pars = c('mu', 'theta')) 
bayesplot::mcmc_hist(dice_6_model, pars = c('mu', 'theta')) 

# model comparrison -----------------------------------------------------------------
#trying to get elpd (expected log predictive density) with LOO

# out of sample predictive performance ----------------------------------------------
library(loo)
loo(dice_6_model) #it doesn't work! - need to add info to generated quantities
                    #pointwise LL for each obs

#run a proper Stan model that returns what we need for loo
dice_7_model <- stan('my_notes/dice_7.stan', data=dice_5_data)

log_lik_7 <- extract_log_lik(dice_7_model, merge_chains = FALSE)
r_eff_7 <- relative_eff(exp(log_lik_7))

loo(dice_7_model, r_eff = r_eff_7)


# normal inference ------------------------------------------------------------------
math_df <- read_csv("data/MathPlacement.csv")

#see some data drawn from normal distribution 
ggplot(math_df, aes(x=ACTM)) +
  geom_histogram(bins=50)
