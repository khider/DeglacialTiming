%**************************************************************%
% Probabilistic sequence alignment of stratigraphic records    %
%                                                              %
% Please acknowledge the program authors on any publication of %
% scientific results based in part on use of the program and   %
% cite the following articles in which the program was         %
% described.                                                   %
% Lin, L., D. Khider, L. E. Lisiecki and C. E. Lawrence (2014).%
% "Probabilistic sequence alignment of stratigraphic records." %
% Paleoceanography: 2014PA002713.                              %
%                                                              %
% This program is free software; you can redistribute it       %
% and/or modify it under the terms of the GNU General Public   %
% License as published by the Free Software Foundation;        %
% either version 2 of the License, or (at your option)         %
% any later version.                                           %
%                                                              %
% This program is distributed in the hope that it will be      %
% useful, but WITHOUT ANY WARRANTY; without even the implied   %
% warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      %
% PURPOSE. See the GNU General Public License for more         %
% details.                                                     %
%                                                              %
% You should have received a copy of the GNU General Public    %
% License along with this program; if not, write to the        %
% Free Software Foundation, Inc., 51 Franklin Street,          %
% Fifth Floor, Boston, MA  02110-1301, USA.                    %
%**************************************************************%

clear

%% Add path to various folders
addpath('Input_Files'); addpath('Output_Files'); addpath('HMM_Files');

%% User Inputs (EDIT THIS PORTION)

%Core ID
latepl  = 21; 

%Input Core. The text file should have two columns: column1 is
%depth and column 2 contains the benthif d18O values

ori1 = load('Input_Files/LPAZ_benthic.txt');


% Target core. The text file should have two columns: column 1 is age and
% column 2 containes the benthic d18O values

ori2 = load('Input_Files/LR04.txt'); 

%Enter the top and bottom depth (m) for the input core
begin1 = 0.025; end1 = 8.715;

% Enter the top and bottom age (kyr) for the alignment 
begin2 = 1.4; end2 = 236; 

% Return and save figures (1 for yes, 0 for no)
flag = 0; 


%% Core Algorithm (DO NOT MODIFY)


%some initial setting up
qqqq=1;

disp(sprintf('Starting Pre-Processing...')); tic

pre_processing_fine;

toc
disp(sprintf('Pre-Processing complete...'));

disp(sprintf('Running HMM Algorithm...'));

T = 0;
bb=0;
while T==0  
    tic
    bb=bb+1;
    tic
    forward_point_fine;
    toc
    
    back_sample_point_fine;
    update_parameter_point_script_fmin_fine;
        
    fprintf('log likelihood in iteration %d is %f\n',bb, log_fE);
    fprintf('The sigma returned in iteration %d is %f\n', bb, sigma);
    fprintf('The mu returned in iteration %d is %f\n', bb, mu);
    fprintf('The pi_begin returned in iteration %d is %f %f\n', bb, pi_begin(1), pi_begin(2));
    fprintf('The tao_x_begin returned in iteration %d is %f\n', bb, tao_x_begin(1));
    fprintf('The tao_x_end returned in iteration %d is %f\n', bb, tao_x_end(1));
    fprintf('The tao_y_begin returned in iteration %d is %f\n', bb, tao_y_begin(1));
    fprintf('The tao_y_end returned in iteration %d is %f\n', bb, tao_y_end(1));
    fprintf('The delta_r returned in iteration %d is %f %f\n', bb, delta_r(1), delta_r(2));

    determine_stopping;
    toc
end;
clear log_f

disp(sprintf('HMM Algorithm Complete...'));

disp(sprintf('Uncertainty Quantification...'));

uncertainty_anal_point_fine;

disp(sprintf('Saving Results...'));

output_fine;

clear VV
