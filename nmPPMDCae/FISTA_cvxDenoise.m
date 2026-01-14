
function [xkk,iter,fun_all,erro] = FISTA_cvxDenoise(csi,pars)

lambda_tvfista        = pars.lambda;
lower                 = -Inf;
upper                 = Inf;
pars.lambda=lambda_tvfista;
pars_tvfista.MAXITER  = 30000;
pars_tvfista.epsilon  = 5e-20;

pars_tvfista.tv       = 'iso';
pars_tvfista.print    = 0;



csi   = reshape(csi,pars.mmat,pars.nmat,pars.smat);
[x_atual,iter,fun_all,pars.erro]= FISTA_fgp_denoise_bound(csi,lambda_tvfista,lower,upper,pars_tvfista);
xkk = reshape(x_atual,pars.n,pars.smat);
erro=pars.erro;
return
