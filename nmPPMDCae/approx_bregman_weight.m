function [ck_eff, Hinfo] = approx_bregman_weight(xk, pars)





















    base_ck = pars.ck;
    alpha = 1.0;
    if isfield(pars,'abreg') && isfield(pars.abreg,'type') && strcmpi(pars.abreg.type,'approx')
        if isfield(pars.abreg,'alpha') && ~isempty(pars.abreg.alpha)
            alpha = max(0, double(pars.abreg.alpha));
        else
            alpha = 1.0;
        end
    end
    ck_eff = base_ck * alpha;
    Hinfo = struct('alpha', alpha);
end







