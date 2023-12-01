function u = solve_pde(b_n, L, x, tau, N)
    u = zeros(length(x), length(tau));
    for k = 1:length(tau)
        for n = 1:N
            % Element-wise multiplication for each n and addition to the solution
            u(:, k) = u(:, k) + (b_n(n) * exp(-((n * pi / L)^2) * tau(k))) .* sin(n * pi * x / L)'; 
        end
    end
end