function [a,n] = ex1_qu3_1 (S)

S0 = S;

while S0/100 > 100
    S0 = S0/100;
end

a = mod(S0,100);

n = log10(S./sqrt(a));

end