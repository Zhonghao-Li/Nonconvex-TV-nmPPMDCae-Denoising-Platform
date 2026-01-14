
function [xkk,iter,fun_all] = DCA_cvxDenoise(s,pars)

lambda_tvfista        = pars.lambda;
lower                 = -Inf;
upper                 = Inf;
pars.lambda=lambda_tvfista;


if isfield(pars,'subproblem_maxiter')
    pars_tvfista.MAXITER = pars.subproblem_maxiter;
else
    pars_tvfista.MAXITER = 6000;
end

pars_tvfista.epsilon  = 1e-4;
pars_tvfista.tv       = 'iso';
pars_tvfista.print    = 0;



s   = reshape(s,pars.mmat,pars.nmat,pars.smat);
[s,iter,fun_all,pars.erro]= DCA_fgp_denoise_bound(s,lambda_tvfista,lower,upper,pars_tvfista);
xkk = reshape(s,pars.n,1);
return
