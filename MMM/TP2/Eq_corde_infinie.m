% ========================
% r�solution de l'�quation des ondes (corde infinie)
% conditions p�riodiques
% d^2 u/dt^2- c^2*d^2 u/dx^2=0
% avec x dans [a,b] et les donn�es initiales 
%       u   (x,0)=ondes_u0(x)
%      du/dt(x,0)=ondes_u1(x)
%----------------------------------------------------

close all; clear all;   

a=0; b=1;       % domaine de d�finition
p=b-a;
c=2;          % vitesse de propagation
taus=p;       % p�riode en espace
taut=p/c;    % p�riode en temps

nx=50;          % nombre d'intervalles en espace 
dx=(b-a)/nx;    % pas de discr�tisation en espace
xx=a+[0:nx]*dx; % points de discr�tisation en espace

% gestion de la p�riodicit� f(b)=f(a)
jn=[1:nx+1];          % indice j   (x_1=a, x_{nx+1}=b)
jj=jn;   jj(nx+1)=1;  % indice j   tenant compte de la p�riodicit�
jp=jj+1; jp(nx)  =1;  % indice j+1 tenant compte de la p�riodicit�
jm=jn-1; jm(1)=nx;    % indice j-1 tenant compte de la p�riodicit�

nt=125;            % nombre de pas de temps sur une p�riode
dt=taut/nt;       % le pas de temps
sigma=abs(c)*dt/dx;    % condition cfl: sigma<=1
fprintf('Nombre CFL sigma=%f \n',sigma);

% conditions initiales
temps=0;
temps=temps+dt;
u0 = ondes_u0(xx); %utiliser ondes_u0
u1 = u0+dt*ondes_u1(xx); %utiliser ondes_u1


% avancement en temps -> 2 p�riodes 
% le vecteur u0 correspond �� u^{n-1}, u1 � u^{n} et u2 �� u^{n+1}
for n=2:2*nt
   temps=temps+dt;
   
   % sch�ma centr�
  
   u2=2*(1-sigma.^2)*u1+sigma.^2*(u1(jm)+u1(jp))-u0; %ui-1 = u1(jm) et ui+1 = u1(jp)
   
   % graphique de la solution (chaque p�riode)
   if(mod(n,nt)==0)
      fprintf('Plot pour n=%f \n',n); 
      figure;
      plot(xx,ondes_u0(xx),'r-',xx,u2,'b-o','LineWidth',2,'MarkerSize',6)
      set(gca,'XTick',a:.2:b,'FontSize',14);   
      title(['temps=' num2str(temps),' CFL=' num2str(sigma)])
      legend('Sol exacte','Sol num');xlabel('x');ylabel('u');grid on
   end
   
   % mise � jour des vecteurs
   u0=u1;
   u1=u2;
end
legend('Sol exacte','Sol num');xlabel('x');ylabel('u');grid on