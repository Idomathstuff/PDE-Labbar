function Xrot = uppgift1(x0, tau)
    tau = abs(tau);
    x = x0; 
    fel = 1; 
    approx = [x0];
    i = 1;
    while fel > tau
        fx = (x.^2 - 9.*sin(1+2.5.*x) -9.*x + 15);
        x = (x.^2)/15 + (6/15).*x - (3/5).*sin(5*x/2 +1)+1;
        fel = abs(fx);
        approx(i+1) = x;
        i = i+1;
    end
    Xrot = approx';
end
% blah blah