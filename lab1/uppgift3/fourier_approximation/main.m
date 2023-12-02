% Problem parameters
x_upperbound = pi;
Nx = 100;    % Spatial discretization
Nt = 100;    % Temporal discretization
N = 50;      % Number of Fourier terms
x = linspace(0, x_upperbound, Nx);
tau = linspace(0, 3, Nt);

% Define initial condition g(x)
g1 = @(x) x .* (pi - x); % Test case #1: g(x) = x(pi - x)
g2 = @(x) x.* (x<pi/2); % Test case #2: g(x) being the step function 

% Calculate Fourier coefficients
b_n1 = fourier_coefficents(g1, x_upperbound, N);
b_n2 = fourier_coefficents(g2, x_upperbound, N);
% Solve PDE
u1 = solve_pde(b_n1, x_upperbound, x, tau, N);
u2 = solve_pde(b_n2, x_upperbound, x, tau, N);

% Plotting
figure;

% Subplot for g1
% subplot(2, 1, 1);
[X, T] = meshgrid(x, tau);
surf(X, T, u1');
xlabel('x');
ylabel('\tau');
zlabel('u(x, \tau)');
title('Fourier series approximation using g_1(x) initial condition');

% Subplot for g2
% subplot(2, 1, 2);
figure;
[X, T] = meshgrid(x, tau);
surf(X, T, u2');
xlabel('x');
ylabel('\tau');
zlabel('u(x, \tau)');
title('Fourier series approximation using g_2(x) initial condition');