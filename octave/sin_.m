
function y=sin_(range, duration, f0, n, scs)
    indice=1;
    for x=range
        y(indice) = sin_val(x, duration, f0, n, scs);
        indice = indice+1;
    end
end

function y=sin_val(x, duration, f0, n, scs)
    y=0;
    if (x < duration && x >- duration)
        for i=[1:n]
            y = y+sin((f0+i*scs)*2*pi*x);
        end
    end
end
