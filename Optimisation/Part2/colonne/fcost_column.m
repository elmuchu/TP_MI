function M = fcost_column(x)

global L rho

Ri = x(1); Re = x(2);
M = rho*L*pi*(Re^2-Ri^2); % Masse

end