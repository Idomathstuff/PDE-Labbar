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
g1 = @(x) x.*(pi-x);
g2 = @(x) x.*(x<pi/2);
U1 = zeros(Nx, Ntau); % Nx by Ntau grid
U1(1, :) = 0; % Boundary condition at x = 0
U1(Nx, :) = 0; % Boundary condition at x = pi
U1(:, 1) = g1(x); % Initial condition at tau = 0

U2 = zeros(Nx, Ntau); % Nx by Ntau grid
U2(1, :) = 0; % Boundary condition at x = 0
U2(Nx, :) = 0; % Boundary condition at x = pi
U2(:, 1) = g2(x); % Initial condition at tau = 0

%___CALCULATE finite difference approximation
for n = 2:Ntau
    for j = 2:Nx-1
        U1(j, n) = U1(j, n-1) + 0.5*(U1(j+1, n-1) - 2 * U1(j, n-1) + U1(j-1, n-1));
    end
end

for n = 2:Ntau
    for j = 2:Nx-1
        U2(j, n) = U2(j, n-1) + 0.5*(U2(j+1, n-1) - 2 * U2(j, n-1) + U2(j-1, n-1));
    end
end


figure;
surf(x,tau,U1')
xlabel('x');
ylabel('\tau');
zlabel('u(x, \tau)');
title('Finite difference approximation using g_1(x) initial condition');

figure;
surf(x,tau,U2')
xlabel('x');
ylabel('\tau');
zlabel('u(x, \tau)');
title('Finite difference approximation approximation using g_2(x) initial condition');

