function [out,erro,iteracoes,vetor_fopt]=PPMDC_IMAGEM(img,mu,pars)


























    x0=img.ruidosa; maximo = img.maximo; minimo = img.minimo;


    [m, n, s] = size(x0);
    pars.nmat = n; pars.mmat = m; pars.smat = s; pars.n = m*n*s;
    pars.b    = reshape(x0,m*n*s,1);


    pars.phiType = pars.penal; p = 4;
    [pars.phi,pars.philin,pars.Mphi]=setPenFunc(pars.phiType,p);
    pars.smooth    = @(t) t; pars.smoothlin = @(t) 1;


    pars.mu = mu;
    if ~isfield(pars,'tau_dc'); pars.tau_dc = max(1,pars.Mphi); end


    if ~isfield(pars,'lambda_k') || isempty(pars.lambda_k)

        lambda_k = 1.0;
    else
        lambda_k = pars.lambda_k;
    end


    tol = pars.tolerancia; maxiter = pars.iter_max;


    xk = pars.b; k = 0; out.fopt = inf;
    vetor_fopt = []; iteracoes = []; erro = [];

    tempo0 = tic;
    while (k < maxiter)
        k = k + 1;


        if length(lambda_k) > 1
            lam_k = lambda_k(min(k, length(lambda_k)));
        else
            lam_k = lambda_k;
        end


        [fxk, wk] = calculo_mod(xk, pars);


        yk = xk + lam_k * wk;









        weight = mu + 1/lam_k;
        s_eff = (mu * pars.b + (1/lam_k) * yk) / weight;
        pars.lambda = pars.tau_dc / weight;

        [x_new] = DCA_cvxDenoise(s_eff, pars);


        stoprule = norm(x_new - xk, 2) / max(1e-12, norm(x_new, 2));


        xk = x_new;


        vetor_fopt(k) = fxk;
        iteracoes(k) = k;
        erro(k) = stoprule;


        if stoprule <= tol
            break;
        end
    end

    out.cpu = toc(tempo0);
    out.fopt = fxk;


    x0_img = imread(img.imgFile);
    out.sol = reshape(xk, m, n, s);
    out.psnr = psnr(uint8(out.sol*(maximo-minimo)+minimo), x0_img, (maximo-minimo));
    out.ssim = ssim(uint8(out.sol*(maximo-minimo)+minimo), x0_img);
    out.iter_total = k;
end


