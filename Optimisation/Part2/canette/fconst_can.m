function [c,ceq] = fconst_can(x)

H = x(1); D = x(2);
c = -H*pi*(D/2)^2+1.5*10^(-3); %volume > 1.5L <=> 1.5L - volume < 0
ceq = [];

end