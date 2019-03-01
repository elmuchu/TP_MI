function I = integrale(X,F)

I = 0;

if length(X)==length(F)
    for i=1:length(X)-1
        I = I + F(i)*(X(i+1)-X(i));
    end
end
    
end