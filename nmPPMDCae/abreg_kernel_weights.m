function W = abreg_kernel_weights(xvec, pars)














    m = pars.mmat; n = pars.nmat; s = pars.smat;
    x = reshape(xvec, m, n, s);
    if s > 1
        xuse = x(:,:,1);
    else
        xuse = x;
    end

    kernel = 'euclidean';
    if isfield(pars,'abreg') && isfield(pars.abreg,'kernel') && ~isempty(pars.abreg.kernel)
        kernel = lower(string(pars.abreg.kernel)); kernel = char(kernel);
    end

    switch kernel
        case 'euclidean'
            W = ones(m,n);
        case 'lp'

            if ~isfield(pars.abreg,'p') || isempty(pars.abreg.p)
                p = 1.5;
            else
                p = double(pars.abreg.p);
            end
            epsv = 1e-8;
            W = (p-1) * max(abs(xuse), epsv).^(p-2);
        case 'huber'

            if ~isfield(pars.abreg,'delta') || isempty(pars.abreg.delta)
                delta = 1e-3;
            else
                delta = double(pars.abreg.delta);
            end
            W = delta ./ ( (xuse.^2 + delta).^(3/2) );
        otherwise
            W = ones(m,n);
    end
end







