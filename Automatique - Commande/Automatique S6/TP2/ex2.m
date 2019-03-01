clc
clear all
close all

KpK = [10 50 100 200 500];

figure; hold on
for i=1:length(KpK)
    H(i) = tf([0.005*KpK(i) KpK(i)],[0.001 0.11 1 0]);
    bode(H(i)); grid on
end
hold off;step(H(1),H(2),H(3),H(4),H(5));legend('K=10','K=50','K=100','K=200','K=500'); grid on