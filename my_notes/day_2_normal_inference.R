library(tidyverse)
library(rstan)
library(brms)
library(bayesplot)
library(tidybayes)
# normal inference ------------------------------------------------------------------
math_df <- read_csv("data/MathPlacement.csv")

#see some data drawn from normal distribution 
ggplot(math_df, aes(x=ACTM)) +
  geom_histogram(bins=50)

#reshape
y <- math_df %>% 
  select(ACTM) %>% 
  na.omit() %>% #Stan doesn't like NA
  pull(ACTM)

normal_1_data <- list(y=y, N = length(y))

normal_1_model <- stan(file = 'my_notes/normal_1.stan', data = normal_1_data)

mcmc_combo(normal_1_model, pars = c("mu", "sigma"))#plot it

#modelling with hyper parameters (rather than hard coding them into Stan)
normal_2_data <- list(y=y, N = length(y), nu = 5, tau = 50, omega = 5)

normal_2_model <- stan(file = 'my_notes/normal_2.stan', data = normal_2_data)

#check mu and sigma posteriors 
summary(normal_2_model, pars = c("mu", "sigma"), probs = c(0.025, 0.975))$summary

# simple linear regression ----------------------------------------------------------
ggplot(math_df, aes(x=ACTM, y=PlcmtScore)) + #look at the units to pick priors
  geom_point()

math_df_2 <- select(math_df, x = ACTM, y = PlcmtScore) %>%
  na.omit()

lin_reg_1_data <- list(y = math_df_2$y, x = math_df_2$x, N = nrow(math_df_2),
                       tau = 100, nu = 5, omega = 10)

lin_reg_1_model <- stan(file = 'my_notes/lin_reg_1.stan', data = lin_reg_1_data)
lin_reg_1_model

lin_reg_2_model <- stan(file = 'my_notes/lin_reg_2.stan', data = lin_reg_1_data)
summary(lin_reg_2_model, pars = c('beta_0', 'beta_1', 'sigma'))$summary

# multiple regression ---------------------------------------------------------------
weight_df <- read_csv("data/weight.csv")

#need to sort out some coding for categorical vars
library(modelr)



#deals with the handedness variable - needs to be coded as dummy vars w/ 0,1
X <- select(weight_df,
            weight, height, age, gender, handedness) %>% 
  na.omit() %>% 
  model_matrix(~ height + age + gender + handedness) %>%
  as.matrix()

lin_reg_3_data <- list(y=weight_df$weight, 
                        X = X, 
                        N = nrow(X), 
                        K = ncol(X)-1, 
                        tau = 100, 
                        nu = 3,
                        omega = 50)

lin_reg_3_model <- stan(file = 'my_notes/lin_reg_3.stan', data = lin_reg_3_data, cores = 4)
