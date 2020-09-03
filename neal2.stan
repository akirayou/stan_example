
functions{
    real xy_to_y(vector x_raw,real y_raw){
        //return  3.0 * y_raw;
        return   y_raw/3.0; //Inverse

    }
    vector xy_to_x(vector x_raw,real y_raw){
        //return  exp(xy_to_y(x_raw,y_raw )/2) * x_raw;
        return   x_raw*exp(-y_raw/2) ;  //Inverse 
    }
}

data{
    int N;
}
parameters {
  real y;
  vector[N] x;
}
model {
  target += std_normal_lpdf(xy_to_y(x,y));
  target += std_normal_lpdf(xy_to_x(x,y));
}
generated quantities{
    real yy;
    vector[N] xx;
    yy=xy_to_y(x,y);
    xx=xy_to_x(x,y);
    

}