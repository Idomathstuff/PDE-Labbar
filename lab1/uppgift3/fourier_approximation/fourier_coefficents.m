function b_n = fourier_coefficents(g, L, N)
    b_n = zeros(1, N);
    for n = 1:N
        integrand = @(x) g(x) .* sin(n * pi * x / L);
        b_n(n) = (2 / L) * integral(integrand, 0, L);
    end
end