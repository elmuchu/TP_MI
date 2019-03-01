function err = fitfun(param,t,y)

tau=param(1);
A(1,:) = exp(-t/tau);
err = norm(A-y);
