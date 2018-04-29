function [bin_centers, bin_probability, error] = hist_error( histogram_obj)
%DESIRED_RAND Summary of this function goes here
%   Detailed explanation goes here

    
    bin_centers = (1/2) *( histogram_obj.BinEdges(1:end-1) + ...
                           histogram_obj.BinEdges(2:end) );

    nof_rnd_n = length(histogram_obj.Data);
    bin_probability = histogram_obj.Values; % probability to be in bin     
    bin_width = histogram_obj.BinWidth;
    error = sqrt(bin_probability .*( 1 - bin_probability .* bin_width) / ...
                (nof_rnd_n * bin_width)); % bin height error
    
end