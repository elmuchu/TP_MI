function err = fitfun_lorentz(param,x,y)

N=param(1);
Gamma=param(2);
x0=param(3);

A(1,:) = N*Gamma/2/pi./(1+(x-x0).^2/(Gamma/2)^2);
err = norm(A-y);