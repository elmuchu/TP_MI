function f = f(x)

hl = 2;
hr = 1;

for i=1:length(x)
    if x(i)<0
        f(i) = hl;
    else
        f(i) = hr;
    end
end

end