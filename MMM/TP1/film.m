function film(m,k)
%FILM La commande
%   film(m,k)
%  illustre par une animation le calcul de la vibration d'une chaine de
%  N ressorts de raideurs k(i), i=1:N reliant N masses m(i), i=1:N. 
% Cette chaîne est excitée à l'une de ses extrémités par une force, l'autre
%  extrémité étant fixe.
% Les  masses m et les raideurs k peuvent être choisies avec la commande
%  [m,k]=init_ressort(N)

N=size(m,1);

% Préparation des vraies donnees des problemes

[V,D]=spectre(m,k);
lambda=diag(D);

% Calcul des dŽplacements sur un intervalle de temps assez long (1 fois la
%  plus grande période propre de vibration: Nperiode=1) une première fois
%  pour fixer les échelles de l'affichage
% Pour l'instant on suppose que la force est une impulsion unité
Nperiode=5; tmax=Nperiode*2*pi/sqrt(min(lambda));
Ndt=Nperiode*50;  dt=tmax/Ndt;
u=zeros(N,1); umin=0; umax=0;
% Pour accélérer un peu les calculs il vaut mieux introduire la matrice
%  W et le vecteur w suivants:
W=diag(1./sqrt(m))*V*diag(1./sqrt(lambda));
w=V'*[1/sqrt(m(1));zeros(N-1,1)];
for i=1:Ndt
    t=i*dt;
% Version brute en commentaires
%    u=diag(1./sqrt(m))*V...
%        *diag(sin(sqrt(lambda)*t)./sqrt(lambda))...
%        *V'*[1/sqrt(m(1));zeros(N-1,1)];
    u=W*diag(sin(sqrt(lambda)*t))*w;
    umin=min(umin,min(u)); umax=max(umax,max(u));
end
c=max(umax,-umin);
    

% Affichage à la manière d'une chaine de ressorts qui est inutilisable si
%  N est grand (>=25 environ)
% Déplacements longitudinaux
figure(1)
u = zeros(N,1);
s = [1:min(N,25)]';
h=plot(s+u(1:min(N,25))/(2*c),zeros(min(N,25),1),'*:');

axis([0 min(N,25)+1 -c c])
for i=1:Ndt
    pause(0.05)
    drawnow;
    t = i*dt;
    u = W*diag(sin(sqrt(lambda)*t))*w;
    set(h,'XData',s+u(1:min(N,25))/(2*c),'YData',zeros(min(N,25),1));    
end