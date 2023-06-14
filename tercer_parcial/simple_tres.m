function [bestsol, bestfun, count] = gasimple(funstr)
    global solnew sol pop popnew fitness fitold f range;
    if nargin < 1
        funstr = '-cos(x)*exp(-(x-3.1415926)^2)';
    end
    range = [-10 10];
    f = @(x, y) (4 - 2.1 * x.^2 + x.^4/3) .* x.^2 + x.*y + (4 * y.^2);
    rand("state", 0); 
    figure;
    popsize = 20;
    Maxgen = 100;
    count = 0;
    nsite = 2;
    nsbit = 16;
    popnew = init_gen(popsize, nsbit);
    solnew = zeros(popsize, nsbit); % Agregar esta línea
    fitness = zeros(1, popsize);

    x = linspace(range(1), range(2), 100);
    y = linspace(range(1), range(2), 100);
    [X, Y] = meshgrid(x, y);
    Z = f(X, Y);
    surf(X, Y, Z);
    hold on;

    pc = 0.95;
    pm = 0.05; % Agregar esta línea

    for i = 1:popsize
        solnew(i, :) = bintodec(popnew(i, :));
    end

    for i = 1:Maxgen
        fitold = fitness;
        pop = popnew;
        sol = solnew;
        for j = 1:popsize
            ii = floor(popsize * rand) + 1;
            jj = floor(popsize * rand) + 1;
            if pc > rand
                [popnew(ii, :), popnew(jj, :)] = crossover(pop(ii, :), pop(jj, :));
                count = count + 2;
                envolve(ii);
                envolve(jj);
            end
            if pm > rand
                kk = floor(popsize * rand) + 1;
                count = count + 1;
                popnew(kk, :) = mutate(pop(kk, :), nsite);
                envolve(kk);
            end
        end
        bestfun(i) = min(fitness);
        bestsol(i, :) = mean(sol(bestfun(i) == fitness, :));
    end

    plot3(bestsol(:, 1), bestsol(:, 2), bestfun, 'r*');
    hold off;

    figure;
    subplot(2, 1, 1);
    plot(bestsol(:, 1));
    hold on;
    plot(bestsol(:, 2));
    hold off;
    legend('x', 'y');
    title("best estimate");
    subplot(2, 1, 2);
    plot(bestfun);
    title("fitness");
end

% Resto del código omitido...


function pop = init_gen(np, nsbit)
    pop = rand(np, nsbit + 1) > 0.5;
end

function envolve(j)
    global solnew popnew fitness fitold pop sol f;
    solnew(j, :) = bintodec(popnew(j, :));
    fitness(j) = f(solnew(j, 1), solnew(j, 2));
    if fitness(j) > fitold(j)
        pop(j, :) = popnew(j, :);
        sol(j, :) = solnew(j, :);
    end
end

function dec = bintodec(bin)
    global range;
    nn = length(bin) - 1;
    num = bin(2:end);
    Sing = 1 - 2 * bin(1);
    dec = zeros(1, nn);
    dp = floor(log2(max(abs(range))));
    for i = 1:nn
        dec(i) = bintodec_single(num(i), dp - i);
    end
    dec = dec * Sing;
end

function dec_single = bintodec_single(bin, power)
    dec_single = bin * 2^power;
end

function [c, d] = crossover(a, b)
    nn = length(a) - 1;
    cpoint = floor(nn * rand) + 1;
    c = [a(1:cpoint), b(cpoint + 1:end)];
    d = [b(1:cpoint), a(cpoint + 1:end)];
end

function anew = mutate(a, nsite)
    nn = length(a);
    anew = a;
    for i = 1:nsite
        j = floor(rand * nn) + 1;
        anew(j) = mod(a(j) + 1, 2);
    end
end
