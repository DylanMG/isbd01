// write blocks of code: data, parameters, model
//log odds version

data {
  int<lower=1> N;
  int<lower=0, upper=1> y[N];
  real<lower=0> sigma;
}

parameters {
  real mu;
}

model {
  mu ~ normal(0, sigma);
  y ~ bernoulli_logit(mu); // bernoulli data model
}

generated quantities { // do this step to flip mu to theta (the parm we care about)
  real log_lik[N];
  real<lower=0, upper=1> theta;
  theta = inv_logit(mu);
  
  for (i in 1:N){
    log_lik[i] = bernoulli_logit_lpmf(y[i] | mu); //log probability mass function
  }
}