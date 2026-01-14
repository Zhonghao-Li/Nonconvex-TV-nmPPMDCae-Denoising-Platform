
clear all; close all; clc;


pars.variancia = 0.05;
pars.tolerancia = 5e-04;
pars.penal = 'atan';
pars.iter_max = 200;


pars.xi      = 0.05;
pars.lambda0 = 0.9;
pars.tau     = 0.15;
pars.nmbdca  = 50;


imgFile1  = 'checkerboard.png';
mu_nmbdca = 5;


[img] = dados_imagem(imgFile1, pars);
[out, erro, iteracoes, vetor_fopt] = nmBDCA_IMAGEM(img, mu_nmbdca, pars);


fprintf('\nRESULT (nmBDCA)\n');
fprintf('PSNR =
fprintf('SSIM =
fprintf('Iter =
fprintf('Time(s) =


figure; colormap gray; imshow(img.imgFile,'Border','tight'); title('Original');
figure; colormap gray; imshow(img.ruidosa,'Border','tight'); title('Noisy');
figure; colormap gray; imshow(out.sol,'Border','tight');
title(sprintf('nmBDCA  PSNR=


