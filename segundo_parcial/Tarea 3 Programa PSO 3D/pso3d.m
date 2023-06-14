clear all
close all

funObj = @ (xi) 3*(1-xi(1))^2*exp(-(xi(1)^2)-(xi(2)+1)^2)-10*(xi(1)/5-xi(1)^3-xi(2)^5) *exp(-xi(1)^2-xi(2)^2)-1/3*exp(-(xi(1)+1)^2-xi(2)^2);

N=10;
d=2;
lb=[-3 -3];
ub = [3 3];
k=0;
kmax=100;
c1=2;
c2=2;
for i = 1:N
    x(i,:)=rand(1,d).*(ub-lb)+lb;
    v(i,:)=zeros(1,d);
end

for i=1:N
    xi=x(i,:);
    fx(i,:)=funObj(xi);
end

[gfit,ind] = min(fx);
g=x(ind,:);
fp=fx;
p=x;

axisx=linspace(min(lb),max(ub),50);
axisy=axisx;
axisz=[];

for i= 1:length(axisx)
    for j=1:length(axisy)
        axisz(i,j)=funObj([axisx(1),axisy(j)]);
    end
end

[axisy axisx] = meshgrid(axisx,axisy);

while k <kmax
    k=k+1;
    figure(1);
    surf(axisx,axisy,axisz)
    hold on;
    plot3(x(:,1),x(:,2),fx+0.1,'o','MarkerFaceColor','m',"MarkerSize",7)
    plot3(p(:,1),p(:,2),fp+0.1,'o',"MarkerFaceColor","g","MarkerSize",7)
    pause(0.1)
    hold off
    figure(2)
    contour(axisx,axisy,axisz,20)
    hold on
    plot(x(:,1),x(:,2),'o',"MarkerFaceColor",'m');
    plot(p(:,1),p(:,2),'o',"MarkerFaceColor",'g');
    pause(0.3)
    hold off

    for i= 1:N
        xi=x(1,:);
        pi=p(1,:);
        v(i,:)=v(i,:)+c1*rand(1,d).*(pi-xi)+c2*rand(1,d).*(g-xi);
    end
    x=x+v;
    for i=1:N
        for j=1:d
            if x(i,j)<lb(j)
                x(i,j)=lb(j);
            elseif x(i,j)>ub(j)
                x(i,j)=ub(j);
            end
        end
    end

    for i=1:N
        xi=x(i,:);
        fx(i,:)=funObj(xi);
    end
    [gfitkplus1, ind]=min(fx);
    if gfitkplus1 < gfit
        gfit=gfitkplus1;
        g=x(ind,:);
    end

    for i=1:N
        if fx(i,:)<fp(i,:)
            fp(i,:)=fx(i,:);
            p(i,:)=x(i,:);
        end
    end
    Evolution(k)=gfit;
end
figure
plot(Evolution)

disp(["the best solution : ",num2str(g)])
disp(["the best fitness : ",num2str(gfit)])
