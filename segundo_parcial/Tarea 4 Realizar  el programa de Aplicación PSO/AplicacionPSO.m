clear all %clear memory
close all %close matlab windows

D = 5000; %Annual demand
C = 5;    %Cost per unit
S = 49;   %Cost for order
P = 0.2;  %Percent storage cost
M = P*C   %Storage cost

funObj = @(xi) D*C + D/xi*S + xi/2*M; %Objective function

N = 5; %Particle number
d = 1; % Dimensions
lb = [400]; %Lower limit of search space
ub = [1200]; %Upper limit of search space

k = 0; %iteration
kmax = 150; %Maximun number of iterations
c1 = 2; %Cognitive constant
c2 = 2; %Social constant

%Initialization of particles and velocity
for i=1:N
    x(i,:) = rand(1,d).*(ub-lb)+lb; %initialization of particles
    v(i,:) = zeros(1,d);            % Velocity initialization
end

%%Evaluation of the initial particles with the objective function
for i=1:N
    xi=x(i,:)   %Extraction of the particle xi
    fx(i,:) = funObj(xi);  %Evaluation of the particle xi
end

%%Record of the best global particle and the best local particles
[gfit, ind] = min(fx); %Fitness of the best global particle
g = x(ind,:); %Location of the best global particle
fp = fx;      %Fitness of the best local particle
p = x;        %Position of the best local particle
axisx = lb:ub; %solution vector
axisy = [];
for i = 1:length(axisx)
    axisy(i) = funObj(axisx(i));
end
%Iterative process
while k < kmax %Stop criterion
k = k+1; %New generation
%%The optimization surface is drawn
figure(1);
%Particles are drawn in red color
plot(x,fx,'o', 'MarkerFaceColor', 'm', 'MarkerSize', 10)
pause(0.3)
%Draw the best local particles in green
plot(p,fp,'o', 'MarkerFaceColor', 'g', 'MarkerSize', 10)
%Pause to allow visualization
pause(0.3)
hold off
%Compute the new velocity for each particle
for i=1:N
    xi = x(i,:); %Extraction of particle xi
    pi = p(i,:); %Extraction of local particle pi
    v(i,:) = v(i,:)+c1*rand(1,d).*(pi-xi)+c2*rand(1,d).*(g-xi); %Determination of the new velocitity for each particle vi
end

%%Determination of the new position of each particle
x=x+v
for i=1:N
    for j=1:d
        if x(i,j) < lb(j)
            x(i,j) = lb(j);
        elseif x(i,j) > ub(j)
            x(i,j) = ub(j);
        end
    end
end

%%Evaluation of the new particle withc the objective function
for i=1:N
    xi = x(i,:);
    fx(i,:) = funObj(xi);
end

%Record of the best global particle and the best local particles
[gfitkplus1,ind] = min(fx);

%if a better solution is found, update the global particle
%fitness = desempeño
if gfitkplus1 < gfit
    %Update the fitness of the best global particle
    gfit = gfitkplus1;
    %Update the position of the best global particle
    g = x(ind,:);
end
for i=1:N
    %update your best local particle
    if fx(i,:)<fp(i,:)
        %Update the fitness of the best local particles
        fp(i,:) = fx(i,:);
        %Update the position on the best local particles
        p(i,:) = x(i,:);
    end
end

%Register the best solutions found in each generation
Evolution(k) = gfit;
end

figure
plot(Evolution)
disp(['Best Result:',num2str(g)])
disp(['Best Fitness:',num2str(g)])
disp(['Best:',num2str(gfit)]);
