clear all;
close all;
clc;

k = input('entrer la taille du tableau : ');
e = input('entrer le nombre d iterations : ');

for z=1:k
    for r=1:k
        if (rand()>=0.5)
            b(z,r) = 1;
        else
            b(z,r) = 0;
        end;
    end;
end;

for a=1:e

for g=1:k
    x(1,g) = b(1,g);
    x(k,g) = b(k,g);
    x(g,1) = b(g,1);
    x(g,k) = b(g,k);
end;

for i=2:k-1
    for j=2:k-1
        q = 0;
        for f=i-1:i+1
            for t=j-1:j+1
                q = q + b(f,t);
            end;
        end;
        if q==3 
            if b(i,j)==1
                x(i,j) = b(i,j);
            else
                x(i,j) = 1;
            end;
        elseif (q==2 & b(i,j)==1) | (q~=2 & q~=3)
            x(i,j) = 0;
        end;
    end;
end;

b = x;

imshow(x);

end;
