% Problem parameters
x_upperbound = pi;
Nx = 100;    % Spatial discretization
Nt = 100;    % Temporal discretization
N = 50;      % Number of Fourier terms
x = linspace(0, L, Nx);
tau = linspace(0, 3, Nt);

% Define initial condition g(x)
g = @(x) x .* (pi - x); % Example: g(x) = x(pi - x)

% Calculate Fourier coefficients
b_n = fourier_coefficents(g, x_upperbound, N);

% Solve PDE
u = solve_pde(b_n, x_upperbound, x, tau, N);

% Plotting
[X, T] = meshgrid(x, tau);
surf(X, T, transpose(u));
xlabel('x');
ylabel('\tau');
zlabel('u(x, \tau)');
title('Solution to the Heat Equation');