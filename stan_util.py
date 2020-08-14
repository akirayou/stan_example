# -*- coding: utf-8 -*-
"""
stan model cach
@author: akira_you
"""
import os
import math
import itertools
import numpy as np

def print_code(model,line_no=True):
    if(line_no):    
        for i,s in enumerate(model.model_code.split("\n")):
            print(i+1,s)
    else:
        print(model.model_code)

def _HASH_SALT():
    return "kokoniha tekitouna moji ga hairu yo"
import pystan
import pickle
import hashlib
from mako.template import Template
import lzma

def _str_for_hash(d):
    salt=_HASH_SALT()
    if(hasattr(d,"str_for_hash")):
        return salt+d.str_for_hash()
    if(isinstance(d,dict)):
        return salt+str(tuple(sorted(d.items())))    
    return salt+str(d)

def _hash_str(d):
    return hashlib.sha256(_str_for_hash(d).encode()).hexdigest()

def _hash_str_len():
    return 256//4



def get_stan_model(name,template_param=None,
                   model_path="./models",src_path="./",
                   strip_code=False,auto_build=True):
    """"
    Automatic build and cache the stan model.
    
    Put stan source file in
    to src_path directory. 
    This function will put pickled (build) stan model into models directory.
    You have to copy this direcotry when you deploy it.
    
    
    Args:
        str name: base file name of this model file  model_path/name.pickle is 
            compiled stan file, src_path/name.stan is inputfile
        dict template_param:if you set this paramter name.stan is proceessed by
            mako template engine
        model_path: pickled model direcotry path
        src_path:   stan src directory path
        code_split: if you do not want to share your code. you can hide this
    """ 
    os.makedirs(model_path, exist_ok=True)
    src_file=os.path.join(src_path,name+".stan")
    if template_param is None:
        param_hash=_hash_str("") #Dummy hash
        stan_code=open(src_file).read()
        model_file=os.path.join(model_path,name+".pickle_xz")
    else:
        mytemplate = Template(filename=src_file,input_encoding='utf-8')
        param_hash=_hash_str(template_param)
        stan_code=mytemplate.render(**template_param)
        model_file=os.path.join(model_path,name+"_"+param_hash+".pickle_xz")
    code_hash=_hash_str(stan_code)
   
    model=None
    if os.path.exists(model_file):
        with lzma.open(model_file, 'rb') as f:
            h=f.read(_hash_str_len()).decode()
            if h == code_hash:
                model=pickle.load(f)
    
    if model is None and auto_build:
        if stan_code is None: stan_code=open(src_file).read()
        model=pystan.StanModel(model_code=stan_code,model_name=name )
        if strip_code:
            model.code=""  #older version stan
            model.cpp_code="" #older version stan
            model.model_code=""
            model.model_cpp_code=""
            model.model_include_paths=""
        with lzma.open(model_file, 'wb') as f:
            f.write(code_hash.encode())
            pickle.dump(model,f)
    
    #return None when can not get the model
    return model

if __name__ == '__main__':  
    #import stan_util
    param=[{"name":"a","opt":""},
           {"name":"b","opt":"<lower=0>"},
           ]
    d={"param":param,"func":"a*x + b"}
    model=get_stan_model("model",d)
    import numpy as np
    N=10
    X=np.linspace(0,1,N)
    Y=np.random.rand(N)
    stan_data={
            "N":N,
            "X":X,
            "Y":Y,
            "a_u":0,"a_s":10,
            "b_u":0,"b_s":10,            
            }
    
    fit=model.sampling(data=stan_data,iter=400,chains=4)
    print(fit)


