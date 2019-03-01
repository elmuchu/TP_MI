clc
clear all
close all

K = [1 2 10];

H1 = tf([K(1)],[0.05 1 0]);
L = H1; sim('exo1'); M1 = simout.time; N1 = simout.signals.values;

H2 = tf([K(2)],[0.05 1 0]);
L = H2; sim('exo1'); M2 = simout.time; N2 = simout.signals.values;

H3 = tf([K(3)],[0.05 1 0]);
L = H3; sim('exo1'); M3 = simout.time; N3 = simout.signals.values;

plot(M1,ones(size(M1)),M1,N1,M2,N2,M3,N3); legend('u(t)','K=1','K=2','K=10'); grid on

