clear all;
close all;
clc;

A = textread('Nioh2Raman.txt');
[k,l] = size(A);

for b=2:k-1
    Yp(b) = 0.5*(((A(b+1,2)-A(b,2))/(A(b+1,1)-A(b,1))) + ((A(b,2)-A(b-1,2))/(A(b,1)-A(b-1,1))));
end
Yp(1) = (A(2,2)-A(1,2))/(A(2,1)-A(1,1));
Yp(k) = (A(k,2)-A(k-1,2))/(A(k,1)-A(k-1,1));

subplot(2,1,1);
plot(A(:,1),A(:,2));
subplot(2,1,2);
plot(A(:,1),Yp);