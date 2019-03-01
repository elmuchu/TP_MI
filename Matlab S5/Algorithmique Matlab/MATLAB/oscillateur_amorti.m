function yp = oscillateur_amorti(t,y)

m=1;
k=10;
eta=1;

yp(1,1) = y(2); 
yp(2,1) = -k/m*y(1)-eta/m*y(2);