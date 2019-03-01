function reduc(L)

A  = imread(L);
A = double(A);
[j k] = size(A);

p = j/10;
m = k/10;

for i=1:p
    for h=1:m
        M = 0;
            for g=10*(i-1)+1:10*(i-1)+10
                for f=10*(h-1)+1:10*(h-1)+10
                    M = M + A(g,f);
                end;
            end;
        B(i,h) = M/100;
    end;
end;

imshow(uint8(B));

end