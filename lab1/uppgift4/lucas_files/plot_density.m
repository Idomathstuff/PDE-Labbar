% Density over time plot________________
figure;


scatter_filled = scatter(density_tensor(1,:,1), density_tensor(1,:,2), 100, density_tensor(1,:,3), 'filled');
hold on;
scatter_unfilled = scatter(density_tensor(1,density_tensor(1,:,3)==0,1), density_tensor(1,density_tensor(1,:,3)==0,2), 10, 'w', 'o');

colormap(jet); % You can change 'jet' to any other colormap
colorbar; % Add colorbar
axis([-2 2 -2 2]); % Set axis limits if needed
xlabel('X-axis');
ylabel('Y-axis');
title(['Density at Time Step 1']);

for t = 2:n_stop
    scatter_filled.XData = density_tensor(t,density_tensor(t,:,3)>0,1);
    scatter_filled.YData = density_tensor(t,density_tensor(t,:,3)>0,2);
    scatter_filled.CData = density_tensor(t,density_tensor(t,:,3)>0,3);

    scatter_unfilled.XData = density_tensor(t,density_tensor(t,:,3)==0,1);
    scatter_unfilled.YData = density_tensor(t,density_tensor(t,:,3)==0,2);

    title(['Density at Time Step ' num2str(t*dt)]);
    pause(0.01);
end
