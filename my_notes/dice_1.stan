// write blocks of code: data, parameters, model

data {
  int<lower=1> N;
  int<lower=0, upper=1> y[N] ; //specifically declae values: type, bounds, dimensions
}

parameters {
  real<lower=0, upper=1> theta;
}

model {
  theta ~ beta(1, 1); // uniform beta prior
  y ~ bernoulli(theta); // bernoulli data model
}
