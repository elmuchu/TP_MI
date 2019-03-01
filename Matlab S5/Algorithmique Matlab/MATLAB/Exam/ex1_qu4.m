function racineS = ex1_qu4 (S,epsilon)

x = ex1_qu3_2(S);

while abs(x.^2 - S) > epsilon
    x = 0.5*(x+S./x);
end

racineS = x;

end