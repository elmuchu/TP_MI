function f = fcost_can(x)

H = x(1); D = x(2);
f = 2*pi*(D/2)^2 + pi*D*H; %surface = 2*disque + cylindre

end