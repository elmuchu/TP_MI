function uex = uex2(x,t)

for i=1:length(x)
    if x(i) < -6*t
        uex(i) = 2;
    else
        uex(i) = 4;
end

end