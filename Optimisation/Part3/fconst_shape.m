function [c,ceq] = fconst_shape(a)

global p L p1 th0 th1

c = [];

%theta(s=0) = th0 -> a(1)+a(4)+a(6)=th0
ceq(1) = a(1)+a(4)+a(6)-th0;

%theta(s=L) = th1 -> a(1)+a(2)*L+a(4)+a(6)=th1
ceq(2) = a(1)+a(2)*L+a(4)+a(6)-th1;

%p(s=L) = p1
test = p(L,a)-p1;
ceq(3) = test(1); % \x
ceq(4) = test(2); % \y


end