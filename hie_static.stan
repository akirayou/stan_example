data{
    int M;
    int N;
    vector[N] Y[M];
}
parameters{
    vector[M] tank;
    real tank_u;
    real tank_s;
    real sigma;
}
model{
    tank ~ normal(tank_u,tank_s);
    for(m in 1:M){
        Y[m] ~ normal(tank[m],sigma);
    }
}
generated quantities{
    vector[M] log_likelihood;
    for(m in 1:M){
        vector[100] sums;
        real sum;
        for(i in 1:100){
             for(n in 1:N){
                sum += normal_lpdf(Y[m,n] |tank[m],sigma); /* integrate  */
            }
            sums[i]=sum;
        }
        log_likelihood[m]=log_sum_exp(sums)-log(N)-log(100);
    }
}
