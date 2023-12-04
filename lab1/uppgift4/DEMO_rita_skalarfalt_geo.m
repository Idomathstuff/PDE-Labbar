%% Rita Skalärfält
% Author: Emanuel Ström, emastr@kth.se
clear all
close all
clc

% Här är ett exempel på hur man kan använda funktionen rita_skalarfalt_geo.
% Först måste vi definiera två parametrar
M=60; % Antal basfunktioner som vi använder för att rita skalärfältet i x-och y-riktning.
% field - skalärfältet som ska ritas. 

rita_skalarfalt_geo(@field, M) %Plotta!


function [u] = field(x, y)
    % Test function simulating wind field.
    % Inputs x, y are in sweref99tm coordinates.
    % t = time (h)
    
    % Inward vortex centered in the middle of the map (asymmetrical).
    x_center = (x-1/2);
    y_center = (y-1)/2;
    theta =(180+90)/180*pi;
    
    x = x_center;
    y = y_center;
    %g = @(x,y) cos(x.^2)/(1+x.^2);
    %u = g(x./(y+1), ones(size(x))).*y.^2;
    u = cos(2*pi*x) .* cos(2*pi*y);
    u = u>0;
end