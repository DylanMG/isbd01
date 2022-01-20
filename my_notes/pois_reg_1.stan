data {
  int<lower=1> N;
  int<lower=1> K;
  matrix[N, K+1] X;
  int<lower=0> y[N]; //no upper bound on y, because counts can be high in model.  
  //hyperparameters
  real<lower=0> tau;
}

parameters {
  vector[K+1] beta;
}

transformed parameters {
  vector[N] mu;
  mu = X * beta;
}

model {
  beta ~ normal(0, tau); //priors with hyperparameters
  y ~ poisson_log(mu); //likelihood model
}

generated quantities {
  vector[N] lambda;
  lambda = exp(mu);
}
