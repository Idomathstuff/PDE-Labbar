function X = randomWalkSimulation(K, N, Delta_t, c, X_0)
    X = zeros(K, N);
    X(:, 1) = X_0;
    for n = 2:N
        for k = 1:K
            DeltaW = sqrt(Delta_t) * randn();
            X(k, n) = X(k, n-1) + sqrt(2 * c) * DeltaW;
        end
    end
end
