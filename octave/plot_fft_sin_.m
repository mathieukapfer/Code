% plot signal and fft

%    %define range
%    resolution=1/1000
%
%    % define signal
%    duration=1/10  % pourcent of signal duration
%    f0 = 100       % freq of the first sub carrier
%    n = 10         % nb sub carrier
%    scs = 1        % sub carrier spacing

function plot_fft_sin_(resolution=1/1000,
                       duration=1/10,
                       f0=100,
                       n=10,
                       scs=1)

    % display arg
    resolution
    duration
    f0
    n
    scs

    % compute range
    range = [-1:resolution:+1-resolution];

    % plot signal
    subplot(2,1,1);
    y = sin_(range, duration, f0, n, scs);
    plot(y);
    title("signal")

    % plot fft
    subplot(2,1,2);
    plot(abs(fft(y)));
    title("fft")
end
