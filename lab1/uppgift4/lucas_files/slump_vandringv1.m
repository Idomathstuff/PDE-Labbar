t_stop = 10; % time stops at t seconds
dt = 0.01; %time step size
n_stop = round(t_stop/dt); % numb of time steps

K = 200; % numb of trajectories/particles
M = 100; % numb of partitions in R2

trajectory_tensor = zeros(n_stop, K, 2); % time | trajectory index | (x(t),y(t))
density_tensor = zeros(n_stop, M, 3); % time | partition index | (partition x, partition y, concentration u)



%__________set trajectories initial conditions at time 0______
trajectory_tensor(1,:,:) = rand(K,2); % Randomly generates X_t0^K uniformly in [0,1]x[0,1]

%______Calculate the path of the trajectories and store them in trajectory_tensor
v_givna = @(x, y) [y; 1 - x];
for t = 1:n_stop-1
    for k = 1:K
        x_current = trajectory_tensor(t,k,1);
        y_current = trajectory_tensor(t,k,2);
        W = sqrt(dt)*randn; % normally distributed noise with variance dt
        trajectory_tensor(t+1,k,:) = squeeze(trajectory_tensor(t,k,:)) + dt.*v_givna(x_current,y_current) + W;
    end
end


%__________set partitions and do montecarlo integration
i = 1; % x index
j = 1; % y index
s = 3/sqrt(M); % side of grid squares side length

for m = 1:M % omega_m index tracker
    for t = 1:n_stop
        indicator_counter = 0;
        for k = 1:K
            x_current = trajectory_tensor(t,k,1);
            y_current = trajectory_tensor(t,k,2);
            if  (i-1)*s<= x_current && x_current<i*s && (j-1)*s<=y_current && y_current<= j*s
                indicator_counter = indicator_counter+1;
            end
        end
        density_tensor(t, m, 1:3) = [i*s; j*s; indicator_counter/K];
    end
    if mod(m, sqrt(M)) == 0 % Reset indices
        i = 1;
        j = j + 1;
    else
        i = i + 1;
    end
end


% Density over time
% Initialize figure
figure;

% Create scatter plot handles
scatter_filled = scatter(density_tensor(1,:,1), density_tensor(1,:,2), 100, density_tensor(1,:,3), 'filled');
hold on;
scatter_unfilled = scatter(density_tensor(1,density_tensor(1,:,3)==0,1), density_tensor(1,density_tensor(1,:,3)==0,2), 10, 'w', 'o');

colormap(jet); % You can change 'jet' to any other colormap
colorbar; % Add colorbar
axis([0 5 0 5]); % Set axis limits if needed
xlabel('X-axis');
ylabel('Y-axis');
title(['Density at Time Step 1']);

% Update scatter plots within the loop
for t = 2:n_stop
    % Update filled points scatter plot data
    scatter_filled.XData = density_tensor(t,density_tensor(t,:,3)>0,1);
    scatter_filled.YData = density_tensor(t,density_tensor(t,:,3)>0,2);
    scatter_filled.CData = density_tensor(t,density_tensor(t,:,3)>0,3);

    
    % Update unfilled points scatter plot data
    scatter_unfilled.XData = density_tensor(t,density_tensor(t,:,3)==0,1);
    scatter_unfilled.YData = density_tensor(t,density_tensor(t,:,3)==0,2);

    title(['Density at Time Step ' num2str(t)]);
    pause(0.1);
end


% Density over time plot________________
% figure;
% scatter_handle = scatter(density_tensor(1,:,1), density_tensor(1,:,2), 100, density_tensor(1,:,3), 'filled');
% colormap(jet); % You can change 'jet' to any other colormap
% colorbar; % Add colorbar
% axis([0 5 0 5]); % Set axis limits if needed
% xlabel('X-axis');
% ylabel('Y-axis');
% title(['Density at Time Step 1']);
% for t = 2:n_stop
%     % Update scatter plot data
%     scatter_handle.XData = density_tensor(t,:,1);
%     scatter_handle.YData = density_tensor(t,:,2);
%     scatter_handle.CData = density_tensor(t,:,3);
% 
%     title(['Density at Time Step ' num2str(t)]);
%     pause(0.1);
% end


% Plotting the trajectories_______________
figure;
for k = 1:K
    scatter(squeeze(trajectory_tensor(1, k, 1)),  squeeze(trajectory_tensor(1, k, 2)), 'filled') % initial conditions
    hold on;
    plot(squeeze(trajectory_tensor(:, k, 1)), squeeze(trajectory_tensor(:, k, 2)), 'LineWidth', 1.5);
end
hold off;
% Adding labels and title
xlabel('X-axis');
ylabel('Y-axis');
title('Trajectories of Particles');

