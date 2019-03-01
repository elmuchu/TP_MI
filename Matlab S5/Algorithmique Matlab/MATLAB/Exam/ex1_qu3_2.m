function approx = ex1_qu3_2 (S)

[a,n] = ex1_qu3_1(S);

if a<10
    approx = 2*10.^n;
elseif a>=10
    approx = 6*10.^n;
end

end