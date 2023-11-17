M = 1000;
xp_points = rand(M,1);
yp_points = rand(M,1);
k = 2pi;
N = 6;

% Initialize v1 and v2
v1 = yp_points;  % v1 = y
v2 = 1 - xp_points;  % v2 = 1 - x


n1n2_vector = zeros((2N+1)^2,2);
counter = 1;
for n1 = -N:N
    for n2 = -N:N
        n1n2_vector(counter,:) = [n1,n2];
        counter=counter+1;
    end
end


A = zeros(M,(2N+1)^2); 
for row = 1:M
    for col = 1:(2N+1)^2
        xp = xp_points(row,1);
        yp = yp_points(row,1);
        dotted_term = n1n2_vector(col,:)[xp;yp];
        A(row,col) = exp(kdotted_term1i);
    end
end

v_hat_1 = ((A'A).^-1)A'v1;
v_hat_2 = ((A'A).^-1)A'v2;


%%%%% Make a f val vector with all x and y points%%%%%
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

f_hat = ((A'A).^-1)A'f_vals_p;


v_1_tilda = @(x, y) real(v_hat_1' * exp(1i * k * n1n2_vector * [x; y]));
v_2_tilda = @(x, y) real(v_hat_2' * exp(1i * k * n1n2_vector * [x; y]));
f_tilda = @(x,y) real(f_hat' * exp(1i * k * n1n2_vector * [x; y]));

% Assuming you've defined f_tilda as mentioned in your code

% Generate a grid of points for x and y
[x, y] = meshgrid(linspace(0, 1, 100), linspace(0, 1, 100));

% Evaluate f_tilda for each point in the grid
z = arrayfun(@(x, y) f_tilda(x, y), x, y);

% Plot the 3D surface
figure;
surf(x, y, z);
title('3D Plot of f_tilda');
xlabel('x');
ylabel('y');
zlabel('f_tilda');