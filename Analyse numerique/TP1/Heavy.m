function y = Heavy(x)

for i=1:length(x)
    if (x(i) >= 4/3) && (x(i) <= 8/3)
        y(i) = 1;
    else
        y(i) = 0;
    end
end


end

