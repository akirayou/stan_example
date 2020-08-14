<%
param_arg=','.join([ "real "+p["name"] for p in param])
param_arg_pass=','.join([p["name"] for p in param])
%>
data{
    int N;
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
model{
% for p in param:
% if p["prio"] in ("normal" ,"cauchy","logistic","lognormal","Weibull"):
    ${p["name"]} ~ ${p["prio"]}(${p["name"]}_u,${p["name"]}_s);
%endif
%endfor
    Y ~ normal(mu,sigma);
}
