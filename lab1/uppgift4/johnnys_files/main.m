K = 1000; %  partiklar
Delta_t = 0.01; % Tidssteg
c = 0.5; % dfffusionskonstant??? vilket värde
N = 100; % punkter
gridSize = 100; % sizek

X_0 = initialdistribution(K);

% sllumpvandringssimulering
X = randomWalkSimulation(K, N, Delta_t, c, X_0);

rho = computeDensity(X, N, gridSize);

%resoltttt
analyzeResults(rho, N, gridSize);
