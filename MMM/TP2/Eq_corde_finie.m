% ========================
% r�solution de l'�quation des ondes (corde vibrante finie)
% d^2 u/dt^2- c^2*d^2 u/dx^2=0
% avec x dans [0,l] et les donn�es initiales 
%       u   (x,0)=ondes_cvf0(x)
%      du/dt(x,0)=0
% CONDITIONS AUX LIMITES u(0,t)=u(l,t)=0
%----------------------------------------------------

close all; clear all;   

l=1;           % longueur de la corde
c= 2;            % vitesse de propagation
taut=l/c;    % p�riode en temps

nx=50;           % nombre d'intervalles en espace
dx=l/nx;        % pas de discr�tisation en espace
xx=[0:nx]*dx;    % points de discr�tisation en espace

nt=125;            % nombre de pas de temps sur une p�riode
dt=taut/nt;       % le pas de temps
sigma=abs(c)*dt/dx;    % condition cfl: sigma<=1
fprintf('Nombre CFL sigma=%f \n',sigma);

% conditions initiales
ks =[2,10];       % les nombres d'onde dans la d�composition
as =[1,0.25];     % les amplitudes des ondes correspondantes

temps=0;
u0 =ondes_cvf0(xx,ks,as);   %utiliser ondes_cvf0
temps=temps+dt;
u1=u0+dt*ondes_u1(xx);
u2=zeros(nx+1,1);



% avancement en temps -> 1 p�riode
% le vecteur u0 correspond � u^{n-1}, u1 � u^{n} et u2 � u^{n+1}
for n=2:nt
   temps=temps+dt;
   
   % sch�ma centr�
   % on calcule seulement les points 2,....,nx
   u2(1) = 0;
   u2(nx+1) = 0;
   for i=2:nx
       u2(i) = 2*(1-sigma.^2)*u1(i)+sigma.^2*(u1(i-1)+u1(i+1))-u0(i);
   end
   
   % graphique de la solution (temps interm�diares)
   if(mod(n,25)==0)
      uex=ondes_cvfex(xx,temps,c,ks,as);    % solution exacte utiliser ondes_cvfex
      figure;
      plot(xx,uex,'r-',xx,u2,'b-o','LineWidth',2,'MarkerSize',4)
      set(gca,'XTick',0:.2:1,'FontSize',14);   
      title(['temps=' num2str(temps),' CFL=' num2str(sigma)])
      legend('Sol exacte','Sol num');xlabel('x');ylabel('u');grid on
   end
   
   % mise � jour des vecteurs
   u0=u1;
   u1=u2;
end
