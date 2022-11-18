function oversample()

% original resolution
res = 1/20
nb_period = 4

% original wave
x = [-nb_period/2:res:nb_period/2-res];
y = the_function(x);
%y = rect(x);

% resample wave
y_resample = reshape(resize(y,2,size(y,2)),1,2*size(y,2));
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

function y = the_function(x)
    y = sin(2*pi*x);
end

function y = rect(x)
    base = 5
    x_size=size(x,2)
    y = zeros(x_size, 1);
    for i = [round(x_size/2) - base: round(x_size/2) + base]
        y(i) = 1;
    end
end


end
