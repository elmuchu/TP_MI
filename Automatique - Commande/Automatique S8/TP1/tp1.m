clear all
close all
clc

Jm(1) = 2.35*10^(-6);   Jm(2) = 1.38*10^(-5);
fm(1) = 2.11*10^(-5);   fm(2) = 1.22*10^(-4);
kc(1) = 0.027;          kc(2) = 0.035;
ke(1) = 0.027;          ke(2) = 0.035;
R(1) = 0.612;           R(2) = 0.318;
L(1) = 0.137;           L(2) = 0.0823;

C = kc./(R.*fm + ke.*kc);

%   2.1

A1 = [0 1 0
    0 -fm(1)/Jm(1) kc(1)/Jm(1)
    0 -ke(1)/L(1) -R(1)/L(1)];
B1 = [0
    0 
    1/L(1)];

A2 = [0 1 0
    0 -fm(2)/Jm(2) kc(2)/Jm(2)
    0 -ke(2)/L(2) -R(2)/L(2)];
B2 = [0
    0
    1/L(2)];

a = eig(A1); b = eig(A2); %valeurs propres

w0(1) = 1/sqrt(L(1)*Jm(1)/(R(1)*fm(1)+ke(1)*kc(1)));
w0(2) = 1/sqrt(L(2)*Jm(2)/(R(2)*fm(2)+ke(2)*kc(2)));
ksi(1) = 0.5*w0(1)*(L(1)*fm(1)+R(1)*Jm(1))/(R(1)*fm(1)+ke(1)*kc(1));
ksi(2) = 0.5*w0(2)*(L(2)*fm(2)+R(2)*Jm(2))/(R(2)*fm(2)+ke(2)*kc(2));

s= tf('s');
H1 = C(1)/(s^2*(1/(w0(1)^2))+2*s*(ksi(1)/w0(1))+1);
[y1,t1] = step(H1);
H2 = C(2)/(s^2*(1/(w0(2)^2))+2*s*(ksi(2)/w0(2))+1);
[y2,t2] = step(H2);

%sim('sim1');
%figure; plot(tout,simout(:,1)); grid on %position theta
%figure; plot(tout,simout(:,2)); grid on %vitesse theta point figure;
%figure; plot(tout,simout(:,3)); grid on %intensite I


%  2.2


wo = 1;
ksi = 0.7;
lmb = roots([1/wo.^2 2*ksi/wo 1]);

K1 = place(A1,B1,[lmb(1) lmb(2) 0]);
K2 = place(A2,B2,[lmb(1) lmb(2) 0]);

sim('sim1');



