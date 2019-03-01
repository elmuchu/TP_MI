clear all
close all

x0 = -5;
xf = 5;
Nx = 50;
dx = (xf-x0)/Nx;
x = [x0:dx:xf];
xtilde = [x0-(dx/2):dx:xf+(dx/2)];

t0 = 0;
tf = 1;
Nt = 100;
dt = (tf-t0)/Nt;
t = [t0:dt:tf];

%Uex = @(x,t)(uex1(x,t));
Uex = @(x,t)(uex2(x,t));

p = zeros(length(x),length(t));
for xi=1:length(x)
    p(xi,1) = (1/dx)*quadv(@f,xtilde(xi),xtilde(xi+1));
end

tic
for n=1:length(t)-1
    for i=2:length(x)-1
        p(i,n+1) = 0.5*(p(i+1,n)+p(i-1,n))-(dt/2/dx)*(q(p(i+1,n))-q(p(i-1,n)));
    end
    p(1,n+1) = f(x(1));
    p(length(x),n+1) = f(x(length(x)));
    
    plot(x,p(:,n+1),x,Uex(x,t(n+1)))
    legend({'Valeur numerique', 'Valeur exacte'})
    pause(0.001)
end
toc



