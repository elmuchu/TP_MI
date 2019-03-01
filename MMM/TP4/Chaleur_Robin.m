clear all
close all
clc

c = 5;  %coefficient de diffusion
CFL = 2*c./(2*c+1); %coefficient de Courant-Fredrichs-Lewy

Nx = 40;    %Nombre de mailles -1 en espace
dx = 1./Nx; %Increment d'espace
x = [0:dx:1];   %Vecteur d'espace

Nt = 1000;  %Nombre de mailles -1 en temps
dt = CFL*dx.^2./(2*c);  %Increment de temps
t = [0:Nt]*dt;  %Vecteur de temps

r = c*dt/(dx.^2);   %voir question 1

%creation des matrices M et N
e = ones(Nx+1,1);
theta = [0 1 0.5];
for i=1:length(theta)
    N(i,:) = [(1-theta(i))*r 1-2*(1-theta(i))*r (1-theta(i))*r];
    M(i,:) = [-theta(i)*r 1+2*theta(i)*r -theta(i)*r];
end
o = input('Methodes : 1 = Euler Explicte, 2 = Euler Implicite, 3 = Crank Nicolson ? ');
M = spdiags([M(o,1)*e M(o,2)*e M(o,3)*e],-1:1,Nx+1,Nx+1);
N = spdiags([N(o,1)*e N(o,2)*e N(o,3)*e],-1:1,Nx+1,Nx+1);

%creation de la matrice F et du vecteur u0
k = input('Cas ? ');
f = zeros(Nx+1,Nt+1);
u0 = zeros(Nx+1,1);
for i=1:length(x)
    if k==1
        if x(i)<0.75 && x(i)>0.25
            u0(i) = 1;
        end
    elseif k==2
        f(i,:) = 20*sin(pi*x(i));
        if x(i)<0.5
            u0(i) = 1;
        end
    elseif k==3
        for j=1:length(t)
            f(i,j) = (t(j)/2)*exp(-4096*((x(i)-0.5).^2));
        end
        u0(i) = 1+x(i)-sin(pi*x(i))-0.25*sin(10*pi*x(i));
    end
end

%creation de la matrice contenant les differents vecteurs Un
u = zeros(Nx+1,Nt+1); u(:,1) = u0;

%application des conditions limites de Robin
M(1,:) = 0; M(Nx+1,:) = 0; N(1,:) = 0; N(Nx+1,:) = 0;
if k==1
    f(1,:) = 0; f(Nx+1,:) = 0;
    M(1,1) = 0.2+1./dx; M(1,2) = -1./dx; M(Nx+1,Nx) = -1./dx; M(Nx+1,Nx+1) = 0.2+1./dx;
    N(1,1) = 0.2+1./dx; N(1,2) = -1./dx; N(Nx+1,Nx) = -1./dx; N(Nx+1,Nx+1) = 0.2+1./dx;
elseif k==2
    f(1,:) = 1; f(Nx+1,:) = 0;
    M(1,1) = 1+1./dx; M(1,2) = -1./dx; M(Nx+1,Nx) = -2./dx; M(Nx+1,Nx+1) = (1/7)+2./dx;
    N(1,1) = 1+1./dx; N(1,2) = -1./dx; N(Nx+1,Nx) = -2./dx; N(Nx+1,Nx+1) = (1/7)+2./dx;
elseif k==3
    f(1,:) = -0.5; f(Nx+1,:) = -0.5;
    M(1,1) = 1+1./dx; M(1,2) = -1./dx; M(Nx+1,Nx) = -1./dx; M(Nx+1,Nx+1) = 1+1./dx;
    N(1,1) = 1+1./dx; N(1,2) = -1./dx; N(Nx+1,Nx) = -1./dx; N(Nx+1,Nx+1) = 1+1./dx;
end
u(1,1) = (f(1,1)-M(1,2)*u(2,1))./M(1,1);
u(Nx+1,1) = (f(Nx+1,1)-M(Nx+1,Nx)*u(Nx,1))./M(Nx+1,Nx+1);

%calcul de l'evolution de la temperature
for i=2:length(t)
    u(:,i) = inv(M)*(N*u(:,i-1)+f(:,i)*dt);
end

%creation et enregistrement (en commentaires) du film
if (o==1) m = 'EulerExplicite';
elseif (o==2) m = 'EulerImplicite';
elseif (o==3) m = 'CrankNicolson'; end
mov = VideoWriter(strcat('./VideoRobin',strcat(m,strcat('Cas',strcat(num2str(k),'.avi')))));
for i=1:length(t)
    plot(x,u(:,i)); axis([0 1 0 2.5]); grid on
    F = getframe(gcf);
    open(mov);
    writeVideo(mov,F);
    pause(0.005)
end

%creation de la figure regroupant les temperatures aux temps donnes
figure
t0 = [1 5 10 20 30 40 50 75 100 200 300 400 500 600 700 800 900 Nt];
for i=t0
    hold on
    plot(x,u(:,i)); grid on
    hold off
end

%creation de la figure representant la variation de la temperature par
%rapport au temps
figure; surf(t,x,u,'EdgeColor','none'); colorbar
