clc
clear all
close all

K = 500;
Ki = 1;
s = tf('s');

H = tf([K*0.005 K],[0.001 0.11 1 0]);
H = H*Ki/s;

bode(H); grid on