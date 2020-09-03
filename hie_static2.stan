data{
    int M;
    int N;
    vector[N] Y[M];
}
parameters{
    vector[M] tank;
    vector<lower=0>[M] tank_noise;
    real tank_u;
    real<lower=0> tank_s;
    real tank_noise_u;
    real<lower=0> tank_noise_s;
}
model{
    tank_u ~ normal(2,5);
    tank_s ~ normal(0,5);
    tank_noise_u ~ normal(0,5);
    tank_noise_s ~ normal(0,5);
    
    tank ~ normal(tank_u,tank_s);
    tank_noise ~ normal(tank_noise_u,tank_noise_s);
    for(m in 1:M){
        Y[m] ~ normal(tank[m],tank_noise[m]);
    }
}
generated quantities{
    vector[M] log_likelihood;
    real<lower=0> g_tank_noise;
    for(m in 1:M){for(n in 1:N){
        g_tank_noise=normal_rng(tank_noise_u,tank_noise_s);
        log_likelihood[m] = normal_lpdf(Y[m,n] | normal_rng(tank_u,tank_s),abs(g_tank_noise));
    }}
}
