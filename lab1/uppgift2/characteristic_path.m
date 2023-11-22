K = 100; % K val (see lab1 description)
k1 = 1;
k2 = 1;

ds = 0.01; % time step size for time variable s (see lab1 desc.)
s_stop = 5; % stopper value for time s
n_stop = round(abs(s_stop) / ds); % iterations required to reach stopper value

pos = [k1/K; k2/K]; % starter value x(0) (position of air particle)
u = f_tilda(pos(1), pos(2));

% Store the positions and concentrations at each step
pos_history = zeros(3, n_stop + 1);
pos_history(1:2, 1) = pos;
pos_history(3, 1) = u;

for i = 1:n_stop 
    u = u + f_tilda(pos(1), pos(2));
    pos = pos + ds .* v_givna(pos(1),pos(2));
    pos_history(1:2, i + 1) = pos;
    pos_history(3, i + 1) = u;
end

% Plot the 3D trajectory
figure;
plot3(pos_history(1, :), pos_history(2, :), pos_history(3, :), '-O');
title('3D Trajectory with Concentration');
xlabel('x');
ylabel('y');
zlabel('Concentration (u)');
grid on;
