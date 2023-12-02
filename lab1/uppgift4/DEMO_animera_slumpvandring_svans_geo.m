%% Simulera Slumpvandring
% Author: Emanuel Ström, emastr@kth.se

clear all;
close all;
clc;

% Här är ett exempel på hur animera_slumpvandring_geo_svans() funkar.
% Funktionen är väldigt lik animera_slumpvandring_geo(), med en extra
% funktionalitet, nämligen att partiklarna ritar ut banor när de färdas.
% Först måste vi definiera några parametrar:

K = 100; % Antal partiklar
c = 0.02; % c - diffusionsparameter
N = 100; % Antal tidssteg
M = 20; % Antal punkter i rutnätet längsmed x- och y-axlarna
dt = .01; % Tidsstegens storlek

% Man måste också definera fyra funktioner:
% sample fun, som slumpar positioner i fyrkanten [0,1]x[0,2]
% sample dist, täthetsfunktionen för sample fun
% v, hastighetsfältet
% g, initialvillkoret
% Exempel på dessa kan ni se nedan.

% Det finns lite gömda parametrar inuti animera_slumpvandring_svans_geo.mat,
% som man kan ändra om man vill. Bland annat svansens längd och
% genomskinlighet.

[frames, u, xMesh, yMesh] = animera_slumpvandring_svans_geo(K,... 
                                                      @sample_fun,...
                                                      @sample_dist,...
                                                      @v, ... % Velocity field (time independent)
                                                      @g,...  % Initial state 
                                                      c,...
                                                      N,...
                                                      M,... 
                                                      dt); 
                                                   
% När simuleringen är klar har vi fått fyra objekt:
% 1) frames, en animation av simuleringen (en struct med bilder)
%       ni kan visa en specifik bild med imagesc(frames(index)), 
%       där tex index=1.
% 2) U, en matris med lösningen
% 3) xMesh, x-värdet på diskretiseringspunkterna
% 4) yMesh, y-värdet på diskretiseringspunkterna.


%% Visa Animation

% Skapa en figur (viktigt att ha 1:2 aspect ratio)
pixWidth = 300; 
pixHeight = 600; % Width and height of plot (in pixels)
figure('Position', [10, 10, pixWidth, pixHeight]);

% Och visa animationen på denna figur med movie() funktionen
%    argument: axis, frames, upprepningar, fps (frames per second)
movie(gcf, frames, 50, 30)

% Man kan även kolla på en specifik tidpunkt:
figure('Position', [10, 10, pixWidth, pixHeight]);
imshow(frames(8).cdata)

%% Andra Tips För Redovisning


% Vi kan integrera u över tid:
u_int = cumsum(u,3)*dt;

% Och visa u, u_int osv. vid olika tidpunkter:

figure('Position', [10, 10, 1000,400]);
frames2(N+1) = struct('cdata',[],'colormap',[]);
cmapname = "parula";

subplot(1,3,1); % Skapa subplot
imagesc([0,1], [0,2], u(:,:,1), [min(min(min(u))), max(max(max(u)))]); % Visa u vid tiden t=0
set(gca,'YDir','normal') % Justera så att bilden inte blir uppochner. Har att göra med hur imagesc funkar.
pbaspect([1 2 1]) % Sätt aspect-ratio till 1:2.
colorbar % Lägg till färgstapel
colormap(gca, cmapname) % Ställ in färgschema
title(gca, "Initial State") % Ställ in titel
axis off % Stäng av axlarna, behövs inte här.

ax = subplot(1,3,2);
im = imagesc([0,1], [0,2], u(:,:,1), [min(min(min(u))), max(max(max(u)))]);
set(ax,'YDir','normal')
pbaspect([1 2 1])
colorbar
colormap(ax, cmapname)
title(ax, "Solution")
axis off

ax2 = subplot(1,3,3);
im2 = imagesc([0,1], [0,2], u_int(:,:,1), [min(min(min(u_int))), max(max(max(u_int)))]);
set(ax2,'YDir','normal')
pbaspect([1 2 1])
colorbar
colormap(ax2, cmapname)
title(ax2, "Time integrated")
axis off



for k = 1:(N+1)
    im.CData =u(:,:,k);
    im2.CData=u_int(:,:,k);
    ax.Title.set("String", strcat("Solution at t=", string(round(k*dt,2))))
    frames2(k) = getframe(gcf);
end

movie(gcf, frames2,60, 10) 

%% Funktioner

function [x0, y0] = sample_fun(K)
    % In: antal partiklar
    % Ut: slumpade positioner x0,y0
    
    % Uniform distribution
    %x0 = rand(K,1)*2-0.5; % Initial x coords of particles
    %y0 = rand(K,1)*4-1; % Initial y coords of particles
    
    % Sample from normal distribution
    %sigma = 10 * 0.02*[1, 2];
    sigma = 1 * 0.02*[1, 2];
    mu = [0.2, 1.3];
    x0 = randn(K,1)*sigma(1) + mu(1);
    y0 = randn(K,1)*sigma(2) + mu(2);
end

function p_xy = sample_dist(x, y)
    % In: vektorer x, y
    % Ut: täthetsfunktionen för sample_fun, dess värde i x,y
    
    %global sigma mu
    % Uniform distribution
    %p_xy = ones(size(x)) / 2;
    
    % Normal distribution
    %sigma = 10 * 0.02*[1, 2];
    sigma = 1 * 0.02*[1, 2];
    mu = [0.2, 1.3];
    C = 1 / (2*pi*sqrt(prod(sigma.^2)));
    p_xy = C * exp(-((x-mu(1))/sigma(1)).^2/ 2  - ((y-mu(2))/sigma(2)).^2 / 2);
end

function [v1, v2] = v(x,y)
    % In: x,y vektorer
    % Ut: v1,v2 hastigheter
    v1 = y;
    v2 = (1-x);
end

function g_xy = g(x, y)
    % In: x,y vektorer
    % Ut: begynnelsevillkoret g:s värde i x,y.
    
    mu = [0.2, 1.3];
    sigma = 1*0.02 * [1, 2];
    C = 1 / (2*pi*sqrt(prod(sigma.^2)));
    g_xy = C * exp(-((x-mu(1))/sigma(1)).^2/ 2  - ((y-mu(2))/sigma(2)).^2 / 2);
    %g_xy = (sin(2*2*pi*x+1e-10).*sin(2*2*pi*y+1e-10)) >= 0.;
    %g_xy = C * exp(-((x-mu(1))/sigma(1)).^2/ 2  - ((y-mu(2))/sigma(2)).^2 / 2).*(y-mu(2)).*(x-mu(1));
end