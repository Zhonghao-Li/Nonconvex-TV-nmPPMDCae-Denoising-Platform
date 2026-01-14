function [fxk,subh] = calculo(xk,pars)
    [tv, dtv, nctv, dnctv, Mphi] = suave_TV(xk,pars);
    mu  = pars.mu;
    rho = pars.rho;


    g = 0.5*(mu+rho)*norm(xk-pars.b)^2 + Mphi*tv;
    h = 0.5*(rho)*norm(xk-pars.b)^2 + Mphi*tv - nctv;
    subh = (rho)*(xk-pars.b) + Mphi*dtv - dnctv;
    fxk=g-h;

return