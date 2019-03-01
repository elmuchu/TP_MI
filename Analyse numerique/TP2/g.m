function g = g(x,y)

if x <= y
    g = min(q(x),q(y));
elseif 5/2 <= y
    g = q(y);
elseif 5/2 < x
    g = q(5/2);
else
    g = q(x);
end

end