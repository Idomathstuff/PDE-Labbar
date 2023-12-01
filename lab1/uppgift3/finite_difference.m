%___SETTING time spatial step size and bounds
dtau = 1e-2; % time step size
dx = sqrt(2*dtau); % spatial step size
x_lowerbound = 0;
x_upperbound = pi;
tau_lowerbound = 0;
tau_upperbound = 3;
Nx = round(x_upperbound/dx); % num time steps
Ntau = round(tau_upperbound/dtau); % num spatial steps
x = linspace(x_lowerbound, x_upperbound, Nx);
tau = linspace(tau_lowerbound, tau_upperbound, Ntau);

%___SETTING boundary and initial conditions
g = @(x) x.*(pi-x);
U = zeros(Nx, Ntau); % Nx by Ntau grid
U(1, :) = 0; % Boundary condition at x = 0
U(Nx, :) = 0; % Boundary condition at x = pi
U(:, 1) = g(x); % Initial condition at tau = 0

%___CALCULATE finite difference approximation
for n = 2:Ntau
    for j = 2:Nx-1
        U(j, n) = U(j, n-1) + (U(j+1, n-1) - 2 * U(j, n-1) + U(j-1, n-1))*(dtau/(dx^2));

    end
end

figure;
surf(x,tau,U')
% surf(x, tau, U', 'EdgeColor', 'interp');
