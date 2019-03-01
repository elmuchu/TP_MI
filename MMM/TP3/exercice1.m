%la partie en commentaire sert à enregistrer les films

clear all
close all
clc

g = 9.81;
l = 5;      %longueur du fil
tspan = [0:0.1:10]; 



%variation de l'angle initial de 15° a 180° par pas de 15°

y0 = [0 1];

%mov = VideoWriter('./VideoExo1Pt1.avi');

while (y0(1)<pi)

y0 = [y0(1)+pi./12 y0(2)];

[t,y] = ode23(@(t,y)[y(2); (-g/l)*sin(y(1))],tspan,y0);

x = zeros(2,1);
z = zeros(2,1);
for ind = 2:length(t)
    tic
    x(2) = l*sin(y(ind,1));
    z(2) = -l*cos(y(ind,1));
    subplot(2,1,1,'replace');
    axis([-22 22 -11 11]);
    box on;
    grid on;
    line(x,z,'LineWidth',2);
    line(x(2),z(2),'Marker','.','MarkerSize',40);
    subplot(2,1,2);
    line([y(ind-1,1) y(ind,1)],[y(ind-1,2) y(ind,2)]);
    %F = getframe(gcf);
    %open(mov);
    %writeVideo(mov,F);
    drawnow;
    while toc<0.0025; end
end

end

close all



%variation de la vitesse initiale de 0.5 et 7.5 par pas de 0.5

y0 = [pi./12 0];

%mov = VideoWriter('./VideoExo1Pt2.avi');

while (y0(2)<7.5)

y0 = [y0(1) y0(2)+0.5];

[t,y] = ode23(@(t,y)[y(2); (-g/l)*sin(y(1))],tspan,y0);

x = zeros(2,1);
z = zeros(2,1);
for ind = 2:length(t)
    tic
    x(2) = l*sin(y(ind,1));
    z(2) = -l*cos(y(ind,1));
    subplot(2,1,1,'replace');
    axis([-22 22 -11 11]);
    box on;
    grid on;
    line(x,z,'LineWidth',2);
    line(x(2),z(2),'Marker','.','MarkerSize',40);
    subplot(2,1,2);
    line([y(ind-1,1) y(ind,1)],[y(ind-1,2) y(ind,2)]);
    %F = getframe(gcf);
    %open(mov);
    %writeVideo(mov,F);
    drawnow;
    while toc<0.0025; end
end

end