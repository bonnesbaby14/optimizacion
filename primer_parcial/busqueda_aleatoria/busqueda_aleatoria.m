clearvars;
clear all;
clc;
syms x y;

funstr = '3*(1-X).^2 * exp(-(X.^2)-(Y+1).^2) - 10 *(X./5 - X.^3 -Y.^5).*exp(-X.^2-Y.^2) - 3 * exp(-(X+1).^2- Y.^2)';

f=vectorize(inline(funstr));
range=[-3 3 -3 3];

Ndiv=50;

dx=(range(2)-range(1))/Ndiv;
dy=(range(4)-range(3))/Ndiv;
[X,Y]=meshgrid(range(1):dx:range(2));

Z=f(X,Y);
figure(1);
surfc(X,Y,Z);
NITER=300;
K=0;

%initialization of the candidate soolution
xrange=range(2)-range(1);
yrange=range(4)-range(3);
xn=rand*xrange+range(1);
yn=rand*yrange+range(3);

%X k+1=xk +Ax fitness

%starting point of the optimization process
while (K<NITER)
    if((xn>=range(1)) && (xn<=range(2)) && (yn>=range(3)) && (yn<=range(4)))
        zn1=f(xn,yn);
    else 
%if not, its assigned a low quality
        zn1=-1000;
    end

    figure(2)
    %contour(X,Y,Z,15);hold on;
    surfc(X,Y,Z);
    %plot3(xn,yn,f(xn,yn),".","markersize",10,"markerfacecolor","g");
    plot3(xn,yn,f(xn,yn),'o','Color','r', 'MarkerFaceColor','red','MarkerSize',5)
    drawnow;hold on;
    xnc=xn+randn*1;
    ync=yn+randn*1;
    if((xnc>=range(1)) && (xnc<=range(2)) && (ync>=range(3)) && (ync<=range(4)))
        zn2=f(xnc,ync);
    else
        zn2=-1000;
    end

    if(zn2>zn1)
        xn=xnc;
        yn=ync;   
    end
    K=K+1;
end

