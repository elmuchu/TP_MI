clc
clear all
close all

K = 30;
Tr = 0.5;

s = tf('s');
%H = tf(K,[0.5 1],'InputDelay',Tr);
H = K*exp(-Tr*s)/(0.5*s+1);
bode(H,logspace(-1,2,5000)); grid on