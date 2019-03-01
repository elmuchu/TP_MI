clear all 
close all
clc

t=linspace(0,1,100);
y=exp(-t/0.314)+0.05*2*(rand(1,100)-0.5);

start=[0]; 
tau_est = fminsearch(@(x)fitfun(x,t,y),start)

plot(t,y,'o',t,exp(-t/tau_est),'r')
