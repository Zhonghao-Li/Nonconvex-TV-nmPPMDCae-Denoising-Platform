function [phi,philin,Mphi]=setPenFunc(phiType,p)


if strcmp(phiType,'linear')
    phi    = @(t) t;
    philin = @(t) 1;
elseif strcmp(phiType,'log')
    phi    = @(t) log(1+p*t)/p;
    philin = @(t) 1/(1 +p*t);
elseif strcmp(phiType,'rat')
    phi    = @(t) t/(1+p*t/2);
    philin = @(t) 1/(1 +p*t/2)^2;
elseif strcmp(phiType,'atan')
    phi    = @(t) (2*atan((1+p*t)/sqrt(3))-(pi/6))/(p*sqrt(3)/2);
    philin = @(t) 1/(1 + p*t + (p*t)^2);
elseif strcmp(phiType,'exp')
    phi    = @(t) (1 - exp(-p*t))/p;
    philin = @(t) exp(-p*t);
end

Mphi   = philin(0);
end