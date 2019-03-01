clear all
close all
clc

%----Q1----

X = -2:0.01:2;
f = @(x)1./(0.25+x.^2); % On calcule la fonction

plot(X,f(X))

%----Q2----

hold on
Y = (2/7)*(-7:7);       % On calcule le nouvel intervalle
plot(X,polyval(polyfit(Y,f(Y),14),X)); %On trace le polynôme de degré 14 qui a tout les points dans l'intervalle Y en commun avec la fonction 


%----Q3----

figure;
plot(X,f(X),X,polyval(polyfit(X,f(X),15),X)); % On trace le polynôme de meilleure approximation de degré 15 sur l'intervalle x 