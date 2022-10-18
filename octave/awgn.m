function y = awgn(x, N0)
    y=1/sqrt(pi*N0)*exp(-x.^2/N0)
end
