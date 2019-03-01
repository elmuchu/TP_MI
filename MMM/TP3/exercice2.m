clear all
close all
clc

E0 = 10;
C = 0.1;
L = 0.05;
omega0 = 1./sqrt(L*C);

R = 0.01;

tspan = [0:0.01:2];
q0 = [E0 0];

[t,q] = ode23(@(t,y)[y(2); -(R/L)*y(2)-y(1)./(L*C)+E0*sin(omega0*t)],tspan,q0);

El = 0.5*L*q(:,2).^2;
Ec = (q(:,1).^2)/(2*C);

subplot(3,1,1); plot(t,q(:,1)); title('q(t)')
subplot(3,1,2); plot(t,q(:,2)); title('i(t)')
subplot(3,1,3); plot(q(:,1),q(:,2)); title('plan de phase')
figure
plot(t,El,t,Ec,t,El+Ec); title('evolution des energies')

%variation de R de 0.001 a 1
R = [1 0.1 0.01 0.001];

for p=1:length(R)

[t,q] = ode23(@(t,y)[y(2); -(R(p)/L)*y(2)-y(1)./(L*C)+E0*sin(omega0*t)],tspan,q0);

figure;
subplot(3,1,1); plot(t,q(:,1)); title({strcat('R=',num2str(R(p)));'q(t)'})
subplot(3,1,2); plot(t,q(:,2)); title('i(t)')
subplot(3,1,3); plot(q(:,1),q(:,2)); title('plan de phase')

end

