clc
clear all
close all

K = [1 10 25 50];

for i=1:length(K)
    F = [0.025 0.55 1+0.01*K(i) K(i)];
    r(:,i) = roots(F);
end

for i=1:length(K)
    H(i) = tf([0.01*K(i) K(i)],[0.025 0.55 1 0]); 
end

bode(H(1),H(2),H(3),H(4)); grid on; legend('1','10','25','50')

H1 = H(1); H2 = H(2); H3 = H(3); H4 = H(4);