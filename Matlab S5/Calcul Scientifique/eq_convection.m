clc
clear all
close all

%parametres physiques
x0 = -5;
xf = 10;
t0 = 0;
tf = 15;
U0 = 1;

%parametres numeriques
Nx = 100;
Nt = 500;
dx = (xf-x0)./Nx;
dt = (tf-t0)./Nt;
x = [x0:dx:xf-dx];
t = [t0:dt:tf-dt];
g = exp(-x.*x); %fonction dans l'espace à t=t0
f(:,1) = g;

%Euler explicite + centré 2  --> tjrs instable (variations à gauche si U0>0)
%for n=1:Nt
%    f(1,2) = f(1,1) - dt*U0*(f(2,1)-f(Nx,1))./(2*dx);
%    f(Nx,2) = f((Nx),1) - dt*U0*(f(1,1)-f(Nx-1,1))./(2*dx);
%    for i=2:Nx-1
%        f(i,2) = f(i,1) - dt*U0*(f(i+1,1)-f(i-1,1))./(2*dx);
%    end
%    f(:,1) = f(:,2);
%    plot(x,g,x,f(:,1))
%    grid on
%    pause(0.01)
%end

%Euler explicite + amont 1  --> stable (amortissement) si dt*U0/dx<=1
for n=1:Nt
    f(1,2) = f(1,1) - U0*dt*(f(1,1)-f(Nx,1))./dx;
    for i=2:Nx
        f(i,2) = f(i,1) - U0*dt*(f(i,1)-f(i-1,1))./dx;
    end
    f(:,1) = f(:,2);
    m = abs(max(g(:))-max(f(:,1)))
    plot(x,g,x,f(:,1))
    grid on
    pause(0.01)
end

%RK2 + centré 2 --> tjrs instable (variations à gauche si U0>0)
%for n=1:Nt
%    f(2,2) = f(2,1) - U0*dt*(f(3,1)-f(1,1))./(2*dx) + ((U0*dt).^2)*(f(4,1)-2*f(2,1)+f(Nx,1))./(8*dx*dx);
%    f(1,2) = f(1,1) - U0*dt*(f(2,1)-f(Nx,1))./(2*dx) + ((U0*dt).^2)*(f(3,1)-2*f(1,1)+f(Nx-1,1))./(8*dx*dx);
%    f(Nx,2) = f(Nx,1) - U0*dt*(f(1,1)-f(Nx-1,1))./(2*dx) + ((U0*dt).^2)*(f(2,1)-2*f(Nx,1)+f(Nx-2,1))./(8*dx*dx);
%    f(Nx-1,2) = f(Nx-1,1) - U0*dt*(f(Nx,1)-f(Nx-2,1))./(2*dx) + ((U0*dt).^2)*(f(1,1)-2*f(Nx-1,1)+f(Nx-3,1))./(8*dx*dx);
%    for i=3:Nx-2
%        f(i,2) = f(i,1) - U0*dt*(f(i+1,1)-f(i-1,1))./(2*dx) + ((U0*dt).^2)*(f(i+2,1)-2*f(i,1)+f(i-2,1))./(8*dx*dx);
%    end
%    f(:,1) = f(:,2);
%    plot(x,g,x,f(:,1))
%    grid on
%    pause(0.01)
%end

m = abs(max(g(:))-max(f(:,1)))    %erreur entre les maximums
plot(x,g,x,f(:,1))
grid on