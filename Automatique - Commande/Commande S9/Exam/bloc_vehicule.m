function [Xep,Yep] = vehicule(th1,th1p,th2,th2p,V,theta)

Xep = (-l1*sin(theta+th1)-l2*sin(theta+th1+th2))*th1p + (-l2*sin(theta+th1+th2))*th2p + V*cos(theta);
Yep = (l1*cos(theta+th1)+l2*cos(theta+th1+th2))*th1p + (l2*cos(theta+th1+th2))*th2p + V*sin(theta);

end