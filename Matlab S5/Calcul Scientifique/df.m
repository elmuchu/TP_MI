function df = df(f,dx,sch)



if sch==1 %aval 1
    df(length(f)) = (f(1)-f(length(f)))./dx;
    for i=1:length(f)-1
        df(i) = (f(i+1)-f(i))./dx;
    end
elseif sch==2 %amont 1
    df(1) = (f(1)-f(length(f)))./dx;
    for i=2:length(f)
        df(i) = (f(i)-f(i-1))./dx;
    end
elseif sch==3 %aval 2
    df(length(f)-1) = (-f(1)+4*f(length(f))-3*f(length(f)-1))./(2*dx);
    df(length(f)) = (-f(2)+4*f(1)-3*f(length(f)))./(2*dx);
    for i=1:length(f)-2
        df(i) = (-f(i+2)+4*f(i+1)-3*f(i))./(2*dx);
    end
elseif sch==4 %centré 2
    df(1) = (f(2)-f(length(f)))./(2*dx);
    df(length(f)) = (f(1)-f(length(f)-1))./(2*dx);
    for i=2:length(f)-1
        df(i) = (f(i+1)-f(i-1))./(2*dx);
    end
elseif sch==5 %centre 4
    df(length(f)-1) = (-f(1)+8*f(length(f))-8*f(length(f)-2)+f(length(f)-3))./(12*dx);
    df(length(f)) = (-f(2)+8*f(1)-8*f(length(f)-1)+f(length(f)-2))./(12*dx);
    df(1) = (-f(3)+8*f(2)-8*f(length(f))+f(length(f)-1))./(12*dx);
    df(2) = (-f(4)+8*f(3)-8*f(1)+f(length(f)))./(12*dx);
    for i=3:length(f)-2
        df(i) = (-f(i+2)+8*f(i+1)-8*f(i-1)+f(i-2))./(12*dx);
    end
end

end