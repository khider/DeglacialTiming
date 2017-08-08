%% On geosys change point detection

clear all; close all;

load MD20_UP

d_min=10;

% take the first 300 years of record (same number of points in each
% iteration)
median_age_sst=quantile(age_sst',0.5);
index1=max(find(median_age_sst<=300));
%index2=max(find(median_ali<=300));

clear median_age_sst

for i=1:1000
    % get the age limit
        
    x1=age_sst(1:index1,i); y1=sst(1:index1,i);
    %x2=alignment(1:index2,i); 
    
    
    
    % Find the change points
   
    [loc(:,i) model(:,i) number(:,i)]=changepoint(x1,y1,10,d_min);
%     [loc_benthic(:,i) model_benthic(:,i)...
%         number_benthic(:,i)]=changepoint(x2,d18O(1:index2),10,d_min2);
    
    clear  x1 y1 x2 d_min1 d_min2
    
end 

clear i index1 index2

save MD20_UP;

%% This part is processed locally

% clear all; load MD20_UP;
% 
% median_age_sst=quantile(age_sst',0.5);
% index1=max(find(median_age_sst<=300));
% index2=max(find(median_ali<=300));
% 
% % bin the changepoint location data into 2kyr bins
% 
% for i=1:1000
%     [loc_bin(:,i) bin]=add_data(0.5,0,300,age_sst(1:index1,i),...
%         loc(:,i));
%     [loc_benthic_bin(:,i) bin]=add_data(0.5,0,300,alignment(1:index2,i),...
%         loc_benthic(:,i));
% end
% 
% % now sum it up across all bins to get the full time series
% 
% loc_all=nansum(loc_bin'); loc_benthic_all=nansum(loc_benthic_bin');
% 
% clear median_age_sst index1 index2
% 
% save MD20_UP;

% clear all; load MD20_UP
% 
% clear loc_bin loc_benthic_bin loc_all loc_benthic_all;
% 
% median_age_sst=quantile(age_sst',0.5);
% index1=max(find(median_age_sst<=300));
% index2=max(find(median_ali<=300));
% 
% for i=1:1000
%     x=age_sst(1:index1,i); y=loc(:,i);
%     
%     % Grab the portion of the records that correspond to the terminations
%     T1=x(find(x>=14 & x<=25)); prob_T1=y(find(x>=14 & x<=25));
%     T2=x(find(x>=125 & x<=140)); prob_T2=y(find(x>=125 & x<=140));
%     T3=x(find(x>=242 & x<=254)); prob_T3=y(find(x>=242 & x<=254));
%     
%     % Get the CDF
%     P1=prob_T1./sum(prob_T1); P1_cdf=cumsum(P1);
%     P2=prob_T2./sum(prob_T2); P2_cdf=cumsum(P2);
%     P3=prob_T3./sum(prob_T3); P3_cdf=cumsum(P3);
%     
%     % Get the lower, median and upper
%     if P1_cdf(1)<=0.025;
%         lower_95_T1(i)=T1(max(find(P1_cdf<=0.025)));
%     else
%         lower_95_T1(i)=NaN;
%     end
%     median_T1(i)=T1(max(find(P1_cdf<=0.5)));
%     upper_95_T1(i)=T1(max(find(P1_cdf<=0.975)));
%     
%     if P2_cdf(1)<=0.025;
%         lower_95_T2(i)=T2(max(find(P2_cdf<=0.025)));
%     else
%         lower_95_T2(i)=NaN;
%     end
%     median_T2(i)=T2(max(find(P2_cdf<=0.5)));
%     upper_95_T2(i)=T2(max(find(P2_cdf<=0.975)));
%     
%     if P3_cdf(1)<=0.025;
%         lower_95_T3(i)=T1(max(find(P3_cdf<=0.025)));
%     else
%         lower_95_T3(i)=NaN;
%     end
%     median_T3(i)=T3(max(find(P3_cdf<=0.5)));
%     upper_95_T3(i)=T3(max(find(P3_cdf<=0.975)));
%     
%     clear x y T1 T2 T3 prob_T1 prob_T2 prob_T3 P1 P2 P3 P1_cdf P2_cdf
%     clear P3_cdf
%     
% end
