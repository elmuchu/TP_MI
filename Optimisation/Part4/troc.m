clc
%close all

q = [-pi/6 pi/6 5*pi/6 0 0];

xl = -l1*sin(q(1))+le*cos(q(1))+l2*cos(q(1)+q(2))+l3*cos(q(1)+q(2)+q(3));
yl = l1*cos(q(1))+le*sin(q(1))+l2*sin(q(1)+q(2))+l3*sin(q(1)+q(2)+q(3));
xr = -l1*sin(q(1))-le*cos(q(1))-l4*cos(q(1)+q(4))-l5*cos(q(1)+q(4)+q(5));
yr = l1*cos(q(1))-le*sin(q(1))-l4*sin(q(1)+q(4))-l5*sin(q(1)+q(4)+q(5));
xcom = -(1/M)*(re*cos(q(1))+r1*sin(q(1))+r2*cos(q(1)+q(2))+r3*cos(q(1)+q(2)+q(3))+r4*cos(q(1)+q(4))+r5*cos(q(1)+q(4)+q(5)));
ycom = (1/M)*(r1*cos(q(1))-re*sin(q(1))-r2*sin(q(1)+q(2))-r3*sin(q(1)+q(2)+q(3))-r4*sin(q(1)+q(4))-r5*sin(q(1)+q(4)+q(5)));
XL = [xl yl];
XR = [xr yr];
XCOM = [xcom ycom];

%affichage
O = [0 0]';
P1 = [-l1*sin(q(1)) l1*cos(q(1))]';
Ple = [-l1*sin(q(1))+le*cos(q(1)) l1*cos(q(1))+le*sin(q(1))]';
P2 = [-l1*sin(q(1))+le*cos(q(1))+l2*cos(q(1)+q(2)) l1*cos(q(1))+le*sin(q(1))+l2*sin(q(1)+q(2))]';
P3 = [xl yl]';
Pre = [-l1*sin(q(1))-le*cos(q(1)) l1*cos(q(1))-le*sin(q(1))]';
P4 = [-l1*sin(q(1))-le*cos(q(1))-l4*cos(q(1)+q(4)) l1*cos(q(1))-le*sin(q(1))-l4*sin(q(1)+q(4))]';
P5 = [xr yr]';
T = [O P1 Ple P2 P3 P2 Ple Pre P4 P5];

plot(T(1,:),T(2,:),xcom,ycom,'*r'); grid on
axis([-1.3 1.3 0 1.3])
