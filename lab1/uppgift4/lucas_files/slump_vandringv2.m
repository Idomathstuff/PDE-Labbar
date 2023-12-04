t_stop = 10; % time stops at t seconds
dt = 0.01; %time step size
n_stop = round(t_stop/dt); % numb of time steps

K = 100; % numb of trajectories/particles
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
% Set partitions and do Monte Carlo integration
i = 1; % x index
j = 1; % y index
oX_min = -1;
oY_min = -1;
oX_max = 2;
oY_max = 2;
area_of_grid = (oX_max-oX_min)*(oY_max-oY_min);
s = sqrt(area_of_grid/M); % side of grid squares side length, adjusted for [-2,2]x[-2,2]

for m = 1:M % omega_m index tracker
    for t = 1:n_stop
        indicator_counter = 0;
        for k = 1:K
            x_current = trajectory_tensor(t,k,1);
            y_current = trajectory_tensor(t,k,2);
            if  oX_min + (i-1)*s <= x_current && x_current < oX_min + i*s && oY_min + (j-1)*s <= y_current && y_current < oY_min+ j*s
                indicator_counter = indicator_counter + 1;
            end
        end
        density_tensor(t, m, 1:3) = [oX_min + i*s; oY_min + j*s; indicator_counter/K];
    end
    if mod(m, sqrt(M)) == 0 % Reset indices
        i = 1;
        j = j + 1;
    else
        i = i + 1;
    end
end

% Density over time plot________________
% figure;
% scatter_filled = scatter(density_tensor(1,:,1), density_tensor(1,:,2), 100, density_tensor(1,:,3), 'filled');
% hold on;
% scatter_unfilled = scatter(density_tensor(1,density_tensor(1,:,3)==0,1), density_tensor(1,density_tensor(1,:,3)==0,2), 10, 'w', 'o');
% colormap(jet); 
% colorbar; 
% axis([oX_min oX_max oY_min oY_max]); 
% xlabel('X-axis');
% ylabel('Y-axis');
% title(['Density at Time Step 1']);
% 
% for t = 2:n_stop
%     scatter_filled.XData = density_tensor(t,density_tensor(t,:,3)>0,1);
%     scatter_filled.YData = density_tensor(t,density_tensor(t,:,3)>0,2);
%     scatter_filled.CData = density_tensor(t,density_tensor(t,:,3)>0,3);
% 
%     scatter_unfilled.XData = density_tensor(t,density_tensor(t,:,3)==0,1);
%     scatter_unfilled.YData = density_tensor(t,density_tensor(t,:,3)==0,2);
% 
%     title(['Density at Time Step ' num2str(t*dt)]);
%     pause(0.5);
% end


% Plotting the trajectories_______________
figure;
for k = 1:K
    scatter(squeeze(trajectory_tensor(1, k, 1)),  squeeze(trajectory_tensor(1, k, 2)), 'filled') % initial conditions
    hold on;
    plot(squeeze(trajectory_tensor(:, k, 1)), squeeze(trajectory_tensor(:, k, 2)), 'LineWidth', 1.5);
end
hold off;

xlabel('X-axis');
ylabel('Y-axis');
title('Trajectories of Particles');

