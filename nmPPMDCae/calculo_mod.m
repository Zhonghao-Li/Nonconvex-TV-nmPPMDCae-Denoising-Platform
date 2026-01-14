function [fxk, subh] = calculo_mod(xk, pars)




    mu      = pars.mu;

    if isfield(pars,'tau_dc') && ~isempty(pars.tau_dc)
        tau_dc = pars.tau_dc;
    else
        tau_dc = max(1, pars.Mphi);
    end

    [tv, dtv, nctv, dnctv, ~] = suave_TV(xk, pars);

    g  = 0.5 * mu * norm(xk - pars.b)^2 + tau_dc * tv;
    h  = tau_dc * tv - nctv;
    subh = tau_dc * dtv - dnctv;
    fxk = g - h;
    return

