%% Epoking the preprocessed eeg data sets using event codes
% PS. please preprocess  your data before you start epoking
% set the epoch_duration and preprocessing directory path in this program
% Modify the DIN1_correction.m according to your need
clear all; clc; close all; 

% Epoch parameters
epoch_duration=[-0.2 1.2];
sp=" ";  % one single space
 
%% Make sure there is an EEGLAB (with neccessary plug-ins toolboxes) in the path.
  
% Drive name
Harddrive = '/media/olive/Research'; 
Datadrive='/media/olive/Data/EEGProjects';

% local toolbox
addpath(fullfile(Harddrive,"eeg_helper_files"))
 
% tool box path
TOOLboxdir=fullfile(Harddrive,'MATLABtoolboxes'); 

% EEGLAB (with neccessary plug-ins toolboxes) in the path.
EEGLAB_path=fullfile(TOOLboxdir,'eeglab2022.1');
addpath(genpath(EEGLAB_path));

%% Preprocessed data path (raw path where the subject raw and preprocessing
% data are stored)
proj_name='SeenUnSeen/Report'; 
ppath=fullfile(Datadrive,proj_name);
rpath = fullfile(ppath,'raw');
epoch_dir_name='epoched_new';
epoch_path=fullfile(ppath,epoch_dir_name); 
exp_behavior_path=fullfile(ppath,'BehaviorData/');

%% Get the participant info from raw folder  
parti_list=get_folder_names(rpath,'participants', 'stop');  % cell array of participant raw folder
Nparti=length(parti_list);
fprintf('Number of participants in the raw data folder is %d \n',Nparti);

% Epoch structure making
%conds = make_epoch_structure(proj_name); % This function conditions all conditions
% And folders for all conditions as well.
 

%% Epoching unepoched existing participants 
% check is epoch path exits in the project directory, if not create new, if yes proceed to next step
create_dir(ppath,epoch_dir_name) ; 
cd(epoch_path);


list_of_epoched_files=dir([epoch_path , '/*.mat']);
no_epoched=length(list_of_epoched_files);

fprintf('++ no. of participants in the epoch folder is %d \n',no_epoched); 

for i=1:Nparti  % in the raw data path 
    cd(epoch_path);
    disp(strcat("++ Dealing with " ,parti_list{i})); 

    if  exist(strcat(parti_list{i},'.mat'))==2
        disp(strcat('++ Participant',sp, parti_list{i},sp,'epoch file already exists...Skipping...'));  
    else
        disp(strcat('++ Participant',sp, parti_list{i},sp,'epoch file does not exist.')); 
        disp(strcat('++ Beginning epoching  for participant',sp, parti_list{i}));  
        cd(fullfile(rpath,parti_list{i})); 
        preproc_dir= fullfile(pwd,'preproc');
     
        if exist(preproc_dir,'dir')==7
           disp('++ Preprocessing dir exists for this particiapant');
           disp('++ Proceeding with epoking the data');   
          
           cd(preproc_dir);
    
           % load cleaned raw dataset
           [ALLEEG, ~, ~, ALLCOM] = eeglab;
           
           %file_to_load = strcat(parti_list{i},'_postICA.set');  % Loading the filtered data 
           file_to_load = strcat(parti_list{i},'_Filt.set');  % Loading the filtered data
    
           EEG = pop_loadset('filename',file_to_load,'filepath',preproc_dir); 
    
           [ALLEEG, EEG, ~] = eeg_store( ALLEEG, EEG, 0 );
           EEG = eeg_checkset( EEG ); 
    
           % GET the DIN1 corrected structure in the EEG struct 
           % Corrects for DIN1 for the presented target conditions 
           % you may need to pass exp_behavior_path and the participant name here
          
           EEG=DIN1_correction_new(EEG,...
              exp_behavior_path,... 
              parti_list{i});  
    
    
            [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG,1);
            EEG = eeg_checkset( EEG );
    
            %  Parameters
            Ts=1/EEG.srate; % sampling rate
            t=epoch_duration(1):Ts:(epoch_duration(2)-Ts);
    
            %EEGtemp=EEG;  % Store the original EEG data before epoching
            %ALLEEGtemp=ALLEEG;
    
            % Starting epoching for various conditions
            
            cd(epoch_path); 
            %EEG =EEGtemp; 
            %ALLEEG=ALLEEGtemp;
            epoch_conditions_new(EEG,ALLEEG,...   % data
                       "THIS",...             % condition for target
                    epoch_duration,...        % Epoch  duration 
                    parti_list{i});          
          
          else
               disp('++ Preprocessing dir does not exist for this participant. Please do preprocessing before epoching \n');
               disp('++ Skipping epoching the data');  
          end  
    end  
end % end for participants
    
 
%load('OV4R.mat');
%figure,  plot(t,mean(data,3)'); % all channels averaged across trials
restoredefaultpath;
rehash toolboxcache ;
savepath;
%figure,plot(mean(data,3)');
