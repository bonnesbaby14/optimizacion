% 3D Plot
figure;
ezsurf(@(u1,u2) (1-u1).^2 + 100*(u2-u1.^2).^2, [-2 2 -2 2]);
xlabel('x');
ylabel('y');
zlabel('f(x, y)');
title('Rosenbrock Function - 3D Plot');

% 2D Contour Plot
figure;
ezcontour(@(u1,u2) (1-u1).^2 + 100*(u2-u1.^2).^2, [-2 2 -2 2]);
xlabel('x');
ylabel('y');
title('Rosenbrock Function - Contour Plot');
