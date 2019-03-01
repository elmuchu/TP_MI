function g = g2(x,y)

qprime = @(x)(30-12*x);

if x == y
    a = qprime(y);
else
    a = (q(x)-q(y))/(x-y);
end

if a > 0
    g = q(x);
else
    g = q(y);
end

end