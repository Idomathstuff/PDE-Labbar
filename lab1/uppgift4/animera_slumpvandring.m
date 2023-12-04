function [frames, U, xMesh, yMesh] = animera_slumpvandring(K, sample_fun, sample_dist, v, g, c, N, M, dt)
% Author: Emanuel Ström, emastr@kth.se
% Visualise the spread of pollutant via a wind vector field by following
% a set of particles. The animation can be displayed by calling
%  movie(figure, frames) where figure is a user-specified figure,
%  on which the frames are drawn.

arguments
    K (1,1) {mustBeInteger, mustBeNonnegative} % Number of particles
    sample_fun  % Function that returns list of K sampled particles
    sample_dist % Distribution that sample_fun samples from.
    v  % Function mapping position vectors x, y and possibly time t,
                %             to two vectors v1, v2.
    g  % Function mapping position vectors x, y to a vector g.
    c (1,1) {mustBeReal, mustBeNonnegative}       % diffusion constant - the standard deviation of the random walk.
    N (1,1) {mustBeInteger, mustBeNonnegative} % Total steps to run the simulation for.
    M (1,1) {mustBeInteger, mustBeNonnegative} % Number of grid points in each direction
    dt (1,1) {mustBeReal} %  Time per frame.
end
% OUTPUTS:
% frames = struct containing the frames of the animation.
%          Each frame is a W x H x 3 matrix with RGB values.

% AESTHETIC SETTINGS 
% ====================================================================
% General settings ===================================================
pixWidth = 300; 
pixHeight = 600; % Width and height of plot (in pixels)
cmap = 'summer'; % Colormap for density plot. Common choices are
                 % 'parula', 'hot', 'winter' and 'jet'.
                 % (other choices exist, just google 'colormaps matlab')

% BELOW THIS IS JUST CODE FOR PLOTTING AND ANIMATING. 
% =========================================================================
proj = Projector([0,1],[0,2]);
% Project initial coordinates to longitude, latitude for plotting.


% Plot setup
frames(N) = struct('cdata',[],'colormap',[]);
figure('Position', [10, 10, pixWidth, pixHeight]);
colormap(cmap)


% Initial points
[x0, y0] = sample_fun(K);
x = x0;
y = y0;


U_MC = zeros(M*M, N+1);        % Monte-carlo estimate of u.
                                 % U_MC(M*i + j,n,1) is the estimate of u at a
                                 % grid point i,j and time n*dt.
                                 % U_MC(i,j,n,2) is the number of particles
                                 % that have passed through (i,j).

xMesh = ones(M, M) .* (0:(M-1)) *1/M; % Mesh points for the grid.
yMesh = ones(M, M) .* (0:(M-1))' *2/M;

% These are fixed, so no reason transforming multiple times.
xMeshFlat = reshape(xMesh,1,[]);
yMeshFlat = reshape(yMesh,1,[]);
U_MC(:,1)=g(xMeshFlat,yMeshFlat)*(proj.x_lims(2)-proj.x_lims(1))*(proj.y_lims(2)-proj.y_lims(1))/M^2;

% Scatter particles
weights = g(x0,y0)./sample_dist(x0,y0);

% Plot density u
polarDensity = imagesc([0,1], [0,2], reshape(U_MC(:,1),M,M));% median(g_of_x));
set(gca,'YDir','normal')

title(strcat("t = ", string(round(0,2))))
hold on
scatter_obj = scatter(x0, y0, 'k.');

% Rescale size data according to the importance sampling weights.
scatter_obj.SizeData = 10 + 2e2 * weights/max(weights);

% Set limits, map, color limits
xlim(proj.x_lims)
ylim(proj.y_lims)
colormap(cmap)

% Define function that converts cartesian coordinates 
% to indices for the grid
function [grid_x, grid_y] = coords_to_grid(x1, y1)
    [xnorm, ynorm] = Projector.affine_transform_2d(x1, y1, proj.x_lims, proj.y_lims, [0,1], [0,1]);
    grid_x = round(xnorm * (M-1))+1;
    grid_y = round(ynorm * (M-1))+1;
end

% % Do plot loop
for n = 1:N
    fprintf("Frame %d out of %d done.\r", [n, N])
    
    % Move particles and add random walk using the projected coordinates
    [v1, v2] = v(x, y);
    
    x = x + dt * v1 + sqrt(dt * 2 * c) * randn(K,1);
    y = y + dt * v2 + sqrt(dt * 2 * c) * randn(K,1);
    
    % Check if particles are outside boundary
    is_outside = 1 - (proj.x_lims(1) <= x).*(proj.x_lims(2) >= x).*...
                     (proj.y_lims(1) <= y).*(proj.y_lims(2) >= y);
    
    % Put in grid history
    [grid_x, grid_y] = coords_to_grid(x, y);
    
    % Calculate which grid point the particle is in. 
    U_index_to_update = (grid_x-1) * M + grid_y;
    
    % Loop Through grid history and update weights
    for k=1:K
        if ~is_outside(k) % If not outside grid
            % Grid point that particle k is in right now
            m = U_index_to_update(k);
            % Previous values
            u_prev = U_MC(m, n+1);
            % New values
            U_MC(m, n+1) = u_prev + weights(k); % Importance sampling, done "online" to allow resampling particles
        end
    end
    
    % Project back to lon-lat, scatter
    scatter_obj.XData = x;
    scatter_obj.YData = y;  
    
    %polarDensity.updateVals(U_MC(:,n,1)); % set density data to u.
    int_U = reshape(sum(U_MC(:,1:n), 2) * dt, M,M);
    polarDensity.CData = int_U; % set density data to integral of u.
    title(strcat("t = ", string(round(n*dt,2))))
    frames(n) = getframe(gcf);
end
U_MC(:,2:end) = U_MC(:,2:end)/K;    % Divide by no of particles
U = zeros(M,M,N+1);
for n = 1:(N+1)
    U(:,:,n) = reshape(U_MC(:,n), M,M);
end
end
    

% Custom validation function 
% Borrowed from MATLAB: 
% https://se.mathworks.com/help/matlab/matlab_prog/function-argument-validation-1.html
function mustBeEqualSize(a,b)
    % Test for equal size
    if ~isequal(size(a),size(b))
        eid = 'Size:notEqual';
        msg = 'Size of first input must equal size of second input.';
        throwAsCaller(MException(eid,msg))
    end
end
