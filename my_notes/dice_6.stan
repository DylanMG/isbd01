// write blocks of code: data, parameters, model
//log odds version

data {
  int<lower=1> N;
  int<lower=0, upper=1> y[N];
  real<lower=0> sigma; #why isn't sigma in parameters?? because it's being used to 
}                       #create simulated data/hyper parameter?

parameters {
  real mu;
}

transformed parameters {
  real<lower=0, upper=1> theta;
  theta = inv_logit(mu) ;
}

model {
  mu ~ normal(0, sigma);
  y ~ bernoulli(theta); // bernoulli data model
}