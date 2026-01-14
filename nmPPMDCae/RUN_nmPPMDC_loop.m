
clear all; close all; clc;


pars.variancia  = 0.05;
pars.tolerancia = 5e-4;
pars.penal      = 'atan';
pars.iter_max   = 200;


pars.xi      = 0.05;
pars.lambda0 = 0.9;
pars.tau     = 0.15;
pars.nmbdca_bar = 100;





imgFile1  = 'checkerboard.png';


mu_nmppm = 1.5;


[img] = dados_imagem(imgFile1, pars);
[out_nmppm, erro_nmppm, it_nmppm, fopt_nmppm] = nmPPMDC_IMAGEM(img, mu_nmppm, pars);

fprintf('\nRESULT (nmPPMDC-mod)\n');
fprintf('PSNR =
fprintf('SSIM =
fprintf('Extrapolation used =
fprintf('Total outer iterations =
fprintf('Iter =
fprintf('Time(s) =





figure; colormap gray; imshow(img.imgFile,'Border','tight'); title('Original');
figure; colormap gray; imshow(img.ruidosa,'Border','tight'); title('Noisy');
figure; colormap gray; imshow(out_nmppm.sol,'Border','tight'); title('nmPPMDC-mod');


do_ck_scan = false;
if do_ck_scan

    valores_ck = ck_scan_nmPPMDC(img, mu_nmppm, pars);


    outDir = fullfile(pwd, 'outputs');
    if ~exist(outDir,'dir'), mkdir(outDir); end
    csvPath = fullfile(outDir, sprintf('ck_scan_mu_
    try
        writematrix(valores_ck, csvPath);
    catch
        xlswrite(strrep(csvPath,'.csv','.xlsx'), valores_ck);
    end


    f1 = figure('Visible','off'); grid on; hold on;
    plot(valores_ck(:,2), valores_ck(:,3), 'm-', 'LineWidth', 1.5);
    xlabel('c_k'); ylabel('PSNR'); title(sprintf('nmPPMDC (extrap) PSNR vs c_k (mu=
    saveas(f1, fullfile(outDir, sprintf('ck_scan_mu_
    close(f1);

    f2 = figure('Visible','off'); grid on; hold on;
    plot(valores_ck(:,2), valores_ck(:,4), 'g-', 'LineWidth', 1.5);
    xlabel('c_k'); ylabel('SSIM'); title(sprintf('nmPPMDC (extrap) SSIM vs c_k (mu=
    saveas(f2, fullfile(outDir, sprintf('ck_scan_mu_
    close(f2);
end


