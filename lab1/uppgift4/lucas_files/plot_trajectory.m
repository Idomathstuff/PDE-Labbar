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