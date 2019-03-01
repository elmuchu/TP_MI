clc
close all
clear all

s = tf('s');
ksi = [0.2 0.7 1];
omega = 10;

H1 = 1/(s+1);
H2 = 1/((0.1*s+1)*(s+1));
for i=1:length(ksi)
    H3(i) = tf(1,[1/omega.^2 2*ksi(i)/omega 1]);
end

figure
impulse(H1,'r',H2,'b',H3(1),'g',H3(2),'y',H3(3),'k');
legend('H1','H2',strcat('H3 a ksi=',num2str(ksi(1))),strcat('H3 a ksi=',num2str(ksi(2))),strcat('H3 a ksi=',num2str(ksi(3))));

figure
step(H1,'r',H2,'b',H3(1),'g',H3(2),'y',H3(3),'k'); grid on
legend('H1','H2',strcat('H3 a ksi=',num2str(ksi(1))),strcat('H3 a ksi=',num2str(ksi(2))),strcat('H3 a ksi=',num2str(ksi(3))));

figure
bode(H1,'r',H2,'b',H3(1),'g',H3(2),'y',H3(3),'k');
legend('H1','H2',strcat('H3 a ksi=',num2str(ksi(1))),strcat('H3 a ksi=',num2str(ksi(2))),strcat('H3 a ksi=',num2str(ksi(3))));

figure
nyquist(H1,'r',H2,'b',H3(1),'g',H3(2),'y',H3(3),'k');
legend('H1','H2',strcat('H3 a ksi=',num2str(ksi(1))),strcat('H3 a ksi=',num2str(ksi(2))),strcat('H3 a ksi=',num2str(ksi(3))));
