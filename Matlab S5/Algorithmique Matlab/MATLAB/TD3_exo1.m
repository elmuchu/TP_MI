clear all;
close all;
clc;

%x = linespace(0,pi/2,200);
%y = sin(x);
%plot(x,y,'r*');

%x = linspace(-1,1,200);
%y = 1./(1+x.^2);
%plot(x,y,'r*');


A = textread('Nioh2Raman.txt');
plot(A(:,1),A(:,2));