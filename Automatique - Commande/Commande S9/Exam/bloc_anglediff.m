function y = anglediff(u,v)
if u<-pi
    u = mod(u,-pi);
end
if u>pi
    u = mod(u,pi);
end
if v<-pi
    v = mod(v,-pi);
end
if v>pi
    v = mod(v,pi);
end
y = u-v;
if y<-pi
    y = mod(y,-pi);
end
if y>pi
    y = mod(y,pi);
end
end