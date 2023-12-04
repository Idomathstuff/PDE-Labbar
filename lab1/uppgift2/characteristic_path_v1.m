K = 10; % K val (see lab1 description)
ds = 0.5; % time step size for time variable s (see lab1 desc.)
s_stop = 5; % stopper value for time s
n_stop = round(abs(s_stop) / ds); % iterations required to reach stopper value

% Create a grid of k1 and k2 values
k_values = 1:10;
[K1, K2] = meshgrid(k_values, k_values);

% Initialize a cell array to store trajectories for each k1, k2 pair
trajectories = cell(size(K1));

% Loop through all combinations of k1 and k2
for i = 1:numel(K1)
    k1 = K1(i);
    k2 = K2(i);
    
    pos = [k1/K; k2/K];
    u = f_tilda(pos(1), pos(2));
    
    % Store the positions and concentrations at each step
    pos_history = zeros(3, n_stop + 1);
    pos_history(1:2, 1) = pos;
    pos_history(3, 1) = u;

    for j = 1:n_stop
        u = u + ds .* f_tilda(pos(1), pos(2)); 
        v1_at_pos = pos(2);
        v2_at_pos = 1-pos(1);
        pos = pos + ds .* [v1_at_pos; v2_at_pos];
        pos_history(1:2, j + 1) = pos;
        pos_history(3, j + 1) = u;
    end

    % Store the trajectory for the current k1, k2 pair
    trajectories{i} = pos_history;
end

% Plot the 3D trajectories
figure;
for i = 1:numel(K1)
    plot3(trajectories{i}(1, :), trajectories{i}(2, :), trajectories{i}(3, :), '-O');
    hold on;
end

% Scatter plot for initial positions
scatter(K1(:)/K, K2(:)/K, 'r', 'filled');
title('3D Trajectories with Concentration for Different k1, k2 Values');
xlabel('x');
ylabel('y');
zlabel('Concentration (u)');
grid on;
legend('Trajectories', 'Initial Positions');



