%% Report paradigm:   Preprocessing of EEG signals   
clear; clc; close all;

% Drive name
Harddrive = '/media/olive/Research'; 
Datadrive='/media/olive/Data/EEGProjects';

%% Required toolboxes for preprocessing
% tool box path
TOOLboxdir=fullfile(Harddrive,'MATLABtoolboxes'); 

% local toolbox
addpath(fullfile(Harddrive,"eeg_helper_files"))

% EEGLAB  toolboxes in the path.
EEGLAB_path=fullfile(TOOLboxdir,'eeglab2022.1');
addpath(genpath(EEGLAB_path));

% MFF files import/export
mff_path=fullfile(TOOLboxdir,'mffmatlabio');
addpath(genpath(mff_path));

% ERP toolboxe
ERP_path=fullfile(TOOLboxdir,'erplab');
addpath(genpath(ERP_path));

% Clean rawdata  toolbox
clean_rawdata_path=fullfile(TOOLboxdir,'clean_rawdata');
addpath(genpath(clean_rawdata_path));

% Fieldtrip  toolbox
Fieldtrip_path=fullfile(TOOLboxdir,'fieldtrip');
addpath(genpath(Fieldtrip_path));

% EEG-Clean toolbox
EEG_clean_path=fullfile(TOOLboxdir,'EEG-Clean-Tools/');
addpath(genpath(EEG_clean_path));

% ADJUST toolbox
% This has a custom modified code;Beware; This was simply copied from NAS
 ADJUST_path=fullfile(TOOLboxdir,'ADJUST1.1.1');
addpath(genpath(ADJUST_path));

% TESA toolbox ( Removal of  large muscle artifacts using ICA)
TESA_path=fullfile(TOOLboxdir,'TESA');
addpath(genpath(TESA_path));

% AR2 toolbox (EEG artifact reduction software)
AR2_path=fullfile(TOOLboxdir,"AR2");
addpath(genpath(AR2_path));

% FAST ICA toolbox
FastICA=fullfile(TOOLboxdir,"FastICA_25");
addpath(genpath(FastICA)); 

% NoiseTools toolbox
Noisetool=fullfile(TOOLboxdir,"NoiseTools");
addpath(genpath(Noisetool); 

 
%% Preprocessed data path (raw path where the subject raw and preprocessing
% data are stored)
proj_name='SeenUnSeen/Report'; 
projDir=fullfile(Datadrive,proj_name);
rawDir = fullfile(projDir, 'raw');   %raw1 for second day experiments   

%% Get the participant info from raw folder  
parti_list=get_folder_names(rawDir,'participants', 'stop');  % cell array of participant raw folder
Nparti=length(parti_list);
fprintf('Number of participants in the raw data folder is %d \n',Nparti);

%% Processing  
% Robust Detrending option  
RobDetr = 'off'; % pop_basicfilter for highpass filtering > 0.3 Hz 
Filtering ='on';  % non-filtered data is also saved separtely along with filtered data (30 Hz) 

% Preprocessing is done in the function brx_openNpreprocess.m

for k=1:Nparti   % For number of participants
    subName=parti_list{k};
    % Below preprocessing scripts also saves the unfiltered data
    % in addition to saving the above filtered data 
    disp(strcat('++ Beginning preprocessing for the participant',{' '},subName));
    [EEG] = brx_openNpreprocess(rawDir, subName, RobDetr,Filtering); 
    disp(strcat('++ Done preprocessing for the participant',{' '},subName));
end  
