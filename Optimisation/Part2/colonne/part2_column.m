clc
clear all
close all

global P E L sigma_a rho epsi

L = 10; % en m
rho = 7850; % en kg/m^3
E = 210*10^9; % en Pa
P = 14*10^3; % en N
sigma_a = 0.5*10^6; % en Pa
epsi = 0.1;

fcost = @(x)(fcost_column(x));
fconst = @(x)(fconst_column(x));
A = [];
b = [];
Aeq = [];
beq = [];
lb = [0 0]; %[Ri Re]
ub = [0.4 0.4];

figure; hold on

%trace de la surface et des solutions possibles (pts verts)
N = 50; % nb de paves par ligne/colonne
k = 0;
x = zeros(N,1); y = zeros(N,1); T = zeros(N);
Xc = []; Yc = []; Tc = [];
for i=1:N
    x(i) = lb(1) + (i-1)*(ub(1)-lb(1))/(N-1);
    for j=1:N
        y(j) = lb(2) + (j-1)*(ub(2)-lb(2))/(N-1);
        T(j,i) = fcost([x(i) y(j)]);
        R = fconst([x(i) y(j)]);
        [~,m] = size(R);
        p=0;
        for t = 1:m %verification de chaque fct contrainte
            if R(t)<0
                p=p+1;
            end
        end
        if p==m %si toutes les contraintes sont ok
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
N = 5; % nb de cas tests
M = zeros(N,6);
for i=1:N
    a_test = rand(1); b_test=1;
    while b_test>a_test % verification Rext>Rint
        b_test = rand(1);
    end
    x_test(1) = a_test*lb(1)+(1-a_test)*ub(1); % Rint initital
    y_test(1) = b_test*lb(2)+(1-b_test)*ub(2); % Rext initial
    Tl(1) = fcost([x_test(1) y_test(1)]); % Masse initiale
    xfina = fmincon(fcost,[x_test(1) y_test(1)],A,b,Aeq,beq,lb,ub,fconst);
    x_test(2) = xfina(1); % Rint final
    y_test(2) = xfina(2); % Rext final
    Tl(2) = fcost([x_test(2) y_test(2)]); % Masse finale
    M(i,:) = [x_test(1) y_test(1) Tl(1) x_test(2) y_test(2) Tl(2)]; % Matrice des valeurs initiales et finales
    plot3(x_test,y_test,Tl,'r','linewidth',2); % trace des lignes
end
grid on; xlabel('Ri(m)'); ylabel('Re(m)'); zlabel('Poids(kg)')