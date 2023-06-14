function [best, fmin, N_iter] = para(n, A, r)
    % Set default parameters if not provided
    if nargin < 1
        n = 25;
    end
    if nargin < 2
        A = 0.45;
    end
    if nargin < 3
        r = 0.5;
    end

    % Frequency range determines the scale
    fmin = 0;  % Minimum frequency
    fmax = 2;  % Maximum frequency

    % Iteration parameters
    tol = 10^(-5);  % Stop tolerance
    N_iter = 0;     % Total number of function evaluations

    % Dimension of the search variables
    d = 2; % Changed to 2 for Rosenbrock's 2D function

    % Initializing arrays
    f = zeros(n, 1);    % Frequency
    v = zeros(n, d);    % Velocities

    % Initializing the population/solutions
    sol = randn(n, d);
    Fitness = zeros(n, 1);

    % Evaluating fitness of initial solutions
    for i = 1:n
        Fitness(i) = Fun(sol(i, :));
    end

    % Finding the best current solution
    [fmin, i] = min(Fitness);
    best = sol(i, :);
    disp(['Fitness: ', num2str(fmin)]);

    % Start the iterations (Bat Algorithm)
    while fmin > tol
        for i = 1:n
            f(i) = fmin + (fmin - fmax) * rand;
            v(i, :) = v(i, :) + (sol(i, :) - best) * f(i);
            S(i, :) = sol(i, :) + v(i, :);

            % Pulse rate
            if rand > r
                S(i, :) = best + 0.01 * randn(1, d);
            end

            % Evaluate new solutions
            Fnew = Fun(S(i, :));

            % If the solution improves or not too loudness
            if Fnew <= Fitness(i) && rand < A
                sol(i, :) = S(i, :);
                Fitness(i) = Fnew;
            end

            % Update the best solution
            if Fnew <= fmin
                best = S(i, :);
                fmin = Fnew;
            end
        end

        N_iter = N_iter + 1;
        disp(['Number of evaluations: ', num2str(N_iter)]);
        disp(['Best = ', num2str(best), '  fmin = ', num2str(fmin)]);

        % Plotting 3D and 2D graphics
        figure(1);
        subplot(1, 2, 1);
        ezsurf(@(u1,u2) (1-u1).^2 + 100*(u2-u1.^2).^2, [-2 2 -2 2]);
        hold on;
        plot3(sol(:, 1), sol(:, 2), Fitness, 'go');
        plot3(best(1), best(2), fmin, 'ro');
        hold off;
        xlabel('x');
        ylabel('y');
        zlabel('f(x, y)');
        title('Rosenbrock Function - 3D Plot');

        subplot(1, 2, 2);
        ezcontour(@(u1,u2) (1-u1).^2 + 100*(u2-u1.^2).^2, [-2 2 -2 2]);
        hold on;
        plot(sol(:, 1), sol(:, 2), 'go');
        plot(best(1), best(2), 'ro');
        hold off;
        xlabel('x');
        ylabel('y');
        title('Rosenbrock Function - Contour Plot');

        pause(0.1);  % Pause for a short duration to display the plots
    end

    % Output/display
    disp(['Number of evaluations: ', num2str(N_iter)]);
    disp(['Best = ', num2str(best), '  fmin = ', num2str(fmin)]);

    % Objective function - Rosenbrock's 2D function
    function z = Fun(u)
        z = (1 - u(1))^2 + 100 * (u(2) - u(1)^2)^2;
          %z=u(1)^2-2*u(1)-11;
        % z=(u(3)+2)*u(2)*u(1)^2;
        %z=0.10471*u(1)^2*u(2)+0.04811*u(3)*u(4)*(14+u(2));
            %z=u(1)*exp(-u(1)^2-u(2)^2);
    %+(1-u(3))^2;
    %ezsurf('(1-u(1))^2+100*(u(2)-u(1)^2)^2+(1-u(3))^2');

    end
end
