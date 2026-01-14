
clear all; close all; clc;


pars.variancia = 0.05;
pars.tolerancia = 5e-04;
pars.penal = 'atan';
pars.iter_max = 200;


imgFile1  = 'checkerboard.png';
mu_dca    = 5;


[img] = dados_imagem(imgFile1, pars);
[out, erro, iteracoes, vetor_fopt] = DCA_IMAGEM(img, mu_dca, pars);


fprintf('\nRESULT (DCA)\n');
fprintf('PSNR =
fprintf('SSIM =
fprintf('Iter =
fprintf('Time(s) =


figure; colormap gray; imshow(img.imgFile,'Border','tight'); title('Original');
figure; colormap gray; imshow(img.ruidosa,'Border','tight'); title('Noisy');
figure; colormap gray; imshow(out.sol,'Border','tight');
title(sprintf('DCA    PSNR=


