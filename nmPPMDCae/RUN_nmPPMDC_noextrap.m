
clear all; close all; clc;


pars.variancia  = 0.05;
pars.tolerancia = 5e-4;
pars.penal      = 'atan';
pars.iter_max   = 200;


pars.xi      = 0.05;
pars.lambda0 = 0.9;
pars.tau     = 0.15;
pars.nmbdca_bar = 100;


imgFile1    = 'checkerboard.png';
mu_nmppm    = 5;


[img] = dados_imagem(imgFile1, pars);
[out, erro, iteracoes, vetor_fopt] = nmPPMDC_IMAGEM_noextrap(img, mu_nmppm, pars);


fprintf('\nRESULT (nmPPMDC - no extrap, c_k=1)\n');
fprintf('PSNR =
fprintf('SSIM =
fprintf('Iter =
fprintf('Time(s) =


figure; colormap gray; imshow(img.imgFile,'Border','tight'); title('Original');
figure; colormap gray; imshow(img.ruidosa,'Border','tight'); title('Noisy');
figure; colormap gray; imshow(out.sol,'Border','tight');
title(sprintf('nmPPMDC (no extrap, c_k=1)  PSNR=




