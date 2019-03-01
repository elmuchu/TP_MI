function [c,ceq] = fconst_spring(x)

x1 = x(1); x2 = x(2); x3 = x(3);

c(1) = 1 - (x2^3)*x3/(7178*x1^4);
c(2) = (4*x2^2-x1*x2)/(12566*x2*x1^3-x1^4) + 1/(5108*x1^2) - 1;
c(3) = 1 - 140*x1/(x2^2*x3);
c(4) = (x1+x2)/1.5 - 1;

ceq = 0;

end