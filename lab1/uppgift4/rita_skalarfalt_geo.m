function y = rita_skalarfalt_geo(field, M)
% Author: Emanuel Ström, emastr@kth.se
% Visualise a scalar field in Sweden.
arguments
    field % Function mapping position vectors x, y to a stationary scalar field, [u].
    M (1,1) {mustBeInteger}       % Number of gridpoints in each direction. 
                                  % Higher number = better resolution, but more expensive to plot- O(N^2)
end
% OUTPUTS:
% frames = struct containing the frames of the animation.
%          Each frame is a W x H x 3 matrix with RGB values.

% AESTHETIC SETTINGS 
% ====================================================================
% General settings ===================================================
pixWidth = 400; 
pixHeight = 600; % Width and height of plot (in pixels)
geomap = 'darkwater'; % Map texture type. Other choices include
                        % 'streets-light', 'streets-dark', 'colorterrain',
                        % 'topographic', 'grayterrain', 'landcover',
                        % 'grayland', 'darkwater', 'satellite' and 'none'.

% Settings for density map ===========================================
densityBlending = 3e6 / M; % Radius [m] of the colored 'blob-like' radial functions around each particle.                            

% BELOW THIS IS JUST CODE FOR PLOTTING AND ANIMATING. 
% =========================================================================

proj = Projector([0,1],[0,2]);

xMesh = ones(M, M) .* (0:(M-1)) *1/M; % Mesh points for the grid.
yMesh = ones(M, M) .* (0:(M-1))' *2/M;


xMeshFlat = reshape(xMesh, 1, []);
yMeshFlat = reshape(yMesh, 1, []);
fMesh = field(xMeshFlat, yMeshFlat);

[xLat, yLon] = proj.switch_to_latlon(xMeshFlat, yMeshFlat);

figure('Position', [10, 10, pixWidth, pixHeight]);

middle = (max(fMesh) + min(fMesh))/2; 
density = PolarDensity(xLat, yLon, fMesh, densityBlending, middle);
geolimits(proj.lat_lims, proj.lon_lims)
geobasemap(geomap)

% Create colorbar (rest of the code is for this)
lo_max = density.lo_max;
hi_max = density.hi_max;

M = 100; % Number of colors
M_lo = round(M * lo_max / (lo_max + hi_max));
M_hi = M - M_lo;

% Low range, interpolate from blue to white
lo_interp = linspace(0,1,M_lo)';
cols_lo = [0, 0, 1].*(1-lo_interp) + [1, 1, 1].*lo_interp;

% High range, interpolate from white to red
hi_interp = linspace(0,1,M_hi)';
cols_hi = [1, 1, 1].*(1-hi_interp) + [1, 0, 0].*hi_interp;

% Stack low range and high range
cols = [cols_lo; cols_hi];
colormap(cols)

% Plot
caxis([middle - lo_max, middle + hi_max]);
colorbar
end

