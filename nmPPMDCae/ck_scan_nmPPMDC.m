function valores = ck_scan_nmPPMDC(img, mu, pars)








    cks = (0.1:0.01:0.99) / mu;
    N = numel(cks);
    valores = zeros(N,5);

    for i = 1:N
        ck = cks(i);
        pars.ck = ck;
        t0 = tic;
        [out, ~, ~, ~] = nmPPMDC_IMAGEM(img, mu, pars);
        elapsed = toc(t0);
        valores(i,1) = i;
        valores(i,2) = ck;
        valores(i,3) = out.psnr;
        valores(i,4) = out.ssim;
        valores(i,5) = elapsed;
        fprintf(1,'nmPPMDC (extrap) ck =
            ck, mu, out.psnr, out.ssim, elapsed);
    end


    figure; hold on; grid on;
    plot(valores(:,2), valores(:,3), 'm-', 'LineWidth', 1.5);
    xlabel('c_k'); ylabel('PSNR'); title(sprintf('nmPPMDC (extrap) PSNR vs c_k (mu=

    figure; hold on; grid on;
    plot(valores(:,2), valores(:,4), 'g-', 'LineWidth', 1.5);
    xlabel('c_k'); ylabel('SSIM'); title(sprintf('nmPPMDC (extrap) SSIM vs c_k (mu=
end



