
function myplot(f)
    x = linspace(-10,10,200);
    plot(atan((sin(x)/cos(x))))
end

function myplot2(f)
    x = linspace(-10,10,200);
    plot(sin(f*x).*(cos(x) + i*sin(x)))
end
