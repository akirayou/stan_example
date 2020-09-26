
functions{
    vector gauss(vector x,real u,real s){
        return exp(-square( (x-u)/s));
    }
}
data{
    int N;
    int M;
    vector[N] X;
    vector[N] Y;
    vector[M] u_u;
    vector[M] u_s;
    vector[M] s_u;
    vector[M] s_s;
    real sigma_s;
    vector[M] A_u;
    vector[M] A_s;
    real T_beta;
}

parameters{
    real<lower=0> sigma;
    vector<lower=0>[M] A;
    ordered[M] u;
    vector<lower=0>[M] s;
}
transformed parameters{
    vector[N] yy;
    vector[N] yyN[M];   
    yy=rep_vector(0,N);
    for( m in 1:M){
        yyN[m] = gauss(X,u[m],s[m]);
        yy+=A[m]* yyN[m];
    }
}

model{
    u ~ normal(u_u,u_s);
    s ~ normal(s_u,s_s);
    A ~ normal(A_u,A_s);
    sigma ~ normal(sigma_s,sigma_s);
    target += T_beta*normal_lpdf(Y|yy,sigma);
}
