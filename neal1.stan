functions{
    real xy_to_y(vector x_raw,real y_raw){
        return  3.0 * y_raw;
    }
    vector xy_to_x(vector x_raw,real y_raw){
        return  exp(xy_to_y(x_raw,y_raw )/2) * x_raw;
    }
}

data{
    int N;
}

parameters {
  real y_raw;
  vector[N] x_raw;
}
transformed parameters {
  real y;
  vector[N] x;
  y=xy_to_y(x_raw,y_raw);
  x=xy_to_x(x_raw,y_raw);
}
model {
  y_raw ~ std_normal(); // implies y ~ normal(0, 3)
  x_raw ~ std_normal(); // implies x ~ normal(0, exp(y/2))
}
