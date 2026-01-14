function [out,erro,iteracoes,vetor_fopt]=FISTA_TUDO(img,mu,pars)
x0=img.ruidosa;
maximo = img.maximo;
minimo = img.minimo;


[m, n, s]   = size(x0);
pars.nmat   = n;
pars.mmat   = m;
pars.smat   = s;
pars.n      = m*n*s;
pars.b      = reshape(x0,m*n*s,1);
clear   x0

pars.lambda=mu;


out.fopt  = inf;


smin=pars.b;
tempo0=tic;
[x_atual,iteracoes,vetor_fopt,erro] = FISTA_cvxDenoise(smin,pars);
out.cpu = toc(tempo0);

out.sol = x_atual;
out.fopt = vetor_fopt(end);

x0 = imread(img.imgFile);
out.sol = reshape(x_atual,m,n,s);


out.psnr = psnr(uint8(out.sol*(maximo-minimo)+minimo),x0,(maximo-minimo));
out.ssim = ssim(uint8(out.sol*(maximo-minimo)+minimo),x0);
end