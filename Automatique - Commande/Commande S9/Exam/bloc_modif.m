function var_sortie = test_dist(var_entree,Xe,Ye,th1,th2,theta,Xd,Yd)
Xr = Xe - l1*cos(theta+th1) - l2*cos(theta+th1+th2);
Yr = Ye - l1*sin(theta+th1) - l2*sin(theta+th1+th2);
dist = (Xr-Xd)^2+(Yr-Yd)^2;
if dist > l1^2+l2^2 % ou dist < l1^2+l2^2
    var_sortie = 0;
else
    var_sortie = var_entree;
end