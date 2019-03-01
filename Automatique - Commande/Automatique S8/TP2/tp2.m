clc
clear all
close all

l1 = 0.65;
l2 = 0.35;

%  2.1
%
% theta1 = [0:0.01:pi];
% theta2 = [-pi/2:0.01:pi/2];
% 
% k=0;
% for i=theta1
%     for j=theta2
%         k = k+1;
%         xr(k) = l1*cos(i)+l2*cos(i+j);
%         yr(k) = l1*sin(i)+l2*sin(i+j);
%     end
% end
% 
% plot(xr,yr); grid on


%  2.2

% xri = [-1:0.01:1];
% yri = [-1:0.01:1];
% 
% k = 0;
% for xr=xri
%     for yr=yri
%         a = xr*xr + yr*yr;
%         b = (a -(l1*l1+l2*l2))/(2*l1*l2);
%         if a<=l1+l2 && abs(b)<=1
%             %coude bas
%             theta2 = acos(b);
%             if all(theta2<=pi/2 && theta2>=-pi/2)
%                 t1 = acos((xr*(l1+l2*cos(theta2))+yr*l2*sin(theta2))/(xr*xr+yr*yr));
%                 t2 = asin((yr*(l1+l2*cos(theta2))-xr*l2*sin(theta2))/(xr*xr+yr*yr));
%                 theta1 = atan2(sin(t2),cos(t1));
%                 if all(theta1<=pi && theta1>=0)
%                     k = k+1;
%                     x(k) = xr; y(k) = yr;
%                 end
%                 %coude haut
%                 theta22 = -acos(b);
%                 t1 = acos((xr*(l1+l2*cos(theta22))+yr*l2*sin(theta22))/(xr*xr+yr*yr));
%                 t2 = asin((yr*(l1+l2*cos(theta22))-xr*l2*sin(theta22))/(xr*xr+yr*yr));
%                 theta12 = atan2(sin(t2),cos(t1));
%                 if all(theta12<=pi && theta12>=0)
%                     k = k+1;
%                     x(k) = xr; y(k) = yr;
%                 end
%             end
%         end
%     end
% end
% plot(x,y,'.'); grid on
        
        
%  2.3.1

% theta1 = [0:0.1:pi];
% theta2 = [-pi/2:0.1:pi/2];
% 
% thetaP1 = 5; thetaP2 = 5;
% 
% figure
% k=0;
% for i=theta1
%     for j=theta2
%         k = k+1;
%         xr(k) = l1*cos(i)+l2*cos(i+j);
%         yr(k) = l1*sin(i)+l2*sin(i+j);
%         
%         J = [-l1*sin(i)-l2*sin(i+j) -l2*sin(i+j)
%             l1*cos(i)+l2*cos(i+j) l2*cos(i+j)];
%         a = J*[thetaP1
%             thetaP2];
%         xrP(k) = a(1); yrP(k) = a(2);
%     end
% end
% 
% quiver(xr,yr,xrP,yrP); axis([-1.1 1.1 -0.5 1.1]); grid on


%  2.3.2

% theta1 = [0:0.1:pi];
% theta2 = [-pi/2:0.1:pi/2];
% 
% xrP = 1; yrP = 0;
% theta1M = zeros(1,length(theta1));
% theta2M = zeros(1,length(theta2));
% hold on
% for i=1:length(theta1)
%     for j=1:length(theta2)
%         J = [-l1*sin(theta1(i))-l2*sin(theta1(i)+theta2(j)) -l2*sin(theta1(i)+theta2(j))
%             l1*cos(theta1(i))+l2*cos(theta1(i)+theta2(j)) l2*cos(theta1(i)+theta2(j))];
%         
%         J1 = inv(J);
%         a = J1*[xrP;
%             yrP];
%         theta1M(i) = a(1); %plot(theta1,theta1M,'*'); grid on
%         theta2M(j) = a(2); plot(theta2,theta2M,'*'); grid on
%     end
% end



% 3.2

