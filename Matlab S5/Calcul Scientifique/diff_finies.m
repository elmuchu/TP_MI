clear all
close all
clc

%parametres physiques
x0 = 0;         %debut intervalle
xf = 2*pi;      %fin intervalle

%parametres numeriques
N = [4 5 6 7 8 9 10 20 30 40 50 100 200 250 500 1000]; %nombre de mailles
k = 2;
dx = (xf-x0)./N;
for m=1:length(N)
x = (x0:dx(m):xf-dx(m));
kdx(m) = k*dx(m);

f = exp(j*k*x);         %fonction f
fprime = j*k*f;
%f = sin(x);
%fprime = cos(x);

d1 = df(f,dx(m),1);
d2 = df(f,dx(m),2);
d3 = df(f,dx(m),3);
d4 = df(f,dx(m),4);
d5 = df(f,dx(m),5);

c(m,1)=log(max(d1-fprime));
c(m,2)=log(max(d2-fprime));
c(m,3)=log(max(d3-fprime));
c(m,4)=log(max(d4-fprime));
c(m,5)=log(max(d5-fprime));

E(m,1)=mean(d1./fprime);
E(m,2)=mean(d2./fprime);
E(m,3)=mean(d3./fprime);
E(m,4)=mean(d4./fprime);
E(m,5)=mean(d5./fprime);

ldx(m)=log(dx(m));
end
p1=abs((c(length(N),1)-c(length(N)-1,1))/(ldx(length(N))-ldx(length(N)-1)))
p2=abs((c(length(N),2)-c(length(N)-1,2))/(ldx(length(N))-ldx(length(N)-1)))
p3=abs((c(length(N),3)-c(length(N)-1,3))/(ldx(length(N))-ldx(length(N)-1)))
p4=abs((c(length(N),4)-c(length(N)-1,4))/(ldx(length(N))-ldx(length(N)-1)))
p5=abs((c(length(N),5)-c(length(N)-1,5))/(ldx(length(N))-ldx(length(N)-1)))
%plot(ldx,c1,ldx,c2-1,ldx,c3,ldx,c4-1,ldx,c5);

plot(kdx,real(E(:,1)),kdx,real(E(:,2)),kdx,real(E(:,3)),kdx,real(E(:,4)),kdx,real(E(:,5)))
title('Re')
grid on
figure
plot(kdx,imag(E(:,1)),kdx,imag(E(:,2)),kdx,imag(E(:,3)),kdx,imag(E(:,4)),kdx,imag(E(:,5)))
title('Im')
grid on