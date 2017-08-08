%% On geosys change point detection

clear all; close all;

load MD67

d_min=10;

median_age_sst=quantile(age_sst',0.5);
index1=max(find(median_age_sst<=300));
%index2=max(find(median_ali<=300));
median_age_d18Op=quantile(age_d18Op',0.5);
index3=max(find(median_age_d18Op<=300));

clear median_age_sst median_age_d18Op

for i=1:1000
    % get the age limit
        
    x1=age_sst(1:index1,i); y1=sst(1:index1,i);
    %x2=alignment(1:index2,i);
    x3=age_d18Op(1:index3,i); y3=d18Op_nMC(1:index3,i);
    
    % Find the change points
   
    [loc(:,i) model(:,i) number(:,i)]=changepoint(x1,y1,10,d_min);
%     [loc_benthic(:,i) model_benthic(:,i)...
%         number_benthic(:,i)]=changepoint(x2,d18O(1:index2),10,d_min2);
    [loc_d18Op(:,i) model_d18Op(:,i)...
        number_d18Op(:,i)]=changepoint(x3,y3,10,d_min);
    
    clear  x1 y1 x2 d_min1 d_min2 x3 y3 d_min3
    
end 

clear i index1 index2 index3
save MD67;

%% This part is processed locally
% 
% clear all; load MD67;
% 
% median_age_sst=quantile(age_sst',0.5);
% index1=max(find(median_age_sst<=300));
% index2=max(find(median_ali<=300));
% median_age_d18Op=quantile(age_d18Op',0.5);
% index3=max(find(median_age_d18Op<=300));
% 
% 
% % bin the changepoint location data into 2kyr bins
% 
% for i=1:1000
%     [loc_bin(:,i) bin]=add_data(0.5,0,300,age_sst(1:index1,i),...
%         loc(:,i));
%     [loc_benthic_bin(:,i) bin]=add_data(0.5,0,300,alignment(1:index2,i),...
%         loc_benthic(:,i));
%     [loc_d18Op_bin(:,i) bin]=add_data(0.5,0,300,age_d18Op(1:index3,i),...
%          loc_d18Op(:,i));
% end
% 
% % now sum it up across all bins to get the full time series
% 
% loc_all=nansum(loc_bin'); loc_benthic_all=nansum(loc_benthic_bin');
% loc_d18Op_all=nansum(loc_d18Op_bin');
% 
% clear median_age_sst index1 index2 median_age_d18Op index3 i
% 
% save MD67;