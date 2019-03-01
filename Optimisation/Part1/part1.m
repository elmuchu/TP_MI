clc
clear all
close all

global x0 kmax thresh

x0 = [-10 -10]';
kmax = 1e6;
thresh = 1e-5;

num_f = 2; % 1 ou 2

if num_f==1
    f = @(x)(f1(x));
    fi = @(x1,x2)(2*x1^2+x2^2-2*x1*x2-x1-x2);
else
    f = @(x)(f2(x));
    fi = @(x1,x2)((x1-1).^2+5*((x1.^2-x2).^2));
end

figure; hold on; grid on

xfin = grad_simple(f);
xfin1 = xfin; clear xfin

xfin = grad_conj(f);
xfin2 = xfin; clear xfin

xfin = quasiNewt(f);
xfin3 = xfin; clear xfin

plot(xfin1(1,:),xfin1(2,:),'b',xfin2(1,:),xfin2(2,:),'r',xfin3(1,:),xfin3(2,:),'y',x0(1),x0(2),'*k');

ezcontour(fi,[-11 3 -60 60]); grid on;
legend({'Gradient simple','Gradient conjugue','Quasi-Newton','x0','Courbe de niveaux de f'},'Location','northeast');