function [f,df,H] = f2(x)

x1 = x(1); x2 = x(2);

f = (x1-1).^2+5*((x1.^2-x2).^2); %function
df = [20*(x1^3)-20*x1*x2+2*x1-2 ; -10*(x1^2-x2) ]; %gradient vector
H = [60*(x1^2)-20*x2+2 -20*x1 ; -20*x1 10]; %hessian matrix

end