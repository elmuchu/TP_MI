clear all;
close all;
clc;

x = linspace(0,pi/2,200);
y = sin(x);

d = pi/398;
I = 0;
for b=1:199
    I = I + d*y(b);
end;

T = 0;
for c=1:199
    T = T + d*0.5*(y(c+1)+y(c));
end;

disp(I);
disp(T);
