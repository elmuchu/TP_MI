clc
clear all
close all

fcost = @(x)(fcost_can(x));
fconst = @(x)(fconst_can(x));
A = [];
b = [];
Aeq = [];
beq = [];
lb = [0.08 0]; %[Hmin Dmin] en m
ub = [0.18 0.1]; %[Hmax Dmax] en m

figure; hold on

%trace de la surface admissible
N = 25; % nb de paves par ligne/colonne
k = 0;
x = zeros(N,1); y = zeros(N,1); T = zeros(N);
Xc = []; Yc = []; Tc = [];
for i=1:N
    x(i) = lb(1) + (i-1)*(ub(1)-lb(1))/(N-1);
    for j=1:N
        y(j) = lb(2) + (j-1)*(ub(2)-lb(2))/(N-1);
        T(j,i) = fcost([x(i) y(j)]);
        if fconst([x(i) y(j)])<0
            k = k+1;
            Xc(k) = x(i);
            Yc(k) = y(j);
            Tc(k) = T(j,i);
        end
    end
end
surf(x,y,T);
plot3(Xc,Yc,Tc,'*g'); 

%cas tests
N = 10; % nb de cas tests
M = zeros(N,8);
for i=1:N
    a_test = rand(1); b_test = rand(1);
    x_test(1) = a_test*lb(1)+(1-a_test)*ub(1); %H initial en m
    y_test(1) = b_test*lb(2)+(1-b_test)*ub(2); %D initial en m
    Tl(1) = fcost([x_test(1) y_test(1)]); %Surface initiale en m^2
    Tm(1) = (-fconst([x_test(1) y_test(1)])+1.5*10^(-3))*10^3; %Volume initial en L
    xfina = fmincon(fcost,[x_test(1) y_test(1)],A,b,Aeq,beq,lb,ub,fconst);
    x_test(2) = xfina(1); %H final
    y_test(2) = xfina(2); %D final
    Tl(2) = fcost([x_test(2) y_test(2)]); %Surface finale
    Tm(2) = (-fconst([x_test(2) y_test(2)])+1.5*10^(-3))*10^3; %Volume final
    M(i,:) = [x_test(1) y_test(1) Tl(1) Tm(1) x_test(2) y_test(2) Tl(2) Tm(2)]; %Matrice regroupant toutes les valeurs initiales et finales
    plot3(x_test,y_test,Tl,'r') %trace des lignes
end
grid on; xlabel('H(cm)'); ylabel('D(cm)'); zlabel('Surface(cm2)')