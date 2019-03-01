clc
clear all
close all

global l1 l2 l3 l4 l5 le
global m1 m2 m3 m4 m5 M
global l1m l2m l3m l4m l5m
global re r1 r2 r3 r4 r5
global xd

l1 = 0.7; le = 0.3; l2 = 0.4; l3 = 0.3; l4 = 0.4; l5 = 0.3;
m1 = 20; m2 = 6; m3 = 4; m4 = 6; m5 = 4;
l1m = 0.6; l2m = 0.2; l3m = 0.15; l4m = 0.2; l5m = 0.15;

re = le*(m4+m5-m3-m2);
r1 = l1*(m2+m3+m4+m5)+l1m*m1;
r2 = -l2*m3-l2m*m2;
r3 = -l3m*m3;
r4 = l4*m5+l4m*m4;
r5 = l5m*m5;
M = m1+m2+m3+m4+m5;

xd = [0.75 0.6   % bras gauche
    -0.5 1.1     % bras droit
    -0.3 0.6];   % CdM

fcost = @(x)(fcost_multiobj(x));
%fconst = @(x)();
A = [];
b = [];
Aeq = [];
beq = [];
lb = [-pi/6 -pi/4 -5*pi/6 -pi/4 -5*pi/6];
ub = [pi/6 pi/4 5*pi/6 pi/4 5*pi/6];

%resolution
q_ini=[0 0 0 0 0]; % angles initiaux
[q,fval] = fminimax(fcost,q_ini,A,b,Aeq,beq,lb,ub);

XL(1) = -l1*sin(q(1))+le*cos(q(1))+l2*cos(q(1)+q(2))+l3*cos(q(1)+q(2)+q(3));
XL(2) = l1*cos(q(1))+le*sin(q(1))+l2*sin(q(1)+q(2))+l3*sin(q(1)+q(2)+q(3));
XR(1) = -l1*sin(q(1))-le*cos(q(1))-l4*cos(q(1)+q(4))-l5*cos(q(1)+q(4)+q(5));
XR(2) = l1*cos(q(1))-le*sin(q(1))-l4*sin(q(1)+q(4))-l5*sin(q(1)+q(4)+q(5));
XCOM(1) = -(1/M)*(re*cos(q(1))+r1*sin(q(1))+r2*cos(q(1)+q(2))+r3*cos(q(1)+q(2)+q(3))+r4*cos(q(1)+q(4))+r5*cos(q(1)+q(4)+q(5)));
XCOM(2) = (1/M)*(r1*cos(q(1))-re*sin(q(1))-r2*sin(q(1)+q(2))-r3*sin(q(1)+q(2)+q(3))-r4*sin(q(1)+q(4))-r5*sin(q(1)+q(4)+q(5)));

%affichage
O = [0 0]';
P1 = [-l1*sin(q(1)) l1*cos(q(1))]';
Ple = [-l1*sin(q(1))+le*cos(q(1)) l1*cos(q(1))+le*sin(q(1))]';
P2 = [-l1*sin(q(1))+le*cos(q(1))+l2*cos(q(1)+q(2)) l1*cos(q(1))+le*sin(q(1))+l2*sin(q(1)+q(2))]';
P3 = [XL(1) XL(2)]';
Pre = [-l1*sin(q(1))-le*cos(q(1)) l1*cos(q(1))-le*sin(q(1))]';
P4 = [-l1*sin(q(1))-le*cos(q(1))-l4*cos(q(1)+q(4)) l1*cos(q(1))-le*sin(q(1))-l4*sin(q(1)+q(4))]';
P5 = [XR(1) XR(2)]';
T = [O P1 Ple P2 P3 P2 Ple Pre P4 P5];

figure; hold on;
plot(T(1,:),T(2,:),XCOM(1),XCOM(2),'*b'); grid on
plot(xd(1:2,1),xd(1:2,2),'or',xd(3,1),xd(3,2),'ok');
axis([-1.3 1.3 0 1.3]);

