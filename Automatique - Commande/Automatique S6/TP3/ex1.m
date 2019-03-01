clc
clear all
close all

K = 5000;

H1 = tf([K],[0.1*0.0003 0.1+0.0003 1 0]);
H2 = tf([K],[0.1 1 0]);

bode(H1); grid on; margin(H1);
figure; bode(H2); grid on; margin(H2);