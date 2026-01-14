function [tv,dtv,nctv,dnctv,Mphi] = suave_TV(x,pars)

phi    = pars.phi;
philin = pars.philin;
Mphi   = pars.Mphi;
smooth = pars.smooth;
smoothlin = pars.smoothlin;

m    = pars.mmat;
n    = pars.nmat;
tol  = eps;
x    = reshape(x,m,n);
tv   = 0;
nctv = 0;
dtv   = zeros(m,n);
dnctv = dtv;
ep=0;

for i=1:m
    for j=1:n
        aux1=0;aux2=0;aux3=0;
        ant=0;sup=0;cen=0;

        if i<m && j<n
            aux =  sqrt((x(i+1,j)-x(i,j))^2 + (x(i,j+1)-x(i,j))^2+ep);
            tv   = tv   + aux;
            nctv = nctv + phi(smooth(aux));

            cen = (x(i+1,j)-x(i,j)) + (x(i,j+1)-x(i,j));
            aux1=  sqrt((x(i+1,j)-x(i,j))^2 + (x(i,j+1)-x(i,j))^2);
            if aux1>=tol;cen   = -(cen/aux1);end
        end

        if i<m && j>1
           ant = (x(i,j)-x(i,j-1));
           aux2= sqrt((x(i+1,j-1)-x(i,j-1))^2 + (x(i,j)-x(i,j-1))^2);
           if aux2 >= tol;ant = ant/aux2; end
        end

        if i>1 && j<n
           sup = (x(i,j)-x(i-1,j)) ;
           aux3 =sqrt((x(i,j)-x(i-1,j))^2 + (x(i-1,j+1)-x(i-1,j))^2);
           if aux3 >= tol;sup = sup/aux3;end
        end

        dtv(i,j)   = cen + ant + sup ;
        dnctv(i,j) = philin(smooth(aux1))*smoothlin(aux1)*cen + ...
                     philin(smooth(aux2))*smoothlin(aux2)*ant + ...
                     philin(smooth(aux3))*smoothlin(aux3)*sup;
    end
end

dtv   = reshape(dtv,m*n,1);
dnctv = reshape(dnctv,m*n,1);
return