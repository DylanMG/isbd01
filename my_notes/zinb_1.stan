
model {
  for (i in 1:N){
    target += zero_inf_nb_log_lpmf(y[i] | mu[i], phi, theta)
  }
  
  target += cauchy_lpdf(phi|0, 10); // like phi ~ cauchy
  target += beta_lpdf(theta| 1,1)
  
}