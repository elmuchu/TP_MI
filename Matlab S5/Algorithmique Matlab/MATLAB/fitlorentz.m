function e = fitlorentz(x0,g,N,x,y)

A(1,:) = N*(g/(2*3.14))/(1+((x-x0).^2)/(g/2).^2);
e = norm(A-y);