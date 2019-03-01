clc
clear all
close all

%robot
D = 1;
l1 = 0.8;
l2 = 0.55;

%initial
Xr0 = 1;
Yr0 = 1;
theta_0 = pi/3;
th1_0 = pi/3;
th2_0 = pi/3;
V0 = 0;

Xe0 = Xr0 + l1*cos(theta_0+th1_0) + l2*cos(theta_0+th1_0+th2_0);
Ye0 = Yr0 + l1*sin(theta_0+th1_0) + l2*sin(theta_0+th1_0+th2_0);

%a atteindre
Xd = 2.2;
Yd = 0.7;

sim('simu')
%sim('Copy_of_simu')

figure;
t = -1;
thresh = 0.01;
for i=1:length(Xe)
    %if (tout(i)-t)>thresh
        %bras
        Xr = Xe(i) - l1*cos(theta(i)+th1(i)) - l2*cos(theta(i)+th1(i)+th2(i));
        Yr = Ye(i) - l1*sin(theta(i)+th1(i)) - l2*sin(theta(i)+th1(i)+th2(i));
        Xa = Xr + l1*cos(theta(i)+th1(i));
        Ya = Yr + l1*sin(theta(i)+th1(i));
        P = [Xr Yr
            Xa Ya
            Xe(i) Ye(i)];
        XR(i) = Xr;
        YR(i) = Yr;
        %voiture
        XA = Xr + D*cos(theta(i)) - (D/2)*sin(theta(i));
        YA = Yr + D*sin(theta(i)) + (D/2)*cos(theta(i));
        XB = Xr + D*cos(theta(i)) + (D/2)*sin(theta(i));
        YB = Yr + D*sin(theta(i)) - (D/2)*cos(theta(i));
        XC = Xr - (D/4)*cos(theta(i)) + (D/2)*sin(theta(i));
        YC = Yr - (D/4)*sin(theta(i)) - (D/2)*cos(theta(i));
        XD = Xr - (D/4)*cos(theta(i)) - (D/2)*sin(theta(i));
        YD = Yr - (D/4)*sin(theta(i)) + (D/2)*cos(theta(i));
        C = [XA YA
            XB YB
            XC YC
            XD YD
            XA YA];
        %roue
        XR1 = Xr + D*cos(theta(i)) + (D/6)*cos(theta(i)+psi(i));
        YR1 = Yr + D*sin(theta(i)) + (D/6)*sin(theta(i)+psi(i));
        XR2 = Xr + D*cos(theta(i)) - (D/6)*cos(theta(i)+psi(i));
        YR2 = Yr + D*sin(theta(i)) - (D/6)*sin(theta(i)+psi(i));
        R = [XR1 YR1
            XR2 YR2];
        %plot
        plot(P(:,1),P(:,2),C(:,1),C(:,2),R(:,1),R(:,2),Xd,Yd,'or');
        title(['t = ' num2str(tout(i)) 's']);
        grid on;
        axis([-1 9 -1 7]);
        pause(0.01);
        %pause((tout(i)-t)/2);
        %t = tout(i);
    %end
end
figure; plot(tout,th1,tout,th2,tout,theta,tout,psi); grid on; legend('theta 1','theta 2','theta','psi'); xlabel('temps (s)'); ylabel('angle (rad)')
figure; plot(tout,Xe,tout,Ye); grid on; xlabel('temps (s)'); ylabel('position (m)'); legend('Xe','Ye')
figure; plot(tout,V); grid on; xlabel('temps (s)'); ylabel('vitesse V (m/s)')
figure; plot(Xe,Ye,'*b',XR,YR,'*r'); grid on; title('trajectoire'); xlabel('X (m)'); ylabel('Y (m)'); axis([-1 9 -1 7]); legend('bout du bras','base du bras')
