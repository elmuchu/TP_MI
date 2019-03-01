clc
close all
clear all

L = 0.15;       %longueur de l'eprouvette (m)
rho = 7860.;      %masse volumique (kg.m-3)
C = 480.;        %capacite calorifique (J.kg-1.K-1)
K = 60.;         %constante de diffusivite thermique (W.K-1.m-3)
tau = 85.;        %fuites laterales (s)
lambda = 35.;    %fuites extremales (m-1)



%-------- Q1 --------%

t = 0:0.1:10.;     %vecteur contenant l'intervalle de temps
x = -L/2.:0.00125:L/2.; %vecteur contenant les positions de mesure

vec_omega = [15.413 50.027 88.783 129.19 170.25]; %rad/s vecteur contenant les 5 premieres valeurs verifiant l'equation tan(L*vec_omega/2)=lambda/vec_omega
vec_OMEGA = [32.01 69.084 108.87 149.67 397.94];  %rad/s vecteur contenant les 5 premieres valeurs verifiant l'equation tan(L*vec_OMEGA/2)=vec_OMEGA/lambda

%-------- Q2 --------%

temperatures = load('temperatures.txt'); %matrice contenant les temperatures 
%mesurees experimentalement en fonction de la position et du temps

%figure;
%imagesc(t,x,temperatures);% t et x permettent d'avoir des valeurs physiques sur les axes
%colorbar; % donne une légende, lien etre couleur et température
%colormap('jet'); %permet d'utiliser une palette de couleur plus agéable
%xlabel('temps (s)'); 
%ylabel('x (m)'); %nomme les axes
%title('distribution de la temperature (°c)')

%figure;
%plot(x,temperatures(:,1),x,temperatures(:,51),x,temperatures(:,101)) %affiche les profils de temperature aux temps t=0s, t=5s et t=10s
%xlabel('x (m)');
%ylabel('temperature (°c)');
%legend('t= 0s','t= 5s','t= 10s'); % ajoute une legende
%grid; %affiche une grille

%-------- Q3 --------%

theta_0 = sum(temperatures(:,1)*0.00125)./L; %équivalent à une méthode de rectangle inférieur --- on aurait aussi pu utiliser integrale_trapeze.m

%-------- Q4 --------%

mat_alpha = zeros(length(vec_omega),length(t));
for k=1:length(vec_omega)
    for n=1:length(t)
        mat_alpha(k,n) = sum((temperatures(:,n)-theta_0).*cos(vec_omega(k).*x(:)).*0.00125) ./ (sum(cos(vec_omega(k).*x(:)).*cos(vec_omega(k).*x(:)).*0.00125));
    end % on peut faire qu'avec une boucle sur k
end
%figure;imagesc(mat_alpha);colormap('jet');colorbar;
%title('mat alpha')

mat_beta = zeros(length(vec_OMEGA),length(t));
for l=1:length(vec_OMEGA)
    for n=1:length(t)
        mat_beta(l,n) = sum((temperatures(:,n)-theta_0).*sin(vec_OMEGA(l).*x(:)).*0.00125) ./ sum(sin(vec_OMEGA(l).*x(:)).*sin(vec_OMEGA(l).*x(:)).*0.00125);
    end
end
%figure;imagesc(mat_beta);colormap('jet');colorbar;
%title('mat beta')
%ce sont les coefficients des sinus dans l'écriture de theta(t,x) sous forme
%de DF, la repartition de temperature est symétrique, il ne faut donc pas
%de sinus, ils ne sont pas nuls seulement à cause du bruit dans la mesure

%-------- Q5 --------%

% une seul boucle necessaire


temperatures_approx = 0*temperatures;
 for i=1:length(x)
   for n=1:length(t)
   
 temperatures_approx(i,n) = theta_0 + sum( mat_alpha(:,n).* cos(vec_omega.*x(i))' ) + sum( mat_beta(:,n).*sin(vec_OMEGA.*x(i))' );

    end
end
%figure;imagesc(t,x,temperatures_approx);colormap('jet');colorbar;
%xlabel('temps (s)');
%ylabel('x (m)');
%title('distribution approximée de la temperature (°c)')



laplacien_approx = 0*temperatures;
 for i=1:length(x)
   for n=1:length(t)
   
 laplacien_approx(i,n) = - sum( (vec_omega.*vec_omega)'.*mat_alpha(:,n).* cos(vec_omega.*x(i))' ) - sum( (vec_OMEGA.*vec_OMEGA)'.*mat_beta(:,n).*sin(vec_OMEGA.*x(i))' );
  
    end
end
%figure;imagesc(laplacien_approx);colormap('jet');colorbar;
%title('laplacien approximée de la temperature')

%-------- Q6 --------%

derivee_temporelle_temperatures_approx = 0*temperatures_approx;

for i=1:length(x)
derivee_temporelle_temperatures_approx (i,:)=  derivee(t,temperatures_approx(i,:))' ;

end

%-------- Q7 --------%

S = 0*temperatures;

S = rho*C*( derivee_temporelle_temperatures_approx +  temperatures_approx/tau )- K*laplacien_approx;

%figure;imagesc(t,x,S);colormap('jet');colorbar;
%xlabel('temps (s)'); ylabel('x (m)');


%On peut observer, grace a cette figure, l'evolution du changement de la 
%temperature en fonction du temps et de l'espace.
%Dans un premier temps (0<t<7.5s), la temperature evolue suivant une 
%gaussienne centree en x=0 : la temperature au centre augmente plus vite 
%que sur les bords. De plus, le 'pic' de temperature augmente lui aussi 
%avec le temps.
%Ensuite (7.5<t<9s), les bords de la plaquette refroidissent, faisant ainsi
%descendre la temperature. Plus le temps avance, plus la partie 
%'refroidissante' de la plaquette s'agarandit.
%Finalement (t>=9s), toute la plaquette entre dans une phase de 
%refroidissement. Les bords commencent alors a retrouver une temperature 
%stable.