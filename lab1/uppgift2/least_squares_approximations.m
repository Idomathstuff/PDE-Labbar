M = 1000; % The # of points generated for fourier series approximation
k = 2*pi; % Exp power coefficient
N = 3; % largest magnitude of n1 and n2

% NOTE: We are not using linspace as seen here because they'll make A'*A matrix singular
% xp_points = linspace(-1,1,M)';
% yp_points = linspace(-1,1,M)';
% END NOTE
    
%______generate xp and yp points_______

% xp_points = 2*rand(M,1); % generates on [0,2] (comment out)
% yp_points = -1 + 2*rand(M,1); % generates on [-1,1] (comment out)

xp_points = rand(M,1); % generates on [0,1] (see lab1 description)
yp_points = rand(M,1); % generates on [0,1] (see lab1 description)


% Initialize analytical v1 and v2 (see lab1 pdf description)
v1 = yp_points;  % v1 = y
v2 = 1 - xp_points;  % v2 = 1 - x


%________________initalize analyitcal f_vals_p for xp and yp points__________%
f_vals_p = zeros(M,1);
for row = 1:M
    xp = xp_points(row,1);
    yp = yp_points(row,1);
    r = sqrt((xp-0.5)^2+(yp-0.5)^2);
    if r<=0.1
        f_vals_p(row,1) = 1;
    else
        f_vals_p(row,1) = 0;
    end
end

%_______initialize n1n2 pattern_______
n1n2_vector = zeros((2*N+1)^2,2);
counter = 1;
for n1 = -N:N
    for n2 = -N:N
        n1n2_vector(counter,:) = [n1,n2];
        counter=counter+1;
    end
end

%_________calculate matrix A_________
A = zeros(M,(2*N+1)^2); 
for row = 1:M
    for col = 1:(2*N+1)^2
        xp = xp_points(row,1);
        yp = yp_points(row,1);
        dotted_term = n1n2_vector(col,:)*[xp;yp];
        A(row,col) = exp(k*1i*dotted_term);
    end
end



%________CALCULATE COEFFICIENTS WITH LEAST SQUARES METHOD______
v_hat_1 = (A'*A)\(A'*v1);
v_hat_2 = (A'*A)\(A'*v2);
f_hat = (A'*A)\(A'*f_vals_p );

%_________FOURIER APPROXIMATIONS DEFINED AS ANONYMOUS FUNCTIONS_________
v_1_tilda = @(x, y) real(v_hat_1' * exp(1i * k * n1n2_vector * [x; y]));
v_2_tilda = @(x, y) real(v_hat_2' * exp(1i * k * n1n2_vector * [x; y]));

v_tilda = @(x,y) [v_1_tilda(x,y);v_2_tilda(x,y)]; % combining in to one vector

f_tilda = @(x,y) real(f_hat' * exp(1i * k * n1n2_vector * [x; y]));


%__________FOURIER APPROXIMATION PLOT OF F_________
figure;
[x, y] = meshgrid(linspace(0, 1, 100), linspace(0, 1, 100));
z = arrayfun(@(x, y) f_tilda(x, y), x, y);
surf(x, y, z);
title('3D Plot of f approximation');
xlabel('x');
ylabel('y');
zlabel('f_tilda');


%________VECTOR FIELD PLOT___________
figure;
subplot(1, 1, 1);

% GENERATE GRID OF X AND Y
[x, y] = meshgrid(linspace(-2, 2, 50), linspace(-2, 2, 50)); % Reduce grid size for clarity

% APPROXIMATION V1 and V2
v1_tilda_vals = arrayfun(@(x, y) v_1_tilda(x, y), x, y);
v2_tilda_vals = arrayfun(@(x, y) v_2_tilda(x, y), x, y);

% ANALYTICAL V1 AND V2
v1_anal_vals = arrayfun(@(x,y) y, x,y);
v2_anal_vals = arrayfun(@(x,y) 1-x,x,y); 

quiver(x, y, real(v1_tilda_vals), real(v2_tilda_vals)); % Comment out
% quiver(x, y, v1_anal_vals, v2_anal_vals); % Comment out
hold on;

%_______________Pink highlight of [0,1]x[0,1]____________________%
vertices = [0, 0; 1, 0; 1, 1; 0, 1];
faces = [1, 2, 3, 4];
patch('Vertices', vertices, 'Faces', faces, 'FaceColor', [1, 0.8, 0.8], 'FaceAlpha', 0.5);
scatter(1,0)

%_____________________Labeling_________________%
% title('Vector Field of v1_tilda and v2_tilda');
title("Vector field of v_1 and v_2 fourier approximations");
xlabel('x');
ylabel('y');
axis equal;

