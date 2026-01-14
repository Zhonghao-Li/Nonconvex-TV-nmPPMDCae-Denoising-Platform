function [img]=dados_imagem(imagem,pars)
    imgFile=imagem;
    img.imgFile=imgFile;


    img.maximo = max(max(double(imread(imgFile))));
    img.minimo = min(min(double(imread(imgFile))));
    maximo=img.maximo;
    minimo=img.minimo;
    x0 = (double(imread(imgFile))-minimo)/(maximo-minimo);
    sigma2= pars.variancia;


    x0 = x0 + sqrt(sigma2)*randn(size(x0));
    img.ruidosa=x0;
end