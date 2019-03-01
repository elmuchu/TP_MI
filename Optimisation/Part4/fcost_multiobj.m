function [epsi] = fcost_multiobj(q)

global l1 l2 l3 l4 l5 le
global M
global re r1 r2 r3 r4 r5
global xd

xl = -l1*sin(q(1))+le*cos(q(1))+l2*cos(q(1)+q(2))+l3*cos(q(1)+q(2)+q(3));
yl = l1*cos(q(1))+le*sin(q(1))+l2*sin(q(1)+q(2))+l3*sin(q(1)+q(2)+q(3));

epsiL = sqrt((xl-xd(1,1))^2+(yl-xd(1,2))^2);

xr = -l1*sin(q(1))-le*cos(q(1))-l4*cos(q(1)+q(4))-l5*cos(q(1)+q(4)+q(5));
yr = l1*cos(q(1))-le*sin(q(1))-l4*sin(q(1)+q(4))-l5*sin(q(1)+q(4)+q(5));

epsiR = sqrt((xr-xd(2,1))^2+(yr-xd(2,2))^2);

xcom = -(1/M)*(re*cos(q(1))+r1*sin(q(1))+r2*cos(q(1)+q(2))+r3*cos(q(1)+q(2)+q(3))+r4*cos(q(1)+q(4))+r5*cos(q(1)+q(4)+q(5)));
ycom = (1/M)*(r1*cos(q(1))-re*sin(q(1))-r2*sin(q(1)+q(2))-r3*sin(q(1)+q(2)+q(3))-r4*sin(q(1)+q(4))-r5*sin(q(1)+q(4)+q(5)));

epsiCOM = sqrt((xcom-xd(3,1))^2+(ycom-xd(3,2))^2);

epsi(1) = epsiCOM;
epsi(2) = epsiL;
epsi(3) = epsiR;

end