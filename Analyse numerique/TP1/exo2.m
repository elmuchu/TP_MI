clear all
close all

x0 = 0;
xf = 4;
nx = 50;
dx = (xf-x0)/(nx);
x = [x0:dx:xf];
xtilde = [x0-(dx/2):dx:xf+(dx/2)];

alpha = 1;
c = 1;

T = 12;
dt = alpha*dx/c;
t = [0:dt:T];

g = @(x)sin(pi*x/2);
%g = @(x)(Heavy(x));
uex = @(x,t)g(x-c*t);

u = zeros(length(x),length(t));

for xi=1:length(x)-1
    %u(xi,1) = (1/dx)*integral(g,xtilde(xi-1),xtilde(xi));
    u(xi,1) = (1/dx)*quadv(g,xtilde(xi),xtilde(xi+1));
end
%u(1,1) = (1/dx)*integral(g,xtilde(length(xtilde)),xtilde(1));
%u(1,1) = (1/dx)*quadv(g,xtilde(length(xtilde)),xtilde(1));

M = zeros(length(x),length(x));
for i=2:length(x)-1
    M(i,i-1) = 0.5*(1+alpha);
    M(i,i+1) = 0.5*(1-alpha);
end
M(1,length(x)) = 0.5*(1+alpha); M(1,2) = 0.5*(1-alpha);
M(length(x),length(x)-1) = 0.5*(1+alpha); M(length(x),1) = 0.5*(1-alpha);

for n=2:length(t)
    u(:,n) = M*u(:,n-1);
end

for i=1:length(t)
    plot(x,u(:,i),x,uex(x,t(i))); grid on; axis([x0 xf min(g(x)) max(g(x))]);
    legend({'Valeur numerique', 'Valeur exacte'})
    pause(0.001)
end

