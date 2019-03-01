%dimensions robot
D = 1.2;
l1 = 0.6;
l2 = 0.75;
%position initiale
Xr0 = 1;
Yr0 = 1;
theta_0 = -pi/6;
th1_0 = -pi/3;
th2_0 = pi/3;
V0 = 0;
Xe0 = Xr0 + l1*cos(theta_0+th1_0) + l2*cos(theta_0+th1_0+th2_0);
Ye0 = Yr0 + l1*sin(theta_0+th1_0) + l2*sin(theta_0+th1_0+th2_0);
%a atteindre
Xd = 6;
Yd = 6;
%appel simulink
sim('simu')
%affichage du mouvement
figure;
for i=1:length(tout)
    %bras
    Xr = Xe(i) - l1*cos(theta(i)+th1(i)) - l2*cos(theta(i)+th1(i)+th2(i));
    Yr = Ye(i) - l1*sin(theta(i)+th1(i)) - l2*sin(theta(i)+th1(i)+th2(i));
    Xa = Xr + l1*cos(theta(i)+th1(i));
    Ya = Yr + l1*sin(theta(i)+th1(i));
    P = [Xr Yr; Xa Ya; Xe(i) Ye(i)];
    %voiture
    XA = Xr + D*cos(theta(i)) - (D/2)*sin(theta(i));
    YA = Yr + D*sin(theta(i)) + (D/2)*cos(theta(i));
    XB = Xr + D*cos(theta(i)) + (D/2)*sin(theta(i));
    YB = Yr + D*sin(theta(i)) - (D/2)*cos(theta(i));
    XC = Xr - (D/4)*cos(theta(i)) + (D/2)*sin(theta(i));
    YC = Yr - (D/4)*sin(theta(i)) - (D/2)*cos(theta(i));
    XD = Xr - (D/4)*cos(theta(i)) - (D/2)*sin(theta(i));
    YD = Yr - (D/4)*sin(theta(i)) + (D/2)*cos(theta(i));
    C = [XA YA; XB YB; XC YC; XD YD; XA YA];
    %roue
    XR1 = Xr + D*cos(theta(i)) + (D/6)*cos(theta(i)+psi(i));
    YR1 = Yr + D*sin(theta(i)) + (D/6)*sin(theta(i)+psi(i));
    XR2 = Xr + D*cos(theta(i)) - (D/6)*cos(theta(i)+psi(i));
    YR2 = Yr + D*sin(theta(i)) - (D/6)*sin(theta(i)+psi(i));
    R = [XR1 YR1; XR2 YR2];
    %affichaqe
    plot(P(:,1),P(:,2),C(:,1),C(:,2),R(:,1),R(:,2),Xd,Yd,'or');
    title(['t = ' num2str(tout(i)) 's']);
    grid on;
    axis([-1 9 -1 7]);
    pause(0.01);
end