classdef Projector
    % Author: Emanuel Ström, emastr@kth.se
    %   Projector class to handle switching between cartesian coordinates
    %   and map projections. This is required for the geo plots.
    properties
        % Coordinate limits        
        lat_lims = [55.2, 69.1];
        lon_lims = [10.57, 24.18];

        % Coordinate projection for transitioning to lat/lon
        sweref99tm_proj = projcrs(3006);
        
        % Projected, non normalised coordinates
        sweref_x_lims;
        sweref_y_lims;
        
        % Renormalised coordinates
        x_lims;
        y_lims;
    end
    
    methods
        function obj = Projector(xLims, yLims)
            %Projector - A class for projecting from lon/lat to custom
            %limits vis SWEREF99. the transition from SWEREF99 to custom is
            %done with an affine transform.            
            
            lat_corners = [obj.lat_lims, obj.lat_lims];
            lon_corners = [obj.lon_lims(1), obj.lon_lims(1),...
                           obj.lon_lims(2), obj.lon_lims(2)];
            [sweref_x_lims, sweref_y_lims] = projfwd(obj.sweref99tm_proj, lat_corners, lon_corners);
            obj.sweref_x_lims = [min(sweref_x_lims), max(sweref_x_lims)];
            obj.sweref_y_lims = [min(sweref_y_lims), max(sweref_y_lims)];            
            obj.x_lims = xLims;
            obj.y_lims = yLims;
        end
        
        function [xLat, xLon] = switch_to_latlon(obj, x, y)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            [xSwe, ySwe] = Projector.affine_transform_2d(x, y,...
                                                   obj.x_lims, obj.y_lims,...
                                                   obj.sweref_x_lims, obj.sweref_y_lims);
            [xLat, xLon] = projinv(obj.sweref99tm_proj, xSwe, ySwe);
        end
        
        function [x, y] = switch_to_coords(obj, xLat, yLon)
            [xSwe, ySwe] = projfwd(obj.sweref99tm_proj, xLat, yLon);
            [x, y] = Projector.affine_transform_2d(xSwe, ySwe,...
                                             obj.sweref_x_lims, obj.sweref_y_lims, ...
                                             obj.x_lims, obj.y_lims);
        end
    end
    methods (Static)
        function [xTrans, yTrans] = affine_transform_2d(x, y, fromXLims, fromYLims, toXLims, toYLims)
            xTrans = Projector.affine_transform(x, fromXLims, toXLims);
            yTrans = Projector.affine_transform(y, fromYLims, toYLims);
        end
        
        function xTrans = affine_transform(x, fromXLims, toXLims)
            t = (x - fromXLims(1)) / (fromXLims(2) - fromXLims(1));
            xTrans = (1-t)*toXLims(1) + t*toXLims(2);
        end
    end
end

