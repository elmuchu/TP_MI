clc

K = 10;
sim('./test',10);
plot(simout.time,simout.signals.values)
