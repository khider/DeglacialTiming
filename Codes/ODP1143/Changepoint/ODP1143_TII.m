% This code is modified from seonmin's LeadLag_ChangePoint_0604.m to calculate
% the probability of the MD20 record to lead the MD20_UP record across
% Termination II.

% This code computes the cdfs of two change points and the cdf difference of two change points.
% Sampling results from the HMM-match and the change points algorithm are
% required. (seonmin_ahn@brown.edu)


%% Load data
clear all; close all;

% Load the reference
load MD20_UP;
age2=age_sst(1:size(loc,1),:);
loc2=loc;

% only keep the variables of interest
clearvars -except loc2 age2

% Load the record to be compared to our reference
load ODP1143;
age1=age_sst(1:size(loc,1),:);
loc1=loc;

clearvars -except loc2 age2 age1 loc1

%% Set the target intervals [startT, startT + d_min] in unit [ka]

startT_ref = 125;
d_min_ref = 20;

startT = 125;
d_min = 50;

%% Collect age estimates of change points for record 1 and record 2
% Normalization is added because we are interested in the conditional 
% probability P(C = t | startT < C < startT + d_min).

age1_target = NaN(size(loc1));
loc1_target = NaN(size(loc1));
for i = 1 : size(age1,2)
    ind = find(age1(:,i) > startT & age1(:,i) < startT+d_min);
    age1_target(ind,i) = age1(ind,i);
    
    loc1_target(ind,i) = loc1(ind,i);
    loc1_target(:,i) = loc1_target(:,i)/nansum(loc1_target(:,i));
end
loc1_target_500 = round(500 * loc1_target);

collect_age1 = [];
[i, j] = find(isnan(age1_target) == 0);
for k = 1 : length(i)
    collect_age1 = [collect_age1; age1_target(i(k), j(k)) * ones(loc1_target_500(i(k),j(k)),1)];
end

age2_target = NaN(size(loc2));
loc2_target = NaN(size(loc2));
for i = 1 : size(age2,2)
    ind = find(age2(:,i) > startT_ref & age2(:,i) < startT_ref+d_min_ref);
    age2_target(ind,i) = age2(ind,i);
    
    loc2_target(ind,i) = loc2(ind,i);
    loc2_target(:,i) = loc2_target(:,i)/nansum(loc2_target(:,i));
end
loc2_target_500 = round(500 * loc2_target);
collect_age2 = [];
[i, j] = find(isnan(age2_target) == 0);
for k = 1 : length(i)
    collect_age2 = [collect_age2; age2_target(i(k), j(k)) * ones(loc2_target_500(i(k),j(k)),1)];
end

save ODP1143_TII;

%% Plot the cdf of C1 and C2
% figure
% [~, stats] = cdfplot(collect_age1(:));
% disp(stats)
% 
% sorted_collect_age1 = sort(collect_age1(:));
% age_mean = mean(sorted_collect_age1);
% age_median = sorted_collect_age1(round(length(sorted_collect_age1)*0.5));
% age_975 = sorted_collect_age1(round(length(sorted_collect_age1)*0.975));
% age_025 = sorted_collect_age1(round(length(sorted_collect_age1)*0.025));
% str = {['mean: ' num2str(age_mean)] ['median: ' num2str(age_median)] ['95% interval: [' num2str(age_025) ', ' num2str(age_975) ']' ]};
% xlabel('C_{1}')
% ylabel('F(C_{1})')
% annotation('textbox', [0.6,0.2,0.1,0.1], 'String', str, 'linestyle', 'none')
% hold on
% a = axis;
% statLine = a(1):a(2);
% plot(statLine, statLine*0 + 0.5, 'k-')
% plot(statLine, statLine*0 + 0.025, 'k-')
% plot(statLine, statLine*0 + 0.975, 'k-')
% 
% figure
% [~, stats] = cdfplot(collect_age2(:));
% disp(stats)

