function oversample()

% original resolution
step = 1/20
nb_period = 4

% original wave
x = [-nb_period/2:step:nb_period/2-step];
%y = sin(2*pi*x)
y = rect(x,10)

% resample wave
x_size = size(y,2)
y_resample = reshape(resize(y,2,x_size),1,2*x_size);
x_resample=[1:1:2*size(y,2)];

% display both wave
x_=[1:1:size(y,2)]; % = original index

figure

subplot(3,1,1)
hold on
plot(1/2+x_resample/2,y_resample)
plot(x_,y)

subplot(3,1,2)
hold on
plot(x_resample - size(x_resample,2)/2, abs(fft(y_resample)))
plot(x_ - size(x_,2)/2, abs(fft(y)))

subplot(3,1,3)
hold on
plot(real(ifft(fft(y_resample))))


hold off


end
