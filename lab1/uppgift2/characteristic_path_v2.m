K = 10; % K val (see lab1 description)
k1 = 1;
k2 = 1;

ds = 0.01; % time step size for time variable s (see lab1 desc.)
s_stop = 5; % stopper value for time s
num_iterations = round(abs(s_stop) / ds); % iterations required to reach stopper value

pos = [k1/K; k2/K]; % starter value x(0) (position of air particle)
u = f_tilda(pos(1), pos(2));

x_values = zeros(num_iterations, 1);
y_values = zeros(num_iterations, 1);

for i = 1:num_iterations
    x_values(i) = pos(1);
    y_values(i) = pos(2);
    u = u + ds .* f_tilda(pos(1), pos(2)); 
    [v1_at_pos,v2_at_pos] = v_givna(pos(1),pos(2));
    pos = pos + ds .* [v1_at_pos;v2_at_pos];
end

% Plot the trajectory
figure;
plot(x_values, y_values, '-o');
title('Particle Trajectory Using Euler''s Method');
xlabel('x');
ylabel('y');
grid on;