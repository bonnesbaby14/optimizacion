function [bestsol, bestfun, count] = gasimple(funstr)
    global solnew sol pop popnew fitness fitold f range;
    if nargin < 1
        funstr = '-cos(x)*exp(-(x-3.1415926)^2)';
    end
    range = [-10 10];
    f = @(x) eval(vectorize(funstr));
    rand("state", 0); 
    figure;
    popsize = 20;
    Maxgen = 100;
    count = 0;
    nsite = 2;
    pc = 0.95;
    pm = 0.05;
    nsbit = 16;
    popnew = init_gen(popsize, nsbit);
    fitness = zeros(1, popsize);

    x = range(1):0.1:range(2);
    plot(x, f(x));
    hold on;

    for i = 1:popsize
        solnew(i) = bintodec(popnew(i, :));
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
        bestfun(i) = max(fitness);
        bestsol(i) = mean(sol(bestfun(i) == fitness));
    end

    plot(bestsol, bestfun, 'r*');
    hold off;

    figure;
    subplot(2, 1, 1);
    plot(bestsol);
    title("best estimate");
    subplot(2, 1, 2);
    plot(bestfun);
    title("fitness");
end

function pop = init_gen(np, nsbit)
    pop = rand(np, nsbit + 1) > 0.5;
end

function envolve(j)
    global solnew popnew fitness fitold pop sol f;
    solnew(j) = bintodec(popnew(j, :));
    fitness(j) = f(solnew(j));
    if fitness(j) > fitold(j)
        pop(j, :) = popnew(j, :);
        sol(j) = solnew(j);
    end
end

function dec = bintodec(bin)
    global range;
    nn = length(bin) - 1;
    num = bin(2:end);
    Sing = 1 - 2 * bin(1);
    dec = 0;
    dp = floor(log2(max(abs(range))));
    for i = 1:nn
        dec = dec + num(i) * 2^(dp - i);
    end
    dec = dec * Sing;
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
