clear all;
close all;
clc;

x(1) = input('x1 = ');

i=1;
while i<=10
    if mod(x(i),2)==1
        x(i+1)=3*x(i)+1;
    else
        x(i+1)=x(i)/2;
    end;
    i=i+1;
end;
