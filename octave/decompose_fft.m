function decompose_fft(k)

N=200 % nb echnatillon
T=100 % period
range=0:1:N-1;
y = cos(2*pi*range/T);

M = coef_fft(k,N);

subplot(3,1,1)
plot(y,'o-')

subplot(3,1,2)
plot(real(M),'o-')

subplot(3,1,3)
plot(y.*M,'o-')
sum = y*M'
title(sprintf("sym: real=%.1f, img=%.1f, module=%.1f", real(sum), imag(sum), abs(sum)))

fft(y)(k)

function M = coef_fft(k,N)
    for n = 1 :N,
        M(n) = exp(-2*i*pi*(k-1)*(n-1)/N) ;
    end
end

end
