clear all
close all
clc

t0 = 0;
tfinal = 10;
y0 = [1 1];


[t,y] = ode23('oscillateur_amorti',[t0 tfinal],y0);

plot(t,y(:,1))