fprintf('Starting second problem set\n');
clearvars;
close all;

tic;
% ------------------------------------------------------------------------- 
% Global variables used for more than one task of the exercise

chi = [0 2 6];

desired_pdf_x_data = linspace(-15,15, 1e3);
desired_pdf_data = zeros([length(chi), length(desired_pdf_x_data)]);
for i = 1 : length(chi)
    desired_pdf_data(i,:) = desired_pdf(desired_pdf_x_data, chi(i));
end

data = desired_rand(5e4, 1, chi(3));

figure(1);
plot(1:length(data),data);
% figure(2);
% histogram(data,'Normalization','probability');
% hold on;
% plot(desired_pdf_x_data,desired_pdf_data(3,:),'r');
% hold off;


[N_chi_1,edges_chi_1] = histcounts(data, 'Normalization', 'pdf', 'BinLimits', [-15, 15]);
centers_chi_1 = (edges_chi_1(1:end-1) + edges_chi_1(2:end))/2;

% normalization_custom_rej = sum(N_custom_rej) * bin_width;
% p_custom_rej = N_custom_rej / normalization_custom_rej;

% error_custom_rej = sqrt(p_custom_rej .*( 1 - p_custom_rej .*bin_width) / (nof_rnd_n * bin_width)); % bin height error

figure(3)
bar(centers_chi_1, N_chi_1, 1, 'y');
hold on;
% ploterr(centers_custom_rej, p_custom_rej,[],error_custom_rej,'r.')

plot(desired_pdf_x_data,desired_pdf_data(3,:),'r');
hold off;


toc


