function [ rnd_number_vector, acceptance_rate ] = desired_rand( n, seed, delta_x, mu )
%DESIRED_RAND Summary of this function goes here
%   Detailed explanation goes here
    rnd_number_vector = zeros([1, n]);
    rnd_number_vector(1) = seed;
    n_accepted = 0;
    
    for i = 2:n
        r = rand();
        rnd_number_vector(i) = rnd_number_vector(i-1) + (r - 0.5) * delta_x;
        acceptance_probability = desired_pdf(rnd_number_vector(i), mu) / desired_pdf(rnd_number_vector(i-1), mu);
        if acceptance_probability < 1
            random_accept = rand();
            if random_accept > acceptance_probability
                rnd_number_vector(i) = rnd_number_vector(i-1); 
            else
                n_accepted = n_accepted + 1;
            end
        else
            n_accepted = n_accepted + 1;
        end
            
    end
    
    acceptance_rate = n_accepted/n;
 
end

