
clc;clear all;close all;


pars.variancia = 0.1;
pars.tolerancia = 5e-4;
pars.penal = 'atan';
pars.iter_max=200;


pars.xi=0.05;
pars.lambda0=0.9;
pars.tau=0.15;


pars.nmbdca = 50;




imgFile1  = 'text.jpg';






[img]=dados_imagem(imgFile1,pars);


[fista]=mu_otimoFISTA(img,pars);

xlswrite('fista_img1.xlsx',fista);

[dca]=mu_otimoDCA(img,pars);

xlswrite('dca_img1.xlsx',dca);

[nmbdca]=mu_otimo_nmBDCA(img,pars);

xlswrite('nmbdca_img1.xlsx',nmbdca);

fista=xlsread('fista_img1.xlsx');
dca=xlsread('dca_img1.xlsx');
nmbdca=xlsread('nmbdca_img1.xlsx');



figure;
hold on
plot(fista(:,2),fista(:,3),'b-','LineWidth',1);
plot(dca(:,2),dca(:,3),'k--','LineWidth',2);
plot(nmbdca(:,2),nmbdca(:,3),'r-','LineWidth',1);
legend({'FISTA','DCA','nmBDCA'}, 'Location', 'best', 'Orientation', 'vertical');
ylabel('PSNR','FontSize',16);
xlabel('\mu','FontSize',16);
grid on
xlim([min(nmbdca(:,2)) max(nmbdca(:,2))]);
hold off


figure;
hold on
plot(fista(:,2),fista(:,4),'b-','LineWidth',1);
plot(dca(:,2),dca(:,4),'k--','LineWidth',2);
plot(nmbdca(:,2),nmbdca(:,4),'r-','LineWidth',1);
legend({'FISTA','DCA','nmBDCA'}, 'Location', 'best', 'Orientation', 'vertical');
ylabel('SSIM','FontSize',16);
xlabel('\mu','FontSize',16);
grid on
xlim([min(nmbdca(:,2)) max(nmbdca(:,2))]);
hold off

