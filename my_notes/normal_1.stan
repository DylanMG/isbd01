data {
  int<lower=1> N;
  vector[N] y;
}

parameters {
  real mu;
  real<lower=0> sigma;
}

model {
  //priors with hyperparameters
  mu ~ normal(0, 100); //make flat by looking at ggplot in R
  sigma ~ student_t(3, 0, 10);
  //likelihood model (aka noise model) - PDF that gives you likelihood. 
  y ~ normal(mu, sigma);
}
