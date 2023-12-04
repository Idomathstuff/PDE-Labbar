t_stop = 10; % time stops at t seconds
dt = 0.1; %time step size
n_stop = round(t_stop/dt); % numb of time steps

K = 25; % numb of trajectories/particles
M = 100; % numb of partitions in R2

trajectory_tensor = zeros(n_stop, K, 2); % time | trajectory index | (x(t),y(t))
density_tensor = zeros(n_stop, M, 3); % time | partition index | (partition x, partition y, concentration u)



clear j;
clear i;
clear s;
clear t;
clear m;

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

%_______Calculate concentration at each partition in R2+time and store them

%__________set partitions____
i = 1; % x index
j = 1; % y index
s = 1/sqrt(M); % side of grid squares side length

for m = 1:M % omega_m index tracker
    for t = 1:n_stop
        indicator_counter = 0;
        for k = 1:K
            x_current = trajectory_tensor(t,k,1);
            y_current = trajectory_tensor(t,k,2);
            if  (i-1)*s<=x_current<=i*s 
            end
        end
        density_tensor(t, m, 1:2) = [i*s; j*s];
    end
    if mod(m, sqrt(M)) == 0 % Reset indices
        i = 1;
        j = j + 1;
    else
        i = i + 1;
    end
end


% Plotting the trajectories
figure;
for k = 1:K
    scatter(squeeze(trajectory_tensor(1, k, 1)),  squeeze(trajectory_tensor(1, k, 2)), 'filled')
    hold on;
    plot(squeeze(trajectory_tensor(:, k, 1)), squeeze(trajectory_tensor(:, k, 2)), 'LineWidth', 1.5);
end
hold off;
% Adding labels and title
xlabel('X-axis');
ylabel('Y-axis');
title('Trajectories of Particles'); 