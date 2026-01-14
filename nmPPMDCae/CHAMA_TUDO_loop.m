
clear all;close all;clc;





pars.variancia = 0.05;
pars.tolerancia = 5e-04;
pars.penal = 'atan';
pars.iter_max=200;


pars.xi=0.05;
pars.lambda0=0.9;
pars.tau=0.15;


pars.nmbdca = 50;

imgFile1  = 'checkerboard.png';

mu_fista=0.09;
mu_dca=5;
mu_indca=5;
mu_nmbdca=5;


rep=1;

var=7;
result_fista=zeros(rep,var);
result_dca=zeros(rep,var);
result_nmbdca=zeros(rep,var);
vetor_opt_total_fista=[];
vetor_opt_total_dca=[];
vetor_opt_total_nmbdca=[];

for loop=1:rep
    pars.loop=loop;
    [img]=dados_imagem(imgFile1,pars);
    [out_fista,erro_fista,iteracoes_fista,vetor_fopt_fista]=FISTA_TUDO(img,mu_fista,pars);
    [out_dca,erro_dca,iteracoes_dca,vetor_fopt_dca]=DCA_IMAGEM(img,mu_dca,pars);
    [out_nmbdca,erro_nmbdca,iteracoes_nmbdca,vetor_fopt_nmbdca]=nmBDCA_IMAGEM(img,mu_nmbdca,pars);



    result_fista(loop,1)=out_fista.psnr;
    result_fista(loop,2)=out_fista.ssim;
    result_fista(loop,4)=iteracoes_fista(end);
    result_fista(loop,7)=out_fista.cpu;


    result_dca(loop,1)=out_dca.psnr;
    result_dca(loop,2)=out_dca.ssim;
    result_dca(loop,4)=iteracoes_dca(end);
    result_dca(loop,7)=out_dca.cpu;


    result_nmbdca(loop,1)=out_nmbdca.psnr;
    result_nmbdca(loop,2)=out_nmbdca.ssim;
    result_nmbdca(loop,4)=iteracoes_nmbdca(end);
    result_nmbdca(loop,7)=out_nmbdca.cpu;

fprintf(1,' EXECU��O
end


fprintf(1,' \n');
fprintf(1,' RESULTADOS DO FISTA \n');
fprintf(1,'psnr =
fprintf(1,'ssim =
fprintf(1,'iteracoes =
fprintf(1,'Execu��o(s) =
fprintf(1,' \n');

fprintf(1,' \n');
fprintf(1,' RESULTADOS DO DCA \n');
fprintf(1,'psnr =
fprintf(1,'ssim =
fprintf(1,'iteracoes =
fprintf(1,'Execu��o(s) =
fprintf(1,' \n');

fprintf(1,' \n');
fprintf(1,' RESULTADOS DO nmBDCA \n');
fprintf(1,'psnr =
fprintf(1,'ssim =
fprintf(1,'iteracoes =
fprintf(1,'Execu��o(s) =
fprintf(1,' \n');



figure;
colormap gray;
imshow(img.imgFile,'Border','tight');

figure;
colormap gray;
imshow(img.ruidosa,'Border','tight');

figure;
colormap gray;
imshow(out_fista.sol,'Border','tight');

figure;
colormap gray;
imshow(out_dca.sol,'Border','tight');

figure;
colormap gray;
imshow(out_nmbdca.sol,'Border','tight');





