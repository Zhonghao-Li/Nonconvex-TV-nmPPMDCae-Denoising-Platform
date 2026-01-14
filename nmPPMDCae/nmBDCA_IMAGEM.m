function [out,erro,iteracoes,vetor_fopt]=nmBDCA_IMAGEM(img,mu,pars)
x0=img.ruidosa;
maximo = img.maximo;
minimo = img.minimo;


rho   = 1;
pars.mu     = mu;
pars.rho    = rho;


[m, n, s]   = size(x0);
pars.nmat   = n;
pars.mmat   = m;
pars.smat   = s;
pars.n      = m*n*s;
pars.b      = reshape(x0,m*n*s,1);
clear   x0


stab = pars.penal;


pars.phiType = stab;
p = 4;
[pars.phi,pars.philin,pars.Mphi]=setPenFunc(pars.phiType,p);


pars.smooth    = @(t) t;
pars.smoothlin = @(t) 1;


pars.lambda = pars.Mphi/(pars.mu+pars.rho);

tolDCA = pars.tolerancia;


maxiter=pars.iter_max;


xk=pars.b;
out.fopt  = inf;
k = 0;
vetor_fopt= [];
iteracoes = [];
erro=[];


xi=pars.xi;
lambda0=pars.lambda0;
tau=pars.tau;


nmbdca=pars.nmbdca;
tempo0=tic;

while (k < maxiter)
    k=k+1;
    [fxk,sub_h] = calculo(xk,pars);
    csi=pars.b+(sub_h)/(pars.mu+pars.rho);
    [yn] = DCA_cvxDenoise(csi,pars);


    dk=yn-xk;
    vk=(nmbdca*norm(dk)^2)/k;
    lambda=lambda0;
    [f1,~] = calculo(yn+lambda.*dk,pars);
    [f2,~] = calculo(yn,pars);
    while (f1-f2+tau*(lambda*norm(dk))^2-vk>0)
        lambda=xi*lambda;
      [f1,~] = calculo(yn+lambda.*dk,pars);
    end
    x_atual=yn+lambda.*dk;


    [fxk_atual,~] = calculo(x_atual,pars);
    stoprule = norm(x_atual-xk,2)/norm(x_atual,2);
    xk = x_atual;





    vetor_fopt(k)=fxk;
    iteracoes(k)=k;
    erro(k)= stoprule;
    if stoprule<=tolDCA,break,end
end
out.cpu = toc(tempo0);


vetor_fopt=[vetor_fopt fxk_atual];
out.fopt = fxk_atual;


x0 = imread(img.imgFile);
out.sol = reshape(xk,m,n,s);


out.psnr = psnr(uint8(out.sol*(maximo-minimo)+minimo),x0,(maximo-minimo));
out.ssim = ssim(uint8(out.sol*(maximo-minimo)+minimo),x0);
