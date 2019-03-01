function dicho = dicho(y,t,dt,m)

ey = 0.000001;
ex = 0.000001;
nmax = 100;

%a = f(1,1), f(a) = f(1,2) = racine(y,t,dt,a) = racine(y,t,dt,f(1,1),m)

f(1,1) = y;
f(2,1) = 10*y;
f(1,2) = f(1,1) - racine(y,t,dt,f(1,1));
f(2,2) = f(2,1) - racine(y,t,dt,f(2,1));

if f(1,2)*f(2,2) > 0
    f(1,1) = -f(2,1);
end;

e = abs(f(1,1)-f(2,1));
k = abs(f(1,2)-f(2,2));
n = 0;

while (n<nmax) && ((e>ex) || (k>ey))
    f(3,1) = (f(1,1)+f(2,1))/2;
    f(3,2) = f(3,1) - racine(y,t,dt,f(3,1));
    if f(1,2)*f(3,2) > 0
        f(1,1) = f(3,1);
    elseif f(1,2)*f(3,2) < 0
        f(2,1) = f(3,1);
    end;
    n = n+1;
    e = abs((f(1,1)-f(2,1))/2);
    k = abs((f(1,2)+f(2,2))/2);
    f(1,2) = f(1,1) - racine(y,t,dt,f(1,1));
    f(2,2) = f(2,1) - racine(y,t,dt,f(2,1));
    e = abs(f(1,1)-f(2,1));
    k = abs(f(1,2)-f(2,2));
end;

dicho = (f(1,1)+f(2,1))/2;

end