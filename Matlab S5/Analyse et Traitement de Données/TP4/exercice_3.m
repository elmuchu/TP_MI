clear all
close all
clc

%----Q1----

%theta = 2.8:0.001:3.2;
%f = 0.5*(1+0.5)+(0.5-1)*atan((theta-3)./0.01)./pi();

%plot(theta,f);

%Ymin = valeur minimale atteinte par f
%Ymax = valeur maximale atteinte par f
%theta0 = valeur de theta à laquelle f = (Ymax+Ymin)/2 (~passage de Ymax à Ymin)
%gamma : plus gamma est petit, plus la f va passer 'vite' de Ymax à Ymin


%----Q3----

K = load('transvit.txt');
X = K(:,1);
F = K(:,2);
clear K
plot(X,F)

%----Q4----

hold on
beta = fminsearch(@(beta)std(ma_fonction(X,beta) - F),[5000 0 100 0.5])
%on cherche a minimiser l'ecart-type entre les valeurs mesurees et la
%fonction 'approchee'
plot(X,ma_fonction(X,beta))
