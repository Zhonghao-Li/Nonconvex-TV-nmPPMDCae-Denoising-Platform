
clear all; close all; clc;


pars.variancia = 0.01;
pars.tolerancia = 5e-04;
pars.penal = 'atan';
pars.iter_max = 200;


imgFile1  = 'checkerboard.png';
mu_fista  = 0.09;


[img] = dados_imagem(imgFile1, pars);
[out, erro, iteracoes, vetor_fopt] = FISTA_TUDO(img, mu_fista, pars);


fprintf('\nRESULT (FISTA)\n');
fprintf('PSNR =
fprintf('SSIM =
fprintf('Iter =
fprintf('Time(s) =


figure; colormap gray; imshow(img.imgFile,'Border','tight'); title('Original');
figure; colormap gray; imshow(img.ruidosa,'Border','tight'); title('Noisy');
figure; colormap gray; imshow(out.sol,'Border','tight');
title(sprintf('FISTA  PSNR=


