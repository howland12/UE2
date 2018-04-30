fprintf('Starting second problem set\n');
clearvars;
close all;

% ------------------------------------------------------------------------- 
% script control variables
% ------------------------------------------------------------------------- 
run_generator =  true;
run_correlation = true;
load_data = false;

if run_generator == true
    
    % --------------------------------------------------------------------- 
    % Global variables used for more than one task of the exercise
    % --------------------------------------------------------------------- 
    chi = [0 2 6];
    nof_rnd_n = 1e6;
    seed_vector = [0, 0, 0];
    delta_x_vector = [6, 12, 17];
    fig_handle_vector = zeros([9 1]);


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
    
    
    % ---------------------------------------------------------------------
    % measure time needed to calculate auto correlation
    % ---------------------------------------------------------------------
    if ~load_data
        length_saved_data = length(desired_rand_numbers(1,:));
        n_autocorrelation = round(logspace(1,log10(length_saved_data),1000)); %vector containing the number of rnd numbers to test auto correlation speed
        nof_n = length(n_autocorrelation);

        calculation_time = zeros([nof_n, 1]); % needed time
        for i = 1 : nof_n
            tic;
            data = desired_rand_numbers(1,1:n_autocorrelation(i));
            auto_correlation(data, n_autocorrelation-1);
            calculation_time(i) = toc;
            if mod(i,100) == 0
                fprintf('%i\n',i);
            end
        end
        save('autocorrelation.mat','n_autocorrelation','calculation_time');  
    else
        load('autocorrelation1e7_17.mat');
    end
    [xData, yData] = prepareCurveData( n_autocorrelation, calculation_time );

    % Set up fittype and options.
    ft = fittype( 'c * x * log(x)', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = 0.455986767390341;

    % Fit model to data.
    [log_fitresult, gof] = fit( xData, yData, ft, opts );
    
    
    % Set up fittype and options.
    ft = fittype( 'c * x^2', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = 0.455986767390341;

    % Fit model to data.
    [squared_fitresult, gof] = fit( xData, yData, ft, opts );

    % Set up fittype and options.
    ft = fittype( 'c*x*(x-1)', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = 0.529408632504559;

    % Fit model to data.
    [n_times_tmax_fitresult, gof] = fit( xData, yData, ft, opts );
    
      
    % Plot fit with data.
    figure(7);
    h = plot( squared_fitresult, xData, yData );
    hold on;
    plot( log_fitresult,'c', xData, yData );
    plot( n_times_tmax_fitresult,'k', xData, yData );
    hold off;
    set(gca, 'YScale', 'log')
    set(gca, 'XScale', 'log')
    
    legend('data','c * x^2','','c * x * log(x)','','c*x*(x-1)');
    xlabel('number of rnd numbers used / 1');
    ylabel('time needed to calculate autocorrelation / 1');
    title('time vs rnd numbers used in autocorrelation');
    
    % ---------------------------------------------------------------------
    % fit for autocorrelation coefficient.
    % ---------------------------------------------------------------------
    nof_distributions = size(desired_rand_numbers);
    for i = 1 : nof_distributions(1)
        data = desired_rand_numbers(i,:);
        auto_correlation_values(i,:) = abs(auto_correlation(data, length(data)-1));
    end
    
    for i = 1 : nof_distributions(1)
        if i ~= 3
            x = 0:9;
            x = x';
            y = auto_correlation_values(i,1:10)';
        else
            x = 0:99;
            x = x';
            y = auto_correlation_values(i,1:100)';
        end
        f = fit(x,y,'exp1');
        coeff = coeffvalues(f);
        x_plot = logspace(-3,7,1000);
        y_plot = coeff(1) .* exp(coeff(2) .* x_plot);
        
        figure();
        plot(0:length(auto_correlation_values(i,:))-1,auto_correlation_values(i,:));
        hold on;
        plot(x_plot,y_plot);
        hold off;
        set(gca, 'YScale', 'log')
%         set(gca, 'XScale', 'log')
        legend('data','a * exp(b*x)');
         if i ~= 3
            xlim([0,8e1]);
         else
            xlim([0,2e3]);
         end
%         ylim([1e-7,1])
        xlabel('t / 1')
        ylabel('autocorrelation value / 1')
        title_string = ['autocorrelation distribution ', ...
                        num2str(i)];
        title(title_string); 
        
        fprintf('asymptotic autocorrelation time of distribution %i is %f s\n', i, -1/coeff(2));
    end   
end