% %pris dans le TP1
% Jm(1) = 2.35*10^(-6);   Jm(2) = 1.38*10^(-5);
% fm(1) = 2.11*10^(-5);   fm(2) = 1.22*10^(-4);
% kc(1) = 0.027;          kc(2) = 0.035;
% ke(1) = 0.027;          ke(2) = 0.035;
% R(1) = 0.612;           R(2) = 0.318;
% L(1) = 0.137;           L(2) = 0.0823;
% 
% A1 = [0 1 0
%     0 -fm(1)/Jm(1) kc(1)/Jm(1)
%     0 -ke(1)/L(1) -R(1)/L(1)];
% B1 = [0
%     0 
%     1/L(1)];
% 
% A2 = [0 1 0
%     0 -fm(2)/Jm(2) kc(2)/Jm(2)
%     0 -ke(2)/L(2) -R(2)/L(2)];
% B2 = [0
%     0
%     1/L(2)];
% %fin TP1
% 
% xi = -0.1;   yi = 0.8;   %position initiale
% xr = -0.8;   yr = 0.1; %position finale
% 
% a = xr*xr + yr*yr;
% b = (a -(l1*l1+l2*l2))/(2*l1*l2);
% if  abs(b)<=1
%     %coude bas
%     theta2 = acos(b);
%     if (theta2<=pi/2 && theta2>=-pi/2)
%         t1 = acos((xr*(l1+l2*cos(theta2))+yr*l2*sin(theta2))/(xr*xr+yr*yr));
%         t2 = asin((yr*(l1+l2*cos(theta2))-xr*l2*sin(theta2))/(xr*xr+yr*yr));
%         theta1 = atan2(sin(t2),cos(t1));
%         %coude haut
%         theta22 = -acos(b);
%         t1 = acos((xr*(l1+l2*cos(theta22))+yr*l2*sin(theta22))/a);
%         t2 = asin((yr*(l1+l2*cos(theta22))-xr*l2*sin(theta22))/a);
%         theta12 = atan2(sin(t2),cos(t1));
%     end
% end
% 
% ai = xi*xi + yi*yi;
% bi = (ai -(l1*l1+l2*l2))/(2*l1*l2);
% if  abs(bi)<=1
%     %coude bas
%     theta2i = acos(bi);
%     if (theta2i<=pi/2 && theta2i>=-pi/2)
%         t1 = acos((xi*(l1+l2*cos(theta2i))+yi*l2*sin(theta2i))/ai);
%         t2 = asin((yi*(l1+l2*cos(theta2i))-xi*l2*sin(theta2i))/ai);
%         theta1i = atan2(sin(t2),cos(t1));
%         %coude haut
%         theta22i = -acos(bi);
%         t1 = acos((xi*(l1+l2*cos(theta22i))+yi*l2*sin(theta22i))/ai);
%         t2 = asin((yi*(l1+l2*cos(theta22i))-xi*l2*sin(theta22i))/ai);
%         theta12i = atan2(sin(t2),cos(t1));
%     end
% end
% 
% %theta1i = theta12i; theta2i = theta22i; %coude haut intial
% thetaR1 = [0 theta1-theta1i theta2-theta2i]; %coude bas
% %thetaR1 = [0 theta12-theta1i theta22-theta2i]; %coude haut
% sim('sim1');
% 
% for i=1:length(thetaF1(:,1))
%     xri(i) = l1*cos(thetaF1(i,1)+theta1i)+l2*cos(thetaF1(i,1)+thetaF1(i,2)+theta1i+theta2i);
%     yri(i) = l1*sin(thetaF1(i,1)+theta1i)+l2*sin(thetaF1(i,1)+thetaF1(i,2)+theta1i+theta2i);
%     xmi = l1*cos(thetaF1(i,1)+theta1i);
%     ymi = l1*sin(thetaF1(i,1)+theta1i);
%     %plot([0 xmi xri(i)],[0 ymi yri(i)]); axis([-1.1 1.1 -0.4 1.1]); grid on; pause(0.001);
% end
% 
% plot(tout,xri,tout,yri); grid on; legend(['Position en X';'Position en Y'],'Location','northeast');
% figure; plot(tout,thetaF1(:,1)+theta1i,tout,thetaF1(:,2)+theta2i); grid on; legend(['Theta 1';'Theta 2'],'Location','northeast');
    

%4.2

%pris dans le TP1
Jm(1) = 2.35*10^(-6);   Jm(2) = 1.38*10^(-5);
fm(1) = 2.11*10^(-5);   fm(2) = 1.22*10^(-4);
kc(1) = 0.027;          kc(2) = 0.035;
ke(1) = 0.027;          ke(2) = 0.035;
R(1) = 0.612;           R(2) = 0.318;
L(1) = 0.137;           L(2) = 0.0823;

A1 = [0 1 0
    0 -fm(1)/Jm(1) kc(1)/Jm(1)
    0 -ke(1)/L(1) -R(1)/L(1)];
B1 = [0
    0 
    1/L(1)];

A2 = [0 1 0
    0 -fm(2)/Jm(2) kc(2)/Jm(2)
    0 -ke(2)/L(2) -R(2)/L(2)];
B2 = [0
    0
    1/L(2)];

wo = 1;
ksi = 0.7;
lmb = roots([1/wo.^2 2*ksi/wo 1]);

K1 = place(A1,B1,[lmb(1) lmb(2) 0]);
K2 = place(A2,B2,[lmb(1) lmb(2) 0]);
%fin TP1

xf = 0.5; yf = 0.7;
%xf = -0.8; yf = 0.1;
%xi = 1;      yi = 0;  %marche paaaaaaaaaaaaas theta2 = 0
xi = -0.1; yi = 0.8;

ai = xi*xi + yi*yi;
bi = (ai -(l1*l1+l2*l2))/(2*l1*l2);
if  abs(bi)<=1
    %coude bas
    theta2i = acos(bi);
    if (theta2i<=pi/2 && theta2i>=-pi/2)
        t1 = acos((xi*(l1+l2*cos(theta2i))+yi*l2*sin(theta2i))/ai);
        t2 = asin((yi*(l1+l2*cos(theta2i))-xi*l2*sin(theta2i))/ai);
        theta1i = atan2(sin(t2),cos(t1));
    end
end

Xd = [0 xf yf];
thetaIni1 = [theta1i 0 0];
thetaIni2 = [theta2i 0 0];
sim('sim2');

for i=1:length(thetaF1(:,1))
    xri(i) = l1*cos(thetaF1(i,1))+l2*cos(thetaF1(i,1)+thetaF1(i,2));
    yri(i) = l1*sin(thetaF1(i,1))+l2*sin(thetaF1(i,1)+thetaF1(i,2));
    xmi = l1*cos(thetaF1(i,1));
    ymi = l1*sin(thetaF1(i,1));
    plot([0 xmi xri(i)],[0 ymi yri(i)]); axis([-1.1 1.1 -0.4 1.1]); grid on; pause(0.001);
end

plot(tout,xri,tout,yri); grid on; legend(['Position en X';'Position en Y'],'Location','northeast');
figure; plot(tout,thetaF1(:,1),tout,thetaF1(:,2)); grid on; legend(['Theta 1';'Theta 2'],'Location','northeast');

