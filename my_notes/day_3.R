library(tidyverse)
library(rstan)
library(modelr)

#get data
biochem_df <- read_csv("data/biochemist.csv") %>%
  mutate(is_published = publications > 0)
head(biochem_df)

#no NAs - good!

X <- model_matrix(biochem_df, ~ prestige + children + married) %>%
  as.matrix()

y <- 1*biochem_df$is_published

logit_reg_1_data <- list(y=y,
                         X=X,
                         K= ncol(X)-1,
                         N=nrow(X),
                         tau = 100)
#write model
logit_reg_1_model <- stan('my_notes/logit_reg_1.stan', data = logit_reg_1_data)

glm(is_published ~ prestige + children + married, data = biochem_df, 
    family = binomial(link = 'logit')) %>%
  summary()%>%
  magrittr::extract2('coefficients')#sanity check to see if stan fit comparable

summary(logit_reg_1_model, pars = 'beta')$summary %>%
  as_tibble(rownames = 'var')

# Poisson regression ----------------------------------------------------------------
y <- biochem_df$publications
pois_reg_1_data <- list(y=y,
                         X=X,
                         K= ncol(X)-1,
                         N=nrow(X),
                         tau = 100)

pois_reg_1_model <- stan('my_notes/pois_reg_1.stan', data = pois_reg_1_data)

glm(publications ~ prestige + children + married, data = biochem_df, 
    family = poisson(link = 'log')) %>%
  summary()%>%
  magrittr::extract2('coefficients')#sanity check to see if stan fit comparable
summary(pois_reg_1_model, pars = 'beta')$summary %>%
  as_tibble(rownames = 'var')

# neg binomial ----------------------------------------------------------------------
nb_reg_1_model <- stan('my_notes/nb_reg_1.stan', data = pois_reg_1_data)

summary(nb_reg_1_model,
        pars = c('beta','phi'), 
        probs = c(0.025, 0.975))$summary %>%
  as_tibble(rownames = 'var')

MASS::glm.nb(publications ~ prestige + children + married, data = biochem_df) %>%
  summary()%>%
  magrittr::extract2('coefficients')#sanity check to see if stan fit comparable

# lme -------------------------------------------------------------------------------
library(lme4)
ggplot(sleepstudy, aes(Days, Reaction)) +
  geom_point() +
  stat_smooth(method = "lm", se=F) +
  facet_wrap(~Subject)
  
y <- sleepstudy$Reaction
x <- sleepstudy$Days
s <- as.numeric(sleepstudy$Subject)
N <- length(y)
J <- max(s)

lmm_1_data <- list(y=y, 
     x=x, 
     s=s, 
     N=N, 
     J=J, 
     nu=5, 
     omega=50)

lmm_1_model <- stan('my_notes/lmm_1.stan', data = lmm_1_data)

summary(lmm_1_model, 
        pars = c('b', 'rho', 'tau', 'sigma'), 
        probs = c(0.025, 0.975))$summary %>%
  as_tibble(rownames = 'vars')

lmer(Reaction ~ Days + (Days|Subject), data = sleepstudy) %>%
  summary()
pairs(lmm_1_model)

# playing with target +=  in stan ---------------------------------------------------

dice_df <- read_csv("https://raw.githubusercontent.com/mark-andrews/isbd01/main/data/loaded_dice.csv")

y <- dice_df %>% 
  mutate(is_six = 1 * (outcome == 6)) %>% 
  pull(is_six)

dice_1_data <- list(y = y, N = length(y))

dice_1_model <- stan(file = 'my_notes/dice_1.stan', 
                     data = dice_1_data)

dice_1_target_model <- stan(file = 'my_notes/target_1.stan', 
                     data = dice_1_data)
#compare these and see they're the same