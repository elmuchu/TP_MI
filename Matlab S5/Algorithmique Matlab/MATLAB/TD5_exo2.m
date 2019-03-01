clear all;
close all;
clc;

k = input('entrer la taille du tableau : ');
g = input('entrer le nombre d iterations : ');

for h=1:k
    if rand()>=0.5
        b(h) = 1;
    else
        b(h) = 0;
    end;
end;

for m=1:g
%x(m,1) = b(1);
%x(m,k) = b(k);
x(m,1) = suiv(b(k),b(1),b(2));
x(m,k) = suiv(b(k-1),b(k),b(1));
for i=2:k-1
    x(m,i) = suiv(b(i-1),b(i),b(i+1))
end;

b = x(m,:)
end;

imshow(x);