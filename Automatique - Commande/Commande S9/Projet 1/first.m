clc
clear all
close all

%parametres du robot
le = 0.3; l1 = 0.7; l2 = 0.4; l3 = 0.3; l4 = 0.4; l5 = 0.3;
c1 = 0.6; c2 = 0.2; c3 = 0.15; c4 = 0.2; c5 = 0.15;
m1 = 20; m2 = 6; m3 = 4; m4 = 6; m5 = 4;
K1 = 10; tau1 = 0.1;

%valeurs desirees
CDMv = 0; PLv = 1; PRv = -0.9;

%angles initiaux
th1_0 = 0; th2_0 = -pi/4; th3_0 = -pi/4; th4_0 = pi/4; th5_0 = pi/4;

%simulation
sim('sim');

%affichage du deplacement du robot
 figure; 
for i=1:length(TH1(:,1))
    
    th1 = TH1(i); th2 = TH2(i); th3 = TH3(i); th4 = TH4(i); th5 = TH5(i);
    
    Xl = [-l1*sin(th1)+(le/2)*cos(th1)+l2*cos(-th1+th2)+l3*cos(-th1+th2-th3)
        l1*cos(th1)+(le/2)*sin(th1)-l2*sin(-th1+th2)-l3*sin(-th1+th2-th3) ];

    Xr = [-l1*sin(th1)-(le/2)*cos(th1)-l4*cos(-th1+th4)-l5*cos(-th1+th4-th5)
        l1*cos(th1)-(le/2)*sin(th1)+l4*sin(-th1+th4)+l5*sin(-th1+th4-th5) ];

    H = [0 0]';
    o = [-l1*sin(th1) l1*cos(th1) ]';

    a = [-l1*sin(th1)+(le/2)*cos(th1) l1*cos(th1)+(le/2)*sin(th1) ]';
    b = [-l1*sin(th1)+(le/2)*cos(th1)+l2*cos(-th1+th2) l1*cos(th1)+(le/2)*sin(th1)-l2*sin(-th1+th2) ]';
    K = [H o a b Xl];

    c = [-l1*sin(th1)-(le/2)*cos(th1) l1*cos(th1)-(le/2)*sin(th1) ]';
    d = [-l1*sin(th1)-(le/2)*cos(th1)-l4*cos(-th1+th4) l1*cos(th1)-(le/2)*sin(th1)+l4*sin(-th1+th4) ]';
    L = [H o c d Xr];

    oc1 = [-c1*sin(th1) c1*cos(th1)]';
    oc2 = [-l1*sin(th1)+(le/2)*cos(th1)+c2*cos(-th1+th2) l1*cos(th1)-(le/2)*sin(-th1)-c2*sin(-th1+th2) ]';
    ocL = [-l1*sin(th1)+(le/2)*cos(th1)+l2*cos(-th1+th2)+c3*cos(-th1+th2-th3)
        l1*cos(th1)-(le/2)*sin(-th1)-l2*sin(-th1+th2)-c3*sin(-th1+th2-th3) ];
    oc4 = [-l1*sin(th1)-(le/2)*cos(th1)-c4*cos(-th1+th4) l1*cos(th1)+(le/2)*sin(-th1)+c4*sin(-th1+th4) ]';
    ocR = [-l1*sin(th1)-(le/2)*cos(th1)-l4*cos(-th1+th4)-c5*cos(-th1+th4-th5)
        l1*cos(th1)+(le/2)*sin(-th1)+l4*sin(-th1+th4)+c5*sin(-th1+th4-th5) ];

    CDM = (m1*oc1+m2*oc2+m3*ocL+m4*oc4+m5*ocR)/(m1+m2+m3+m4+m5);

    R = [H o a b Xl b a c d Xr];
    plot(R(1,:),R(2,:),CDM(1),CDM(2),'*');
    
    axis([-1.5 1.5 0 2.5]); grid on; pause(0.1);
end