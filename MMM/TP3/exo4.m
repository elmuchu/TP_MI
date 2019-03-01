%la partie en commentaire permet d'enregistrer la courbe

clear all
close all
clc

sigma = 10;
beta = 8/3;
rho = 28;

tspan = [0:0.05:30];

xa = [10 15 20];
[t1,x1] = ode23(@(t,y)[-beta*y(1)+y(2)*y(3); -sigma*(y(2)-y(3)); -y(2)*y(1)+rho*y(2)-y(3)],tspan,xa);

e = [2:2:10]*0.01;

for i=1:length(e)
    xb = xa + e(i);
    [t2,x2] = ode23(@(t,y)[-beta*y(1)+y(2)*y(3); -sigma*(y(2)-y(3)); -y(2)*y(1)+rho*y(2)-y(3)],tspan,xb);
    
    er = sqrt( (x1(:,1)-x2(:,1)).^2 + (x1(:,2)-x2(:,2)).^2 + (x1(:,3)-x2(:,3)).^2 );
    
    figure; plot3(x1(:,1),x1(:,2),x1(:,3),x2(:,1),x2(:,2),x2(:,3)); title(strcat('trajectoires pour e=',num2str(e(i))))
    disp('Appuyez sur une touche pour continuer'); waitforbuttonpress; clc; close all
    figure; plot(t1,er); title(strcat('erreur relative pour e=',num2str(e(i))))
    disp('Appuyez sur une touche pour continuer'); waitforbuttonpress; clc; close all
end



rho = [0.5 10 19 28 40];

for i=1:length(rho)

    if i==1
        tf = 5;
    elseif i>3
        tf = 40;
    else
        tf = 10;
    end

    tspan = [0:0.05:tf];

    [t,x] = ode23(@(t,y)[-beta*y(1)+y(2)*y(3); -sigma*(y(2)-y(3)); -y(2)*y(1)+rho(i)*y(2)-y(3)],tspan,xa);

    %mov = VideoWriter(strcat('./VideoExo4Rho',strcat(num2str(rho(i)),'.avi')));

    for ind=2:length(t)

        line([x(ind-1,1) x(ind,1)],[x(ind-1,2) x(ind,2)],[x(ind-1,3) x(ind,3)])
        %F = getframe(gcf);
        %open(mov);
        %writeVideo(mov,F);
        drawnow

    end
    
    disp('Appuyez sur une touche pour continuer'); waitforbuttonpress; clc; close all

end
