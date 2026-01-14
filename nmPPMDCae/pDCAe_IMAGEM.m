function [out,erro,iteracoes,vetor_fopt]=pDCAe_IMAGEM(img,mu,pars)


















































    x0=img.ruidosa; maximo = img.maximo; minimo = img.minimo;

    [m, n, s] = size(x0);
    pars.nmat = n; pars.mmat = m; pars.smat = s; pars.n = m*n*s;
    pars.b    = reshape(x0,m*n*s,1);


    pars.phiType = pars.penal;
    p = 4;
    [pars.phi,pars.philin,pars.Mphi]=setPenFunc(pars.phiType,p);


    pars.smooth    = @(t) t;
    pars.smoothlin = @(t) 1;


    pars.mu = mu;

    if isfield(pars,'Lscale') && pars.Lscale > 0
        L = pars.Lscale * mu;
    else
        L = 2*mu;
    end


    tol = pars.tolerancia;
    maxiter = pars.iter_max;


    use_extrap = false;
    use_adaptive_restart = true;
    if isfield(pars,'extrap')
        if isfield(pars.extrap,'enable')
            use_extrap = pars.extrap.enable;
        end
        if isfield(pars.extrap,'use_adaptive_restart')
            use_adaptive_restart = pars.extrap.use_adaptive_restart;
        end
    end


    xk = pars.b;
    xk_prev = xk;
    xk_prev2 = xk;


    theta_k = 1;
    theta_kp1 = 1;


    vetor_fopt = [];
    iteracoes = [];
    erro = [];
    out.fopt = inf;


    restart_count = 0;
    extrap_used = 0;

    tempo0 = tic;
    k = 0;

    while (k < maxiter)
        k = k + 1;




        if use_extrap && k > 1

            beta_k = (theta_k - 1) / theta_kp1;


            yk = xk + beta_k * (xk - xk_prev);




            if use_adaptive_restart && k > 2
                restart_val = (xk_prev - xk)' * (xk - xk_prev2);

                if restart_val > 0

                    theta_k = 1;
                    theta_kp1 = 1;
                    beta_k = 0;
                    yk = xk;
                    restart_count = restart_count + 1;
                else

                    if beta_k > 0
                        extrap_used = extrap_used + 1;
                    end
                end
            else

                if beta_k > 0
                    extrap_used = extrap_used + 1;
                end
            end
        else

            yk = xk;
            beta_k = 0;
        end








        [~, dtv_xk, ~, dnctv_xk, ~] = suave_TV(xk, pars);
        xi_k = dtv_xk - dnctv_xk;





        grad_f_yk = mu * (yk - pars.b);



        s_prox = yk - (1/L) * (grad_f_yk - xi_k);



        pars.lambda = 1.0 / L;



        addpath(fullfile(fileparts(mfilename('fullpath')), 'solvers'));
        [x_atual] = DCA_cvxDenoise(s_prox, pars);




        stoprule = norm(x_atual - xk, 2) / max(1e-12, norm(x_atual, 2));



        [~, ~, nctv, ~, ~] = suave_TV(x_atual, pars);
        fxk = 0.5 * mu * norm(x_atual - pars.b)^2 + nctv;


        xk_prev2 = xk_prev;
        xk_prev = xk;
        xk = x_atual;


        theta_k = theta_kp1;
        theta_kp1 = 0.5 * (1 + sqrt(1 + 4 * theta_k^2));


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
    out.restart_count = restart_count;
    out.extrap_used = extrap_used;
    out.extrap_ratio = extrap_used / max(1, k-1);
end
