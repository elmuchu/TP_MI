X = 3;
xmax = -0.3;
xmin = -0.4;

stop = 0;
[t1,t2] = size(anser);
for i=1:t1
    if anser(i,X) < xmax && anser(i,X) > xmin
        stop = stop + 1;
    end
end
stop

T = 1;
N_long = 500;
for g=1:N_long
    x(g,:) = p((g-1)*L/(N_long-1),anser(T,:));
end
plot(x(:,1),x(:,2)); grid on;