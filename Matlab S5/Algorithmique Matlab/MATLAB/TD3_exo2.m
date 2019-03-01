clear all;
close all;
clc;

%x = linspace(0,pi/2,200);
%y = 0.5*(((sin(x+(pi/400))-sin(x))/(pi/400))+((sin(x))-sin(x-(pi/400)))/(pi/400));
%plot(x,y);

d = 1/100;
x = linspace(-1,1,200);
y = 0.5*(((1./(1+(x+d).^2))-(1./(1+x.^2)))/d + (((1./(1+x.^2))- (1./(1+(x-d).^2)))/d));
plot(x,y);