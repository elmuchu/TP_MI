clear all;
close all;
clc;

t0 = 0;
tf = 10;
y0 = Yex(t0);
%meth = 0; %1=Euler explicite, 2=Euler implicite, 3=Adams-Bashforth, 4=RK2, 5=RK4

N = [100 200 250 400 500 750 1000 1250 1500 1750 2000];
for i=1:length(N)
    dt(i) = (tf-t0)/N(i);
end;

for g=1 : 5
    meth = g;
if meth~=3
    for k=1 : length(dt)
    j = dt(k);
    y(1) = y0;
    tnum(1)=t0;
    for i=1 : N(k)
        if meth==1  %Euler explicite
            phi = Y(tnum(i),y(i));
            y(i+1) = y(i) + j*phi;
        end;
    
        if meth==2  %Euler implicite
            %y(i+1) = subs(y(i),tnum(i)+j,j); %methode de la
            %substitution
            y(i+1) = dicho(y(i),tnum(i)+j,j); %methode de la dichotomie
        end;
    
        if meth==4  %Runge Kutta 2
            k1 = Y(tnum(i),y(i));
            phi = Y(tnum(i)+0.5*j,y(i)+0.5*k1*j);
            y(i+1) = y(i) + j*phi;
        end;
    
        if meth==5  %Runge Kutta 4
            k1 = Y(tnum(i),y(i));
            k2 = Y(tnum(i)+0.5*j,y(i)+0.5*k1*j);
            k3 = Y(tnum(i)+0.5*j,y(i)+0.5*k2*j);
            k4 = Y(tnum(i)+j,y(i)+j*k3);
            y(i+1) = y(i) + j*(k1+2*k2+2*k3+k4)/6;
        end;
    
        tnum(i+1) = tnum(i)+j;
    end;
    yn(k) = y(N(k)+1);
    end;
else %Adams Bashforth
    for k=1 : length(dt)
        j = dt(k);
        y(1) = y0;
        tnum(1)=t0;
        phi = Y(tnum(1),y(1));  %
        y(2) = y(1) + j*phi;    %Calcul de y(2) par Euler explicite
        tnum(2) = tnum(1)+j;    %
        for i=2 : (tf-t0)/j
            phi = 0.5*(3*Y(tnum(i),y(i))-Y(tnum(i-1),y(i-1)));
            y(i+1) = y(i) + j*phi;
            tnum(i+1) = tnum(i)+j;
        end;
        yn(k) = y(N(k)+1);
    end;
end;
r(g,:) = log(abs(yn-Yex(tf)));
p(g) = abs((log(abs(yn(length(N))-Yex(tf)))-log(abs(yn(length(N)-1)-Yex(tf))))/(log(dt(length(N)))-log(dt(length(N)-1))));
end;

r(2,:) = r(2,:)-1; %pour mieux voir la courbe de l'ordre d'Euler implicite
plot(log(dt),r);
p

%plot(tnum,y);
grid on;

