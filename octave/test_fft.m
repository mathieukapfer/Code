function test_fft(f,fe)

% original resolution
step = 1/fe
nb_period = 4

% original wave
x = [0:step:nb_period-step];
y = sin(2*pi*f*x)+sin(2*pi*(f+1)*x);
%y = rect(x,10)

figure

subplot(2,1,1)
plot(x,y)

subplot(2,1,2)
plot(abs(fft(y)))

end
