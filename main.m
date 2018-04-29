fprintf('Starting second problem set\n');
clearvars;
close all;

tic;
% ------------------------------------------------------------------------- 
% Global variables used for more than one task of the exercise
% ------------------------------------------------------------------------- 
chi = [0 2 6];
nof_rnd_n = 1e5;
seed_vector = [0, 0, 0];
delta_x_vector = [6, 12, 17];
fig_handle_vector = zeros([6 1]);


% ------------------------------------------------------------------------- 
% Generate random numbers with matropolis hastings
% -------------------------------------------------------------------------
desired_rand_numbers = zeros([length(chi), nof_rnd_n]);
for i = 1 : length(chi)
    desired_rand_numbers(i,:) = desired_rand(nof_rnd_n, seed_vector(i),...
                                             delta_x_vector(i), chi(i));
end


% ------------------------------------------------------------------------- 
% Generate datapoints from analytic pdf
% -------------------------------------------------------------------------
desired_pdf_x_data = linspace(-15,15, 1e3);
desired_pdf_data = zeros([length(chi), length(desired_pdf_x_data)]);
for i = 1 : length(chi)
    desired_pdf_data(i,:) = desired_pdf(desired_pdf_x_data, chi(i));
end


% ------------------------------------------------------------------------- 
% Transient plot of random numbers
% -------------------------------------------------------------------------
for i = 1 : length(chi)
    fig_handle_vector(i) = figure(i);
    plot(desired_rand_numbers(i,:), 'k');
    xlabel('timestep / 1');
    ylabel('random number / 1');
    title_string = ['random numbers versus time of distribution ', ...
                    num2str(i)];
    title(title_string);
end


% ------------------------------------------------------------------------- 
% Plot histogram of datapoints and compare to analytic pdf
% -------------------------------------------------------------------------
for i = 1 : length(chi)
    fig_handle_vector( i + length(chi) ) = figure( i + length(chi) );
    h = histogram(desired_rand_numbers(i,:), 'Normalization', 'pdf');
    hold on;
    [bin_centers, bin_probability, bin_error] = hist_error(h);
    ploterr(bin_centers, bin_probability, [],bin_error, 'r.')
    plot(desired_pdf_x_data,desired_pdf_data(i,:),'k');
    hold off;
    xlabel('random number / 1');
    ylabel('probability / 1');
    title_string = ['histogram of rnd numbers and distribution ', ...
                    num2str(i)];
    title(title_string);
end


toc


