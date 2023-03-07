clearvars;
clc;
syms x y;
F = x * exp(-x^2-y^2);
lambda = 0.1;   
X = [0.6,0.6];% [1;1] crea matriz de 1x2 / punto de partida

Vf = inline([diff(F,x),diff(F,y)]);

disp(Vf)
for i = 1:100
    X = X - lambda*Vf(X(1),X(2));
    A(i,1) = X(1);
    A(i,2) = X(2);
    A(i,3) = X(1) * exp(-X(1)^2-X(2)^2);
    x = linspace(-2,2,20); %area a graficar
    y = x';
    z = x.*exp(-x.^2-y.^2);
    figure(1);
    surf(x,y,z);
    hold on;
    %3 argmentos x,y y z, 'simbolo',color,r,marcador,,coloe,tamaño de la
    %esfera
    plot3(X(1),X(2),A(i,3),'o','Color','r','MarkerFaceColor','blue','MarkerSize',5);
    pause(0.8);
end 