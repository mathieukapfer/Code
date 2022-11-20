N = 256 ;
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
subplot(3,1,1) ;
plot(u) ;
title("sinusoide") ;

% compute fft
uchap = M*u ;

subplot(3,1,2) ;
plot(abs(uchap)) ;
title("fft (matrice)") ;

% use octave fft func
subplot(3,1,3) ;
plot(abs(fft(u))) ;
title("ftt (octave)") ;
