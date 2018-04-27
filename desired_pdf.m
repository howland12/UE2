function [ output_args ] = desired_pdf( x, mu )
%DESIRED_PDF Summary of this function goes here
%   Detailed explanation goes here

    output_args = (1/2) * ( normpdf(x, -mu, 1) + normpdf(x, mu, 1));

end

