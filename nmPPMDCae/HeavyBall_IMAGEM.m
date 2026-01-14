function [out,erro,iteracoes,vetor_fopt]=HeavyBall_IMAGEM(img,mu,pars)

























    x0=img.ruidosa; maximo = img.maximo; minimo = img.minimo;


    [m, n, s] = size(x0);
    pars.nmat = n; pars.mmat = m; pars.smat = s; pars.n = m*n*s;
    pars.b = reshape(x0,m*n*s,1);


    pars.mu = mu;
    if ~isfield(pars,'tau'); pars.tau = 0.1; end
    if ~isfield(pars,'alpha'); pars.alpha = 0.1; end
    if ~isfield(pars,'beta'); pars.beta = 0.9; end


    tol = pars.tolerancia; maxiter = pars.iter_max;


    xk = pars.b;
    vk = zeros(size(xk));
    k = 0;

    vetor_fopt = []; iteracoes = []; erro = [];

    tempo0 = tic;

    while (k < maxiter)
        k = k + 1;






        grad_data = pars.mu * (xk - pars.b);


        grad_tv = compute_tv_gradient(xk, pars);


        gk = grad_data + pars.tau * grad_tv;



        vk_new = pars.beta * vk - pars.alpha * gk;


        xk_new = xk + vk_new;


        xk_new = max(0, min(1, xk_new));


        fxk = compute_objective(xk, pars);


        stoprule = norm(xk_new - xk, 2) / max(1e-12, norm(xk, 2));


        vk = vk_new;
        xk = xk_new;


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

function grad_tv = compute_tv_gradient(x, pars)



    m = pars.mmat; n = pars.nmat; s = pars.smat;
    X = reshape(x, m, n, s);

    epsilon = 1e-8;

    grad_tv = zeros(m, n, s);

    for c = 1:s
        Xc = X(:,:,c);


        Dx = [diff(Xc, 1, 1); zeros(1, n)];
        Dy = [diff(Xc, 1, 2), zeros(m, 1)];


        denom = sqrt(Dx.^2 + Dy.^2 + epsilon^2);



        grad_x = Dx ./ denom;
        grad_y = Dy ./ denom;


        div_x = [grad_x(1,:); diff(grad_x, 1, 1)];
        div_y = [grad_y(:,1), diff(grad_y, 1, 2)];

        grad_tv(:,:,c) = -(div_x + div_y);
    end

    grad_tv = reshape(grad_tv, m*n*s, 1);
end

function f = compute_objective(x, pars)




    data_term = (pars.mu/2) * norm(x - pars.b, 2)^2;


    m = pars.mmat; n = pars.nmat; s = pars.smat;
    X = reshape(x, m, n, s);

    tv_val = 0;
    epsilon = 1e-8;

    for c = 1:s
        Xc = X(:,:,c);
        Dx = [diff(Xc, 1, 1); zeros(1, n)];
        Dy = [diff(Xc, 1, 2), zeros(m, 1)];
        tv_val = tv_val + sum(sqrt(Dx(:).^2 + Dy(:).^2 + epsilon^2));
    end

    f = data_term + pars.tau * tv_val;
end














