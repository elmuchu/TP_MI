function f = f(x)

for i=1:length(x)
    if x(i) < 0
        %f(i) = 4;
        f(i) = 2;
    else
        %f(i) = 2;
        f(i) = 4;
    end
end

end