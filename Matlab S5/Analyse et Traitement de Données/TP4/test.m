clear all
close all
clc


X=-2:0.01:2;

F1 = X.^2;
F2 = X.^3;
F3 = sin(X);

A1 = approx(X,F1,3);
A2 = approx(X,F2,3);
A3 = approx(X,F3,3);

plot(X,F1,X,polyval(A1,X)); figure
plot(X,F2,X,polyval(A2,X)); figure
plot(X,F3,X,polyval(A3,X));