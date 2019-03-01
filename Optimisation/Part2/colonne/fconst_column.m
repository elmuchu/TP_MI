function [c,ceq] = fconst_column(x)

global P E L sigma_a epsi

Ri = x(1); Re = x(2);

S = pi*(Re^2-Ri^2); % Surface
I = pi*((2*Re)^4-(2*Ri)^4)/32; % Moment d'inertie axial
Pc = (pi^2)*E*I/(4*L^2); % Charge supportable
sigma = P/S; % Pression axiale appliquée

c(1) = P-Pc; % Charge appliquée < Charge supportable
c(2) = sigma-sigma_a; % Pression axiale appliquée < Pression axiale supportable
c(3) = Ri-Re+epsi*(Re+Ri)/2; % Contrainte de dimension : Rext > Rint + Epsi*(moyenne des rayons)

ceq = [];

end