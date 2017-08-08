%% On geosys change point detection

clear all; close all;

load ODP1012

d_min=50;

median_age_sst=quantile(age_sst',0.5);
index1=max(find(median_age_sst<=300));
%index2=max(find(median_ali<=300));
clear median_age_sst 

for i=1:1000
    % get the age limit
        
    x1=age_sst(1:index1,i); y1=sst(1:index1,i);
    %x2=alignment(1:index2,i);
        
    
    % Find the change points
   
    [loc(:,i) model(:,i) number(:,i)]=changepoint(x1,y1,4,d_min);
%     [loc_benthic(:,i) model_benthic(:,i)...
%         number_benthic(:,i)]=changepoint(x2,d18O(1:index2),10,d_min2);
       
    clear  x1 y1 x2 d_min1 d_min2 
    
end 

clear i index1 index2 
save ODP1012;
% %% This part is processed locally
% 
% clear all; load ODP1012;
% 
% median_age_sst=quantile(age_sst',0.5);
% index1=max(find(median_age_sst<=300));
% index2=max(find(median_ali<=300));
% 
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
% clear median_age_sst index1 index2 i
% 
% save ODP1012;