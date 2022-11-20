function y = rect(x, base=2)

  x_size=size(x,2)
  %% avoid negative value
  base = min(base, x_size)

  y = zeros(1, x_size);
  range = [round((x_size - base)/2) + 1: 1:round((x_size+base)/2)]
  for i = range
    y(1,i) = 1;
  end
end
