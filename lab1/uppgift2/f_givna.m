function [f_out] = f_givna(x,y)
% f_givna is defined as the following indicator function

    r = sqrt((x-0.5)^2+(y-0.5)^2);
    if r<=0.1
        f_out = 1;
    else
        f_out = 0;
    end
end