function [f,df,H] = f1(x)

x1 = x(1); x2 = x(2);

f = 2*x1^2+x2^2-2*x1*x2-x1-x2; %function
df = [4*x1-2*x2-1 ; 2*x2-2*x1-1 ]; %gradient vector
H = [4 -2
   -2 2]; %hessian matrix

end