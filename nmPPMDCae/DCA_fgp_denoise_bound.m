function [X_den,iter,fun_all,erro]=DCA_fgp_denoise_bound(Xobs,lambda,l,u,pars)




















































if((l==-Inf)&(u==Inf))
    project=@(x)x;

elseif (isfinite(l)&(u==Inf))
    project=@(x)(((l<x).*x)+(l*(x<=l)));

elseif (isfinite(u)&(l==-Inf))
    project=@(x)(((x<u).*x)+((x>=u)*u));

elseif ((isfinite(u)&isfinite(l))&(l<u))
    project=@(x)(((l<x)&(x<u)).*x)+((x>=u)*u)+(l*(x<=l));

else
    error('lower and upper bound l,u should satisfy l<u');
end


flag=exist('pars');
if (flag&isfield(pars,'MAXITER'))
    MAXITER=pars.MAXITER;
else
    MAXITER=100;
end
if (flag&isfield(pars,'epsilon'))
    epsilon=pars.epsilon;
else
    epsilon=1e-4;
end
if(flag&isfield(pars,'print'))
    prnt=pars.print;
else
    prnt=1;
end
if(flag&isfield(pars,'tv'))
    tv=pars.tv;
else
    tv='iso';
end

[m,n]=size(Xobs);
clear P
P{1}=zeros(m-1,n);
P{2}=zeros(m,n-1);
clear R
R{1}=zeros(m-1,n);
R{2}=zeros(m,n-1);
tk=1;
tkp1=1;
count=0;
i=0;

D=zeros(m,n);
fval=inf;
fun_all=[];
iter=[];
if(prnt)
        fprintf('***********************************\n');
        fprintf('*Solving with FGP/FISTA**\n');
        fprintf('***********************************\n');
        fprintf('#iteration  function-value  relative-difference\n');
        fprintf('---------------------------------------------------------------------------------------\n');
    end
while((i<MAXITER)&(count<5))
    fold=fval;


    i=i+1;


    Dold=D;


    Pold=P;
    tk=tkp1;
    D=project(Xobs-lambda*Lforward(R));
    Q=Ltrans(D);



    passo = 8;
    P{1}=R{1}+1/(passo*lambda)*Q{1};
    P{2}=R{2}+1/(passo*lambda)*Q{2};



    switch tv
        case 'iso'
            A=[P{1};zeros(1,n)].^2+[P{2},zeros(m,1)].^2;
            A=sqrt(max(A,1));
            P{1}=P{1}./A(1:m-1,:);
            P{2}=P{2}./A(:,1:n-1);
        case 'l1'
            P{1}=P{1}./(max(abs(P{1}),1));
            P{2}=P{2}./(max(abs(P{2}),1));
        otherwise
            error('unknown type of total variation. should be iso or l1');
    end



    tkp1=(1+sqrt(1+4*tk^2))/2;

    R{1}=P{1}+(tk-1)/(tkp1)*(P{1}-Pold{1});
    R{2}=P{2}+(tk-1)/tkp1*(P{2}-Pold{2});

    re=norm(D-Dold,'fro')/norm(D,'fro');
    if (re<epsilon)
        count=count+1;
    else
        count=0;
    end

    C=Xobs-lambda*Lforward(P);
    PC=project(C);

    fval=-norm(C-PC,'fro')^2+norm(C,'fro')^2;

    fun_all(i)=fval;
    iter(i)=i;
    err=norm(D-Dold,'fro')/norm(D,'fro');
    erro(i)=err;



    if(prnt)
        fprintf('

        if (fval>fold)
            fprintf('  *\n');
        else
            fprintf('   \n');
        end
    end
end
X_den=D;


end

function X=Lforward(P)

[m2,n2]=size(P{1});
[m1,n1]=size(P{2});

if (n2~=n1+1)
    error('dimensions are not consistent')
end
if(m1~=m2+1)
    error('dimensions are not consistent')
end

m=m2+1;
n=n2;

X=zeros(m,n);
X(1:m-1,:)=P{1};
X(:,1:n-1)=X(:,1:n-1)+P{2};
X(2:m,:)=X(2:m,:)-P{1};
X(:,2:n)=X(:,2:n)-P{2};

end

function P=Ltrans(X)

[m,n]=size(X);

P{1}=X(1:m-1,:)-X(2:m,:);
P{2}=X(:,1:n-1)-X(:,2:n);

end


