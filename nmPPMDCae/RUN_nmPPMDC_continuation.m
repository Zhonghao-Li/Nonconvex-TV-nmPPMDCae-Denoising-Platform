
clear all; close all; clc;


pars.variancia  = 0.1;
pars.tolerancia = 5e-4;
pars.penal      = 'atan';
pars.iter_max   = 200;


pars.xi      = 0.05;
pars.lambda0 = 0.9;
pars.tau     = 0.15;
pars.nmbdca_bar = 100;


pars.tau_dc = [];
pars.ck     = [];


pars.extrap.enable = 1;
pars.extrap.rho    = 0.9;


imgFile  = 'checkerboard.png';
mu_list  = 0.1:0.01:2;


[img] = dados_imagem(imgFile, pars);
[m, n, s] = size(img.ruidosa);


num_mu = numel(mu_list);
vals = cell(num_mu+1, 6);
vals(1,:) = {'mu','PSNR','SSIM','iters','cpu_s','extrap_used'};
iteracoes_all = cell(num_mu,1);
erro_all = cell(num_mu,1);


pars.x0 = [];
x_prev = [];

outDir = fullfile(pwd, 'outputs');
if ~exist(outDir,'dir'), mkdir(outDir); end

for i=1:num_mu
    mu = mu_list(i);

    if ~isempty(x_prev)

        pars.x0 = reshape(x_prev, m*n*s, 1);
    else
        pars.x0 = [];
    end


    [out, erro, iters, ~] = nmPPMDC_IMAGEM_with_x0(img, mu, pars);


    vals{i+1,1} = mu;
    vals{i+1,2} = out.psnr;
    vals{i+1,3} = out.ssim;
    if ~isempty(iters)
        vals{i+1,4} = iters(end);
    else
        vals{i+1,4} = NaN;
    end
    vals{i+1,5} = out.cpu;
    if isfield(out,'extrap_used')
        vals{i+1,6} = out.extrap_used;
    else
        vals{i+1,6} = NaN;
    end
    iteracoes_all{i} = iters;
    erro_all{i} = erro;


    x_prev = out.sol;


    if abs(mu - 0.1) < 1e-9 || abs(mu - 1.0) < 1e-9 || abs(mu - 5.0) < 1e-9 || abs(mu - 10.0) < 1e-9
        imwrite(uint8(out.sol*255), fullfile(outDir, sprintf('nmPPMDC_cont_mu_
    end

    fprintf('mu=
end


try
    writematrix(vals, fullfile(outDir, 'nmPPMDC_mu_continuation.csv'));
catch
    try
        xlswrite(fullfile(outDir, 'nmPPMDC_mu_continuation.xlsx'), vals);
    catch

        save(fullfile(outDir, 'nmPPMDC_mu_continuation.mat'), 'vals', 'iteracoes_all', 'erro_all');
    end
end


mus = cell2mat(vals(2:end,1));
psnrs = cell2mat(vals(2:end,2));
ssims = cell2mat(vals(2:end,3));

figure; plot(mus, psnrs, 'r-', 'LineWidth', 1.5); grid on;
xlabel('\mu'); ylabel('PSNR'); title('nmPPMDC (continuation) PSNR vs \mu');
saveas(gcf, fullfile(outDir, 'nmPPMDC_mu_continuation_PSNR.png'));

figure; plot(mus, ssims, 'b-', 'LineWidth', 1.5); grid on;
xlabel('\mu'); ylabel('SSIM'); title('nmPPMDC (continuation) SSIM vs \mu');
saveas(gcf, fullfile(outDir, 'nmPPMDC_mu_continuation_SSIM.png'));


