clear all
close all
clc

a = 2;
b = 0.01;
c = 0.01;
d = 1;

l0 = 150:10:350;
r0 = l0;

tspan = [0:0.01:25];

for i=1:length(l0)
    
y0 = [l0(i) r0(i)];

[t,y] = ode23(@(t,y)[a*y(1)-b*y(1)*y(2); -d*y(2)+c*y(1)*y(2)],tspan,y0);

figure
plot(t,y(:,1),t,y(:,2)); title(strcat('evolution des populations pour l0 = ',num2str(l0(i))))
disp('Appuyez sur une touche pour continuer'); waitforbuttonpress; clc; close all

end
