function [V,D]=spectre(m,k)

N=size(m,1);
a(1)=k(1)/m(1);
for i=2:N
    a(i)=(k(i-1)+k(i))/m(i);
    b(i-1)=-k(i-1)/sqrt(m(i-1)*m(i));
end
a=a'; b=b';
T=gallery('tridiag',b,a,b);
[V,D]=eig(full(T));