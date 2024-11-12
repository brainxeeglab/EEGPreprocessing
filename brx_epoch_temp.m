%% Epoch trials
clear all; clc;

% Make sure there is an EEGLAB (with neccessary plug-ins toolboxes) in the path.


% load cleaned raw dataset
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename','jge_220712_postFilt_NaN.set','filepath','/Users/joon/Documents/toolbox/ssPreprocessTool/NEWpreproc/example_data_and_codes_for_preprocessing/raw/jge_220712/preproc/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );

% epoch each condition for its duration (지금은 ssvep를 보려고 하니 0초부터 8초까지 데이타 뽑고
% 시행전체 평균값으로 베이스라인 조정)

% H00C c001
EEG = pop_epoch( EEG, {  'H00C'  }, [0  8], 'newname', 'hi_c', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [],[]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off');
EEG = eeg_checkset( EEG );

c001 = EEG.data;
RejTrl = find(isnan(squeeze(c001(72,10,:))))';
c001(:,:,RejTrl)=[];

% H0AC c002
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',1,'study',0);
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG, {  'H0AC'  }, [0  8], 'newname', 'hi_ac', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [],[]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'gui','off');

c002 = EEG.data;
RejTrl = find(isnan(squeeze(c002(72,10,:))))';
c002(:,:,RejTrl)=[];

% L00C c003
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5,'retrieve',1,'study',0);
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG, {  'L00C'  }, [0  8], 'newname', 'lo_c', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [],[]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 6,'gui','off');

c003 = EEG.data;
RejTrl = find(isnan(squeeze(c003(72,10,:))))';
c003(:,:,RejTrl)=[];

% L0AC c004
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 7,'retrieve',1,'study',0);
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG, {  'L0AC'  }, [0  8], 'newname', 'lo_ac', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [],[]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 8,'gui','off');

c004 = EEG.data;
RejTrl = find(isnan(squeeze(c004(72,10,:))))';
c004(:,:,RejTrl)=[];

% Z00C c005
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 9,'retrieve',1,'study',0);
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG, {  'Z00C'  }, [0  8], 'newname', 'z_c', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [],[]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 10,'gui','off');

c005 = EEG.data;
RejTrl = find(isnan(squeeze(c005(72,10,:))))';
c005(:,:,RejTrl)=[];

% Z0AC c006
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 11,'retrieve',1,'study',0);
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG, {  'Z0AC'  }, [0  8], 'newname', 'z_ac', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [],[]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 12,'gui','off');

c006 = EEG.data;
RejTrl = find(isnan(squeeze(c006(72,10,:))))';
c006(:,:,RejTrl)=[];

cd('/Users/joon/Documents/toolbox/ssPreprocessTool/NEWpreproc/example_data_and_codes_for_preprocessing/raw/jge_220712/preproc')

save c001.mat c001
save c002.mat c002
save c003.mat c003
save c004.mat c004
save c005.mat c005
save c006.mat c006

%% power spectra for ssvep
clear all; clc; close all;

load c001
load c002
load c003
load c004
load c005
load c006

f = (0:4000-1)*500/4000;

addpath(genpath('/Users/joon/Box Sync/Projects/RetroCue/analysis/rawdata 2021.03.23/boundedline-pkg-master'))
addpath(genpath('/Users/joon/Box Sync/Projects/RetroCue/analysis/rawdata 2021.03.23/chronux_2_12'))

% 평균 웨이브폼 acorss trials
c001_avg = mean(c001,3);
c002_avg = mean(c002,3);
c003_avg = mean(c003,3);
c004_avg = mean(c004,3);
c005_avg = mean(c005,3);
c006_avg = mean(c006,3);

c001_amp = abs(fft(c001_avg,length(c001_avg),2))/length(c001_avg);
c002_amp = abs(fft(c002_avg,length(c002_avg),2))/length(c002_avg);
c003_amp = abs(fft(c003_avg,length(c003_avg),2))/length(c003_avg);
c004_amp = abs(fft(c004_avg,length(c004_avg),2))/length(c004_avg);
c005_amp = abs(fft(c005_avg,length(c005_avg),2))/length(c005_avg);
c006_amp = abs(fft(c006_avg,length(c006_avg),2))/length(c006_avg);


% example for checking power spectrum at one channel. 채널 96
freq_range = 1:321; % index of f up to 40 hz

tiledlayout(1,3)

nexttile
plot(f(freq_range), c001_amp(97,freq_range))
hold on
plot(f(freq_range), c002_amp(97,freq_range),'r')

nexttile
plot(f(freq_range), c003_amp(97,freq_range))
hold on
plot(f(freq_range), c004_amp(97,freq_range),'r')

nexttile
plot(f(freq_range), c005_amp(97,freq_range))
hold on
plot(f(freq_range), c006_amp(97,freq_range),'r')


%% multitaper fft

NW = 3;
K = 5; % K = 2*NW - 1

params.tapers = [NW K];
params.Fs = 500;
params.fpass = [0 20];
params.pad = 0; % -1 = no padding, 0 = next power of 2, 1 = goes further
params.err = [1 0.05]; % 0 = no error bar, 1 = theoretical error bar, 2 = jackknife error bar
params.trialave = 0; % 0 = no average across subjects, 1 = average across subj

[S_post_perf_v50, f_post_perf_v50, Serr_post_perf_v50] = mtspectrumc( post_perf_v50', params );
[S_post_perf_i50, f_post_perf_i50, Serr_post_perf_i50] = mtspectrumc( post_perf_i50', params );

[S_pre_perf_v50, f_pre_perf_v50, Serr_pre_perf_v50] = mtspectrumc( pre_perf_v50', params );
[S_pre_perf_i50, f_pre_perf_i50, Serr_pre_perf_i50] = mtspectrumc( pre_perf_i50', params );

[S_post_vis_v50, f_post_vis_v50, Serr_post_vis_v50] = mtspectrumc( post_vis_v50', params );
[S_post_vis_i50, f_post_vis_i50, Serr_post_vis_i50] = mtspectrumc( post_vis_i50', params );

[S_pre_vis_v50, f_pre_vis_v50, Serr_pre_vis_v50] = mtspectrumc( pre_vis_v50', params );
[S_pre_vis_i50, f_pre_vis_i50, Serr_pre_vis_i50] = mtspectrumc( pre_vis_i50', params );

%% tcirc