% sorted_collect_age2 = sort(collect_age2(:));
% age_mean = mean(sorted_collect_age2);
% age_median = sorted_collect_age2(round(length(sorted_collect_age2)*0.5));
% age_975 = sorted_collect_age2(round(length(sorted_collect_age2)*0.975));
% age_025 = sorted_collect_age2(round(length(sorted_collect_age2)*0.025));
% str = {['mean: ' num2str(age_mean)] ['median: ' num2str(age_median)] ['95% interval: [' num2str(age_025) ', ' num2str(age_975) ']' ]};
% xlabel('C_{2}')
% ylabel('F(C_{2})')
% annotation('textbox', [0.6,0.2,0.1,0.1], 'String', str, 'linestyle', 'none')
% hold on
% a = axis;
% statLine = a(1):a(2);
% plot(statLine, statLine*0 + 0.5, 'k-')
% plot(statLine, statLine*0 + 0.025, 'k-')
% plot(statLine, statLine*0 + 0.975, 'k-')
% 
% save MD20_TII;

%% Compute C1-C2
% Collecting all possible pairs of (C1, C2) requires large memory. Instead
% of saving all events, this code only remembers the number of elemtns in
% each bin.

% load('matlab.mat')
% clearvars -except collect_age1 collect_age2
% number of bins for the cdf
n = 500;
hist_min = min(collect_age1) - max(collect_age2);
hist_max = max(collect_age1) - min(collect_age2);
l = (hist_max - hist_min)/n;
hist_interval = hist_min + l/2 : l : hist_max - l/2;
count = zeros(1,n);
% This for loop takes long time
tic
for i = 1 : length(collect_age1)
%     i
    diff_age = collect_age1(i) - collect_age2;
    count = count + hist(diff_age, hist_interval);
end

count_p = count / sum(count);
count_cdf(1) = count_p(1);
for i = 2 : length(count)
    count_cdf(i) = count_cdf(i-1) + count_p(i);
end
toc

%% Plot the cdf of C1-C2
% figure
% stairs(hist_min:l:hist_max, [count_cdf 1])

age_mean = hist_interval*count_p';
% median
[~,tmp] = min(abs(count_cdf-0.5));  age_median = hist_interval(tmp);
% 99%
[~,tmp] = min(abs(count_cdf-0.995));  age_995 = hist_interval(tmp);
[~,tmp] = min(abs(count_cdf-0.005));  age_005 = hist_interval(tmp);
%95%
[~,tmp] = min(abs(count_cdf-0.975));  age_975 = hist_interval(tmp);
[~,tmp] = min(abs(count_cdf-0.025));  age_025 = hist_interval(tmp);
%90%
[~,tmp] = min(abs(count_cdf-0.95));  age_95 = hist_interval(tmp);
[~,tmp] = min(abs(count_cdf-0.05));  age_05 = hist_interval(tmp);
% 80%
[~,tmp] = min(abs(count_cdf-0.9));  age_9 = hist_interval(tmp);
[~,tmp] = min(abs(count_cdf-0.1));  age_1 = hist_interval(tmp);
% 66%
[~,tmp] = min(abs(count_cdf-0.83));  age_83 = hist_interval(tmp);
[~,tmp] = min(abs(count_cdf-0.17));  age_17 = hist_interval(tmp);

% str = {['mean: ' num2str(age_mean)] ['median: ' num2str(age_median)] ['95% interval: [' num2str(age_025) ', ' num2str(age_975) ']' ]};
% xlabel('C_{1} - C_{2}')
% ylabel('F(C_{1} - C_{2})')
% title('Empirical CDF')
% annotation('textbox', [0.6,0.2,0.1,0.1], 'String', str, 'linestyle', 'none')
% hold on
% grid on
% a = axis;
% statLine = a(1):a(2);
% plot(statLine, statLine*0 + 0.5, 'k-')
% plot(statLine, statLine*0 + 0.025, 'k-')
% plot(statLine, statLine*0 + 0.975, 'k-')

save ODP1143_TII
