parameters {
    real y;
    real x;
    real yy_raw;
}
transformed parameters{
    real yy;
    yy=pow(fabs(yy_raw),1.0/3)*yy_raw/fabs(yy_raw);
}
model {
    target += std_normal_lpdf( y*y*y*y );
    target += std_normal_lpdf(x);
    target += std_normal_lpdf(yy_raw);
}