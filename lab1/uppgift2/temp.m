% Set the initial conditions
x0 = 0.2;
y0 = 0.2;

% Set the time step and the number of iterations
dt = 0.01; % Adjust the time step as needed
t_stop = 7;
num_iterations = round(t_stop/dt);

% Initialize arrays to store the trajectory
x_values = zeros(num_iterations, 1);
y_values = zeros(num_iterations, 1);

% Euler's method loop
for i = 1:num_iterations
    % Compute the velocity using the v_givna function
    [v1, v2] = v_givna(x0, y0);
    
    % Update the position using Euler's method
    x1 = x0 + v1 * dt;
    y1 = y0 + v2 * dt;
    
    % Store the updated position
    x_values(i) = x1;
    y_values(i) = y1;
    
    % Update the initial conditions for the next iteration
    x0 = x1;
    y0 = y1;
end

% Plot the trajectory
figure;
plot(x_values, y_values, '-o');
title('Particle Trajectory Using Euler''s Method');
xlabel('x');
ylabel('y');
grid on;