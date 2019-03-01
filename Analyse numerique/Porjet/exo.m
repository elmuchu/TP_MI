clear all
close all

g = 9.81;

x0 = -10;
xf = 10;
Nx = 500;
dx = (xf-x0)/Nx;
x = [x0:dx:xf];
xtilde = [x0-(dx/2):dx:xf+(dx/2)];

t0 = 0;
tf = 3;

lbd1 = @(u,h)(u+sqrt(g*h));
lbd2 = @(u,h)(u-sqrt(g*h));

h = zeros(length(x),1);
u = h;
for xi=1:length(x)
    h(xi,1) = (1/dx)*quadv(@f,xtilde(xi),xtilde(xi+1));
end

t = 0; n = 0;
% hfigure = figure;
% str = [];
% k = 1;
while t<tf
    n = n+1;
    dt = max((dx/2)/max(abs(lbd1(u(:,n),h(:,n))),abs(lbd2(u(:,n),h(:,n)))));
    
    U = @(i,n)([h(i,n)
        h(i,n).*u(i,n)]);
    maxLbd = @(u,v)(max(max(abs(lbd1(u(2)/u(1),u(1))),abs(lbd1(v(2)/v(1),v(1)))),max(abs(lbd2(u(2)/u(1),u(1))),abs(lbd2(v(2)/v(1),v(1))))));
    F = @(u)([u(2)
        (u(2).^2)/u(1)+g/2*u(1).^2]);
    G = @(u,v)(0.5*(F(u)+F(v)-(v-u)*maxLbd(u,v)));
    
    for i=2:length(x)-1
        P = U(i,n)-(dt/dx).*(G(U(i,n),U(i+1,n))-G(U(i-1,n),U(i,n)));
        h(i,n+1) = P(1);
        u(i,n+1) = P(2)/P(1);
    end
    h(1,n+1) = h(2,n+1); u(1,n+1) = u(2,n+1);
    h(length(x),n+1) = h(length(x)-1,n+1); u(length(x),n+1) = u(length(x)-1,n+1);
    
    Wexxt = Wex(t,x);
    %plot(x,h(:,n),'r.',x,Wexxt(1,:),'r',x,u(:,n),'b.',x,Wexxt(2,:),'b')
    %legend({'Hauteur calculee','Hauteur exacte','Vitesse calculee','Vitesse exacte'})
    %pause(0.001)
    
%     if n==1 || mod(n,250) == 0
%         hplot1(k) = plot(x,u(:,n));
%         hold on
%         str1 = strcat({'t = '},strcat(num2str(ceil(t)),{'s'}));
%         str = [str,
%             str1];
%         hplot2(k) = plot(x,Wexxt(2,:),'--');
%         hold on
%         hlegend1 = legend(hplot1,str,'Location','southwest');
%         hlegend2 = legend([hplot1(1), hplot2(1)],{'Valeur numerique','Valeur analytique'},'Location','southeast');
%         title('Evolution de la vitesse de l''eau en fonction du temps');
%         xlabel('Espace (en m)')
%         ylabel('Vitesse (en m/s)')
%         k = k+1;
%    end

    t = t+dt;
end

