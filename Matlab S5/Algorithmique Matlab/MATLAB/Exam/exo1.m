clear all
close all
clc

%----Q1-----

epsilon = 10.^(-3);
S = 2;
x = 1;

while abs(x.^2 - S) > epsilon
    x = 0.5*(x+S./x);
end

%----Q2----

clear x
i = 1;
x(1) = 1;

while i<20
    i = i+1;
    x(i) = 0.5*(x(i-1)+S./x(i-1));
end

plot(x)
