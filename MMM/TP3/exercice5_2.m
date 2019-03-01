clear all
close all
clc

xi = 0;
xf = 6;
taux = 100; %nombre de points en x

yi = 0;
yf = 6;
tauy = 100; %nombre de points en y

dx = (xf-xi)./(taux-1);
dy = (yf-yi)./(tauy-1);
x = [xi:dx:xf];
y = [yi:dy:yf];

A = zeros(taux*tauy,taux*tauy);
B = zeros(taux*tauy,1);

for i=1:taux
    for j=1:tauy
        k = j+(i-1)*tauy;
        if i==1 || j==1 || i==taux
            A(k,k) = 1;
        elseif j==tauy
            A(k,k) = 1;
            B(k) = (sin(x(i)*pi/3)).^2;
        else
            A(k,j+(i-2)*tauy) = 1./(dx.^2);
            A(k,j-1+(i-1)*tauy) = 1./(dy.^2);
            A(k,j+(i-1)*tauy) = -2./(dy.^2)-2./(dx.^2);
            A(k,j+1+(i-1)*tauy) = 1./(dy.^2);
            A(k,j+i*tauy) = 1./(dx.^2);
        end
    end
end

X = linsolve(A,B);

u = zeros(taux,tauy);

for i=1:taux
    for j=1:tauy
        k = j+(i-1)*tauy;
        u(i,j) = X(k);
    end
end

surf(x,y,u,'EdgeColor','none'); colorbar
figure
imagesc(x,y,u); colormap('jet'); colorbar