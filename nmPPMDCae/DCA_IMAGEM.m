function [out,erro,iteracoes,vetor_fopt]=DCA_IMAGEM(img,mu,pars)
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


maxiter=pars.iter_max;



pars.lambda = pars.Mphi/(pars.mu+pars.rho);
tolDCA = pars.tolerancia;
xk=pars.b;


vetor_fopt= [];
iteracoes = [];
erro=[];
out.fopt  = inf;
tempo0=tic;

k = 0;
while (k < maxiter)
    k=k+1;
    [fxk,sub_h] = calculo(xk,pars);
    csi=pars.b+(sub_h)/(pars.mu+pars.rho);
    [x_atual] = DCA_cvxDenoise(csi,pars);

    stoprule = norm(x_atual-xk,2)/norm(x_atual,2);
    [fxk_atual,~] = calculo(x_atual,pars);
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
