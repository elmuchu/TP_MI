clear all;clc;

k = 1; m = 1;
tspan = [0 2*pi];
F = @(t, y)[y(2); -k/m*y(1)];
[t, y] = ode23tx(F, tspan, [1;0]);


x = linspace(0,2*pi);

figure
subplot(3,1,1)       % add first plot in 2 x 1 grid
plot(y(:, 1), y(:, 2),' -o');
title('unum')

subplot(3,1,2)       % add second plot in 2 x 1 grid
plot(x,cos(sqrt(k/m)*x));
title('uexact')

subplot(3,1,3) 
plot(t,y(:,1),t,y(:,2));
title('test')