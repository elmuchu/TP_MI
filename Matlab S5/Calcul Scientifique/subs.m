function subs = subs (y,t,dt,m)

ey = 0.0000001;   %erreur relative sur f
ex = 0.0000001;   %erreur relative sur x
ni = 100;         %nombre d'itérations maximal

x0 = y;         %x(i)
xn = 2*ex;      %x(i+1)
n = 0;      %nombre d'itérations effectuées pour le moment
fp = x0 - racine(y,t,dt,x0);  %f(i)
k = xn-x0;

while(n<ni && ( abs(fp)>ey || abs(k)>ex ))
    xn = racine(y,t,dt,x0);
    fp = x0 - racine(y,t,dt,x0);
    k = xn - x0;
    x0 = xn;
    n = n+1;
end;

subs = xn;

end