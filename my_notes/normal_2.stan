data {
  int<lower=1> N;
  vector[N] y;
  
  //hyperparameters
  real<lower=0> tau;
  real<lower=0> nu;
  real<lower=0> omega;
}

parameters {
  real mu;
  real<lower=0> sigma;
}

model {
  //priors with hyperparameters
  mu ~ normal(0, tau); 
  sigma ~ student_t(nu, 0, omega);
  //likelihood model
  y ~ normal(mu, sigma);
}
