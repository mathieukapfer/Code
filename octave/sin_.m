
function y=sin_(range, f0, n, scs)
    indice=1;
    for x=range
        y(indice) = sin_val(x, f0, n, scs);
        indice = indice+1;
    end
end

function y=sin_val(x, f0, n, scs)
    y=0;
    if (x < 0.1 && x >- 0.1)
        for i=[1:n]
            y = y+sin((f0+i*scs)*2*pi*x);
        end
    end
end
