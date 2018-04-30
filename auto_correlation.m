function [ rho ] = auto_correlation( rnd_numbers , tmax)
%AUTO_CORREL Summary of this function goes here
%   Detailed explanation goes here
    x = rnd_numbers;
    N = length(x);
    t = 0:tmax;
    Nmt = N - t;
    x_cum = cumsum(x);
    x_mean = flip(x_cum(N-tmax:end)) ./ Nmt; % flip cause cumsum(t) = sum from i = 1 to t not N-t % N-tmax to show different tmax
    y_mean = (x_cum(end) - [0,x_cum(1:tmax)]) ./ Nmt;
    
    x_times_y = fft(x,2*N);
    x_times_y = ifft( x_times_y .* conj(x_times_y) );
    
    rho = x_times_y(1:tmax+1) - x_mean .* y_mean .* Nmt;
    
    cum_x_squared = cumsum(x .* x); % needs to be flipped done below
    cum_y_squared = cum_x_squared(end) -  [0,cum_x_squared(1:tmax)];
    
    
    denominator = flip(cum_x_squared(N-tmax:end)) .* cum_y_squared;
    denominator = denominator - y_mean.^2 .* Nmt .* flip(cum_x_squared(N-tmax:end));
    denominator = denominator + x_mean.^2 .* y_mean.^2 .* Nmt.^2;
    denominator = denominator - x_mean.^2 .* Nmt .* cum_y_squared;
    
    rho = rho ./ sqrt(denominator);
    
end

