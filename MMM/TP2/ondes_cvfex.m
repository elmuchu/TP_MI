
function y=ondes_cvfex(x,t,c,ks,as)
% solution exacte pour la corde vibrante

  y=zeros(1,length(x));
for k=ks
   y=y + (2*integral(@(h)ondes_cvf0(h,ks,as).*sin(k*pi()*h),0,1)*cos(k*pi()*c*t) + 2/(k*pi()*c)*integral(@(h)ondes_u1(h).*sin(k*pi()*h),0,1)*sin(k*pi()*c*t))*sin(k*pi()*x);
end