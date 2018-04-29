function [ output_args ] = desired_rand( n, seed, delta_x, mu )
%DESIRED_RAND Summary of this function goes here
%   Detailed explanation goes here
    output_args = zeros([1, n]);
    output_args(1) = seed;
    n_accepted = 0;
    for i = 2:n
        r = rand();
        output_args(i) = output_args(i-1) + (r - 0.5) * delta_x;

        acceptance_probability = desired_pdf(output_args(i), mu) / desired_pdf(output_args(i-1), mu);
        if acceptance_probability < 1
            random_accept = rand();
            if random_accept > acceptance_probability
                output_args(i) = output_args(i-1); 
            else
                n_accepted = n_accepted + 1;
            end
        else
            n_accepted = n_accepted + 1;
        end
            
    end
    
    acceptance_rate = n_accepted/n;
    fprintf('Acceptance rate: %f\n',acceptance_rate);
 
end

