clear all;
close all;
clc;

A  = imread('image_2.jpg');
A = double(A);
[j k p] = size(A);

M = 0;
for i=1:j
    for l=1:k
        M = M + A(i,l,1);
    end;
end;
M = M/(j*k);

for i=1:j
    for l=1:k
        if A(i,l,1)<M
            B(i,l) = 0;
        else
            B(i,l) = 1;
        end;
    end;
end;

for i=1:j
    for l=1:k
        for t=1:3
          A(i,l,t) = A(i,l,t)*B(i,l);
        end;
    end;
end;

A = uint8(A);
imshow(A);