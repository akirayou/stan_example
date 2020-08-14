<%
param_arg=','.join([ "real "+p["name"] for p in param])
param_arg_pass=','.join([p["name"] for p in param])
%>
functions{
    vector func(int N,vector x,${param_arg}){
        ${func}
    }
}
data{
    int N;
    vector[N] X;
    vector[N] Y;
% for p in param:
<%
ps=[]
if(p["prio"] in ("normal" ,"cauchy","logistic","lognormal","Weibull")):ps=["u","s"]
%>
% for s in ps: 
    real ${p["name"]}_${s};
% endfor
% endfor
}

parameters{
% for p in param:
    real${p["opt"]} ${p["name"]};
% endfor
}
transformed parameters{
    vector[N] yy;
    yy=func(N,X,${param_arg_pass});
}

model{
% for p in param:
% if p["prio"] in ("normal" ,"cauchy","logistic","lognormal","Weibull"):
    ${p["name"]} ~ ${p["prio"]}(${p["name"]}_u,${p["name"]}_s);
%endif
%endfor
    Y ~ normal(yy,sigma);
}
