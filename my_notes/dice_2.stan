// write blocks of code: data, parameters, model

data {
  int<lower=1> N;
  int<lower=0, upper=1> y[N] ; //specifically declae values: type, bounds, dimensions
  real<lower=0> a;
  real<lower=0> b;
}

parameters {
  real<lower=0, upper=1> theta;
}

model {
  theta ~ beta(a, b); //hyper parameters declared in data chunk
  y ~ bernoulli(theta); // bernoulli data model
}
