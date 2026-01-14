function valores = mu_scan_nmPPMDC(imgFile, pars)



    mus = 0.1:0.01:2;
    N = numel(mus);
    valores = zeros(N,5);

    for i = 1:N
        mu = mus(i);
        [img] = dados_imagem(imgFile, pars);
        t0 = tic;
        [out, ~, ~, ~] = nmPPMDC_IMAGEM(img, mu, pars);
        elapsed = toc(t0);
        valores(i,1) = i;
        valores(i,2) = mu;
        valores(i,3) = out.psnr;
        valores(i,4) = out.ssim;
        valores(i,5) = elapsed;
        fprintf(1,'nmPPMDC (extrap) mu =
            mu, out.psnr, out.ssim, elapsed);
    end


    figure; hold on; grid on;
    plot(valores(:,2), valores(:,3), 'r-', 'LineWidth', 1.5);
    xlabel('\mu'); ylabel('PSNR'); title('nmPPMDC (extrap) PSNR vs \mu');

    figure; hold on; grid on;
    plot(valores(:,2), valores(:,4), 'b-', 'LineWidth', 1.5);
    xlabel('\mu'); ylabel('SSIM'); title('nmPPMDC (extrap) SSIM vs \mu');
end






