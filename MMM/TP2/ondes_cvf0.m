function y=ondes_cvf0(x,ks,as)
% condition u(x,0) pour la corde vibrante finie
  
  y=zeros(1,length(x));
for k=1:length(ks)
   y=y+as(k)*sin(ks(k)*pi()*x);
end