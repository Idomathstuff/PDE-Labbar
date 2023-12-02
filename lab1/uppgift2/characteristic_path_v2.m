K = 10; % K val (see lab1 description)
ds = 0.5; % time step size for time variable s (see lab1 desc.)
s_stop = 5; % stopper value for time s
n_stop = round(abs(s_stop) / ds); % iterations required to reach stopper value

% Create a grid of k1 and k2 values
k_values = 1:10;
[K1, K2] = meshgrid(k_values);

% Initialize a 3x10x100 array to store trajectories
trajectories = zeros(3, 10, 100);

% Loop through all combinations of k1 and k2
for i = 1:numel(K1)
    
    k1 = K1(i);
    k2 = K2(i);
    
    pos = [k1/K; k2/K];
    u = f_tilda(pos(1), pos(2));


    for j = 1:n_stop
        trajectories(:, j, i) = [pos; u];
        u = u + ds .* f_tilda(pos(1), pos(2)); 
        v1_at_pos = pos(2);
        v2_at_pos = 1 - pos(1);
        % v1_at_pos = v_1_tilda(pos(1),pos(2));
        % v2_at_pos = v_2_tilda(pos(1),pos(2));
        pos = pos + ds .* [v1_at_pos; v2_at_pos];
        
        
    end
end

% Plot the 3D trajectories
figure;
for i = 1:numel(K1)
    plot3(squeeze(trajectories(1, :, i)), squeeze(trajectories(2, :, i)), squeeze(trajectories(3, :, i)), '-O');
    hold on;
end

% Scatter plot for initial positions
scatter(K1(:)/K, K2(:)/K, 'r', 'filled');
title('3D trajectory of concentration and position for different starting points on the k1,k2 grid');
xlabel('x');
ylabel('y');
zlabel('Concentration (u)');
grid on;
legend('Trajectories', 'Initial Positions');

%2d plot
% figure;
% for i = 1:numel(K1)
% 
%     plot(squeeze(trajectories(1, :, i)), squeeze(trajectories(2, :, i)), '-O');
%     hold on
% end
% scatter(K1(:)/K, K2(:)/K, 'r', 'filled');
% title('Contour plot');
% xlabel('x');
% ylabel('y');
% grid on;
% legend('Trajectories', 'Initial Positions');
% 
