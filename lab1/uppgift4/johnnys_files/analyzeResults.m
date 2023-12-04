function analyzeResults(rho, N, gridSize)
    for n = 1:N
        subplot(ceil(sqrt(N)), ceil(sqrt(N)), n);
        imagesc(reshape(rho(:, n), [sqrt(gridSize), sqrt(gridSize)]));
        title(['Tidssteg ' num2str(n)]);
        colorbar;
        axis square;
    end
    
    figure;
    plot(1:N, rho(round(gridSize / 2), :));
    title('Täthetsutveckling vid mitten av rutnätet');
    xlabel('Tid (tidssteg)');
    ylabel('Täthet');
end
