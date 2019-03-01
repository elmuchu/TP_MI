clc
clear all
close all

global theta theta_p p Rf L p1 th0 th1

% contraintes a respecter
th0 = 0;
th1 = pi/4;
p1 = [0.5 0.5];
L = 1;
Rf = 1;

theta = @(s,a)(a(1)+a(2)*s+a(3)*sin(2*pi*s/L)+a(4)*cos(2*pi*s/L)+a(5)*sin(4*pi*s/L)+a(6)*cos(4*pi*s/L));
theta_p = @(s,a)(a(2)+a(3)*(2*pi/L)*cos(2*pi*s/L)-a(4)*(2*pi/L)*sin(2*pi*s/L)+a(5)*(4*pi/L)*cos(4*pi*s/L)-a(6)*(4*pi/L)*sin(4*pi*s/L));
p = @(s,a)([integral(@(x)(cos(theta(x,a))),0,s) integral(@(x)(sin(theta(x,a))),0,s)]);

fcost = @(x)(fcost_shape(x));
fconst = @(x)(fconst_shape(x));
A = [];
b = [];
Aeq = [];
beq = [];
lb = [];
ub = [];

%cas tests
figure; hold on
N = 10; % nb de cas a tracer
N_long = 500;
for i=1:N
    theta_ini = rand(1,6);
    [a(i,:),fval(i)] = fmincon(fcost,theta_ini,A,b,Aeq,beq,lb,ub,fconst);
    for g=1:N_long
        x(g,:) = p((g-1)*L/(N_long-1),a(i,:));
    end
    plot(x(:,1),x(:,2));
end
grid on; xlabel('x(m)'); ylabel('y(m)');

