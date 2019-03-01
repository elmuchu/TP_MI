function [th1p,th2p,Vd,thetaPd] = controle(XepD,YepD,theta,th1,th2,psid)

Vd = sqrt(XepD^2+YepD^2);
thetaPd = Vd*tan(psid)/D;

A = [-l1*sin(theta+th1)-l2*sin(theta+th1+th2) -l2*sin(theta+th1+th2)
    l1*cos(theta+th1)+l2*cos(theta+th1+th2) l2*cos(theta+th1+th2) ];

res = inv(A)*[XepD;YepD];
th1p = res(1); th2p = res(2);
end