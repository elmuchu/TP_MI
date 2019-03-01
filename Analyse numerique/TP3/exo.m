clear all
close all

g = 9.81;

x0 = -10;
xf = 10;
Nx = 500;
dx = (xf-x0)/Nx;
x = [x0:dx:xf];
xtilde = [x0-(dx/2):dx:xf+(dx/2)];

t0 = 0;
tf = 2.5;

lbd1 = @(u,h)(u+sqrt(g*h));
lbd2 = @(u,h)(u-sqrt(g*h));

h = zeros(length(x),1);
u = h;
for xi=1:length(x)
    h(xi,1) = (1/dx)*quadv(@f,xtilde(xi),xtilde(xi+1));
end

t = 0; n = 0;
while t<tf
   n = n+1;
   dt = max((dx/2)/max(abs(lbd1(u(:,n),h(:,n))),abs(lbd2(u(:,n),h(:,n)))));
   t = t+dt;
   
   U = @(i,n)([h(i,n)
       h(i,n).*u(i,n)]);
   F = @(u)([u(2)
       (u(2).^2)/u(1)+g/2*u(1).^2]);
   G = @(u,v)(0.5*(F(u)+F(v)-(dx/dt)*(v-u)));
   
   for i=2:length(x)-1
      P = U(i,n)-(dt/dx).*(G(U(i,n),U(i+1,n))-G(U(i-1,n),U(i,n)));
      h(i,n+1) = P(1);
      u(i,n+1) = P(2)/P(1);
   end
   h(1,n+1) = h(2,n+1); u(1,n+1) = u(2,n+1);
   h(length(x),n+1) = h(length(x)-1,n+1); u(length(x),n+1) = u(length(x)-1,n+1);
    
   Wexxt = (Wex(t,x));
   plot(x,h(:,n),'r.',x,Wexxt(1,:),'r',x,u(:,n),'b.',x,Wexxt(2,:),'b')
   %legend({'Hauteur calculee','Hauteur exacte','Vitesse calculee','Vitesse exacte'})
   pause(0.01)
end



