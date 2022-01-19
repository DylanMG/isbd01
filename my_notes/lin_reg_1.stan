data {
  int<lower=1> N;
  vector[N] x;
  vector[N] y;
  
  //hyperparameters
  real<lower=0> tau;
  real<lower=0> nu;
  real<lower=0> omega;
}

parameters {
real beta_0;
real beta_1;
real<lower=0> sigma;
}

model {
  //priors with hyperparameters
  beta_0 ~ normal(0, tau); //note the betas are sharing this hyper parameter
  beta_1 ~ normal(0, tau);
  sigma ~ student_t(nu, 0, omega);
  
  //likelihood model
  y ~ normal(beta_0 + beta_1 * x, sigma);
}
