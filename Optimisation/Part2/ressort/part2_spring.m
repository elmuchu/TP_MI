clc
clear all
close all

fcost = @(x)(fcost_spring(x));
fconst = @(x)(fconst_spring(x));
A = [];
b = [];
Aeq = [];
beq = [];
lb = [0.05 0.25 2];
ub = [2 1.3 15];

N = 10;
for i=1:N
    a_test = rand(1,3);
    x0(i,:) = a_test(:).*lb(:)+(1-a_test(:)).*ub(:);
    [xfin(i,:), fval(i)] = fmincon(fcost,x0(i,:),A,b,Aeq,beq,lb,ub,fconst);
end
