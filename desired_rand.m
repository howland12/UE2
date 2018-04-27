function [ output_args ] = desired_rand( n, seed, mu )
%DESIRED_RAND Summary of this function goes here
%   Detailed explanation goes here
    delta_x = 12;
    output_args = zeros([1, n]);
    output_args(1) = seed;
    nof_tries = zeros([1, n]);
    for i = 2:n
        number_accepted = false;
        while number_accepted ~= true
            nof_tries(i) = nof_tries(i) + 1; 
            r = rand();
            output_args(i) = output_args(i-1) + (r - 0.5) * delta_x;
            
            acceptance_rate = desired_pdf(output_args(i), mu) / desired_pdf(output_args(i-1), mu);
            if acceptance_rate >= 1
%                 acceptance_rate = 1;
                number_accepted = true;
            else
            
                random_accept = rand();
                if random_accept <= acceptance_rate
                    number_accepted = true;
                end
            end
            
        end
    end
    
    nof_tries_mean = mean(nof_tries);
    acceptance_rate = 1 / nof_tries_mean;
    fprintf('Acceptance rate: %f\n',acceptance_rate);
 
end

