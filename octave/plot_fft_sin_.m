
% define range
resolution=1/1000
x = [-1:resolution:+1-resolution];

% define signal
duration=5/10  % pourcent of signal duration
f0 = 100       % freq of the first sub carrier
n = 10         % nb sub carrier
scs = 2       % sub carrier spacing

% compute
subplot(2,1,1);
title("signal")
y = sin_(x, duration, f0, n, scs);
plot(y);
subplot(2,1,2);
plot(abs(fft(y)));
