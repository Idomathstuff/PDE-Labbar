classdef PolarDensity
    % Author: Emanuel Ström, emastr@kth.se
    % For nice density plots with a user-specified alpha-level
    % The color map is a linear interpolation of red - transparent - blue.
    % To change the color, simply change hi_col and lo_col in the
    % properties.
    
    properties
        hi_col = 'red';
        lo_col = 'blue';
        geo_hi;
        geo_lo;
        hi_max;
        lo_max;
        mid_range;
        auto_range;
        densityBlending;
    end
    
    methods
        function obj = PolarDensity(x_lat, y_lon, vals, densityBlending, mid_range)
            % Density plot with two poles (blue and red), separated by an
            % alpha channel. 
            if mid_range == 'auto'
                obj.auto_range = true;
                obj.mid_range = median(vals);
            else
                obj.auto_range = false;
                obj.mid_range = mid_range;
            end
            obj.densityBlending = densityBlending;
            [hi_range, lo_range] = PolarDensity.split_vals(vals, obj.mid_range);
            obj.hi_max= max(hi_range);
            obj.lo_max= max(lo_range);
            obj.geo_hi = geodensityplot(x_lat, y_lon, hi_range, 'FaceColor', obj.hi_col,'Radius', densityBlending);
            hold on
            obj.geo_lo = geodensityplot(x_lat, y_lon, lo_range, 'FaceColor', obj.lo_col,'Radius', densityBlending);
        end
        
        function updateVals(obj, vals)
            if obj.auto_range
                obj.mid_range = median(vals);
            end
            [hi_range, lo_range] = PolarDensity.split_vals(vals, obj.mid_range);
            obj.hi_max= max(hi_range);
            obj.lo_max= max(lo_range);
            obj.geo_hi.WeightData = hi_range;
            obj.geo_lo.WeightData = lo_range;
        end            
    end
    
    methods(Static)
        function [hi_range, lo_range] = split_vals(vals, mid_range)
            % Given values vector, create two vectors of equal size.
            %   hi_range is zero if the value is lower than mid_range, and
            %   the same as values otherwise.
            %   lo_range is hi_range - vals + mid_range.
            
            % Do two sepate geodensityplots to get two colors.
            is_hi_range = vals > mid_range;
            % Exceeding mid value
            hi_range = is_hi_range.*(vals - mid_range);
            % Not exceeding mid value
            lo_range = hi_range - vals + mid_range;
        end
    end
end

