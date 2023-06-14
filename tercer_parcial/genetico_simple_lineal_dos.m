function [bestsol, bestfun, count] = gasimple()
    global solnew sol pop popnew fitness fitold f range;
    n = 10; % Número de elementos en el vector x

    f = @(x) sum(arrayfun(@(i) exp(i) * abs(x(i)), 1:length(x)));

    rng('default');
    figure;
    popsize = 20;
    Maxgen = 100;
    count = 0;
    nsite = 2;
    pc = 0.95;
    pm = 0.05;
    nsbit = n;
    popnew = init_gen(popsize, nsbit);
    fitness = zeros(1, popsize);

    x = range(1):0.1:range(2);
    plot(x, arrayfun(f, x));
    hold on;

    for i = 1:popsize
        solnew(i) = bintodec(popnew(i, :));
    end

    bestfun = zeros(1, Maxgen); % Almacenar el mejor valor de la función en cada generación
    bestsol = zeros(1, Maxgen); % Almacenar la mejor solución en cada generación

    num_generations_sin_mejora = 0; % Contador de generaciones sin mejora
    max_generations_sin_mejora = 10; % Número máximo de generaciones sin mejora permitidas

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
        bestsol(i) = mean(sol(bestfun(i) == fitness));

        % Verificar si ha habido mejora en el mejor valor de la función
        if i > 1 && bestfun(i) >= bestfun(i-1)
            num_generations_sin_mejora = num_generations_sin_mejora + 1;
        else
            num_generations_sin_mejora = 0;
        end

        % Detener el algoritmo si no hay mejora durante un número determinado de generaciones
        if num_generations_sin_mejora >= max_generations_sin_mejora
            break;
        end
    end

    % Eliminar valores cero de bestfun y bestsol en caso de haber terminado antes de Maxgen
    bestfun = bestfun(bestfun ~= 0);
    bestsol = bestsol(bestfun ~= 0);

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

% Resto del código...


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
