fprintf('Starting second problem set\n');
clearvars;
close all;

% ------------------------------------------------------------------------- 
% script control variables
% ------------------------------------------------------------------------- 
run_generator =  false;
run_correlation = true;

if run_generator == true
    
    % --------------------------------------------------------------------- 
    % Global variables used for more than one task of the exercise
    % --------------------------------------------------------------------- 
    chi = [0 2 6];
    nof_rnd_n = 1e7;
    seed_vector = [0, 0, 0];
    delta_x_vector = [6, 12, 17];
    fig_handle_vector = zeros([6 1]);


    % ---------------------------------------------------------------------
    % Generate random numbers with matropolis hastings algorithm
    % ---------------------------------------------------------------------
    fprintf('Number generation started....\n')
    desired_rand_numbers = zeros([length(chi), nof_rnd_n]);
    acceptance_rate = zeros([length(chi), 1]);
    generation_time = zeros([length(chi), 1]); % needed time
    for i = 1 : length(chi)
        tic;
        [desired_rand_numbers(i,:), acceptance_rate(i)] = ...
                                       desired_rand( ...
                                                     nof_rnd_n, ...
                                                     seed_vector(i), ...
                                                     delta_x_vector(i), ...
                                                     chi(i) ...
                                                    );
        generation_time(i) = toc;
        fprintf([num2str(i),'. set of numbers finished\n']);
    end
    fprintf('Number generation finished\n');
    mean_desired_rand_numbers = mean(desired_rand_numbers, 2);
    variance_desired_rand_numbers = var(desired_rand_numbers, 0, 2);
    % --------------------------------------------------------------------- 
    % Save random numbers to data to  files for later use
    % ---------------------------------------------------------------------
    save('rnd_numbers.mat','desired_rand_numbers');
    
    fileID = fopen('rnd_number_statistics.txt','w');
    fprintf(fileID,'%s \t %s \t %s \t %s \t %s\n','chi','acceptance_rate',...
                   'generation_time','sample_mean',...
                   'sample_variance');
    fprintf(fileID,'%f \t %f \t\t %f \t\t\t %f \t\t %f\n',[chi', ...
                   acceptance_rate, generation_time, ...
                   mean_desired_rand_numbers, ...
                   variance_desired_rand_numbers]');
    fclose(fileID);

    fprintf('Plotting of generated data started\n');
    % ---------------------------------------------------------------------
    % Generate datapoints from analytic pdf
    % ---------------------------------------------------------------------
    desired_pdf_x_data = linspace(-15,15, 1e3);
    desired_pdf_data = zeros([length(chi), length(desired_pdf_x_data)]);
    for i = 1 : length(chi)
        desired_pdf_data(i,:) = desired_pdf(desired_pdf_x_data, chi(i));
    end


    % --------------------------------------------------------------------- 
    % Transient plot of random numbers
    % ---------------------------------------------------------------------
    for i = 1 : length(chi)
        fig_handle_vector(i) = figure(i);
        plot(desired_rand_numbers(i,:), 'k');
        xlabel('timestep / 1');
        ylabel('random number / 1');
        title_string = ['random numbers versus time of distribution ', ...
                        num2str(i)];
        title(title_string);
    end


    % ---------------------------------------------------------------------
    % Plot histogram of datapoints and compare to analytic pdf
    % ---------------------------------------------------------------------
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
    
    fprintf('Plotting of generated data finished\n');
    
end

if run_correlation
    load('rnd_numbers.mat');
    len = length(desired_rand_numbers(1,:));
    x = auto_correlation(desired_rand_numbers(1,:), len/2);
    loglog(abs(x));
end


