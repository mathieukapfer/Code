function decompose_fft(k)

N=20 % nb echnatillon
T=10 % period
range=0:1:N-1;
y = 1*cos(2*pi*range/T);

M = coef_fft(k,N);

subplot(5,1,1)
plot(y,'o-')

subplot(5,1,2)
plot(real(M),'o-')

subplot(5,1,3)
plot(y.*M,'o-')
sum = y*M'
title(sprintf("sym: real=%.1f, img=%.1f, module=%.1f", real(sum), imag(sum), abs(sum)))

dft=fft(y);
subplot(5,1,4)
plot(abs(dft),'o-')
hold on
plot(k, abs(dft(k)),'o')
title("dft")
hold off

subplot(5,1,5)
plot(real(ifft(resize(dft(1:10),1,20))),'o-')
hold on
plot(real(ifft(dft)),'o-')

function M = coef_fft(k,N)
    for n = 1 :N,
        M(n) = exp(-2*i*pi*(k-1)*(n-1)/N) ;
    end
end

end
