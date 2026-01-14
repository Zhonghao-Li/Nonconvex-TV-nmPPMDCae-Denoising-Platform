function [valores]=mu_otimoDCA(imgFile,pars)
    tam1=0.99;
    tam2=30;
    valores=zeros(2*tam2,6);
    i=1;
    for mu=0.01:0.01:tam1
        [out,erro,iter,fopt]=DCA_IMAGEM(imgFile,mu,pars);
        valores(i,2)=mu;
        valores(i,3)=out.psnr;
        valores(i,4)=out.ssim;
        valores(i,6)=out.cpu;
        i=i+1;
        fprintf(1,'DCA mu =
               mu,100*mu/tam1);
    end
    for mu=1:0.5:tam2
        [out,erro,iter,fopt]=DCA_IMAGEM(imgFile,mu,pars);
        valores(i,2)=mu;
        valores(i,3)=out.psnr;
        valores(i,4)=out.ssim;
        valores(i,6)=out.cpu;
        i=i+1;
        fprintf(1,'DCA mu =
               mu,100*mu/tam2);
    end
end