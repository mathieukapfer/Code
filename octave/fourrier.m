N = 512 ;
M = zeros(N,N) ;

for k = 1 :N,
  for n = 1 :N,
    M(k,n) = exp(-2*i*pi*(k-1)*(n-1)/N) ;
  end ;
end ;

t = 2*pi*(0 :(N-1))/N ;
f = 32 ;
u = cos(f*t) ;

u = u';
subplot(2,1,1) ;
title("sinusoide") ;
plot(u) ;
uchap = M*u ;
subplot(2,1,2) ;
title("transformee de Fourier") ;
plot(abs(uchap)) ;
