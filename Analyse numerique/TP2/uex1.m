function uex = uex1(x,t)

for i=1:length(x)
    if x(i)/t < -18
        uex(i) = 4;
    elseif x(i)/t > 6
        uex(i) = 2;
    else
        uex(i) = (30-x(i)/t)/12;
    end
end

end