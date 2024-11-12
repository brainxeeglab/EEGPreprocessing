function [EEG] = brx_openNpreprocess(rawDir, subName, RobDetr)
%
%
% New EGI data preprocessing code

subjDir = fullfile(rawDir, subName);

preprocDir = fullfile( subjDir, 'preproc' ); % preprocessed?œ ?°?´?„°?“¤ ???ž¥
if exist(preprocDir,'dir') == 0
    mkdir(preprocDir);
end

AdjICAdir = fullfile( preprocDir, 'ADJUST_RejectedICs'); % Bad IC report ???ž¥ ?´?”. ADJUST ?ˆ´ë°•ìŠ¤?”?— ê²½ë¡œ ì¶”ê??•˜?Š” ?ˆ˜? • ?•„?š”
if exist(AdjICAdir,'dir')==0
    mkdir(AdjICAdir);
end

FileName{1} = sprintf('%s_preICA.set', subName);
FileName{2} = sprintf('%s_postICA.set', subName);
FileName{3} = sprintf('%s_postADJUST.set', subName);
FileName{4} = sprintf('%s_Filt.set', subName);
FileName{5} = sprintf('%s_postFilt_NaN.set', subName);


[ALLEEG,EEG,~,~] = eeglab;

% 1. Load & merge MFF block data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
blk_file = brx_getAllFiles(subjDir, '*.mff', 1);

blk_file_order = zeros(1,length(blk_file));
for iBlk = 1 : length(blk_file)
    temp_id = regexp(blk_file{iBlk},'_\w_'); % find block number index matching expression such as _1_, _2_, _3_, ....
    blk_file_order(iBlk) = str2double(blk_file{iBlk}(temp_id + 1));
end

blk_file_inc_order = sort(blk_file);

for blkIdx = 1:length(blk_file_inc_order)
    EEG = pop_mffimport(blk_file_inc_order{blkIdx}, {'code'});
    endIdx(blkIdx) = size(EEG.data, 2);
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, blkIdx-1, 'setname', ['EGI mff file' num2str(blkIdx)], 'gui', 'off');
end

% merge all raw data sets into one and delete individual raw data sets
EEG = eeg_checkset( EEG );
EEG = pop_mergeset(ALLEEG, 1:length(blk_file), 0);
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, length(blk_file), 'gui', 'off');

ALLEEG = pop_delset( ALLEEG, 1:length(blk_file) );
EEG = eeg_checkset( EEG );

% Keep original end time points of each block
EEG.endIdx = cumsum([0 endIdx]);

% Keep original channel locations with REF
EEG.originalchanloc = EEG.chanlocs;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2. Channel edit %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EEG = pop_select( EEG, 'nochannel', {'E129', 'EMG'} ); % 129th VREF ch -> average reference & EMG
% EEG = pop_select( EEG, 'nochannel', {'E129', 'EMG'} ); % 129th VREF ch -> average reference
% EEG = pop_chanedit( EEG, 'delete', 129, 'delete', 129, 'delete', 129); % delete NAS, LPA, RPA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 3. High-pass filtering raw data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(RobDetr, 'on') % Robust detrend using Noise toolbox (aiming > 0.01hz)

    data = transpose(EEG.data);
    if ~exist('ORDER')
        ORDER = 10; % of polynomial
    end
    [data,w] = nt_demean(data);
    [filt_data,w] = nt_detrend(data, ORDER);
    EEG.data = transpose(filt_data);

elseif strcmp(RobDetr, 'off')  % pop_basicfilter using ERPlab (>0.3, 0.5, 1)

    EEG  = pop_basicfilter( EEG,  1:128 , 'Boundary', 'boundary', 'Cutoff',  0.3, 'Design', 'butter', 'Filter', 'highpass', 'Order',  2, 'RemoveDC', 'on' );
%     EEG  = pop_basicfilter( EEG,  1:128 , 'Boundary', 'boundary', 'Cutoff',  [0.3 200], 'Design', 'butter', 'Filter', 'bandpass', 'Order',  2, 'RemoveDC', 'on' );
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 4. Cleaning and removing noise using  Artifact Subspace Reconstruction (ASR) routine %%%
originalEEG = EEG;
%EEG = clean_rawdata(EEG, -1, -1, 0.7, -1, 5, 0.3);
EEG = clean_artifacts(EEG, 'Highpass', 'off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 5. Interpolating missing channel%%%%%%%%%%%%%%%%%%%%%%%%%%
EEG = pop_interp(EEG, originalEEG.chanlocs, 'spherical');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 6. Re-referencing using average reference%%%%%%%%%%%%%%%%%%
EEG.nbchan = EEG.nbchan+1;
EEG.data(end+1,:) = zeros(1, EEG.pnts);
EEG.chanlocs(1,EEG.nbchan).labels = 'initialReference';
EEG = pop_reref(EEG, []);
EEG = pop_select( EEG,'nochannel',{'initialReference'});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 7. Getting rid of line noise %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:EEG.nbchan] ,'computepower', 0,'linefreqs',[60:60:180] ,'normSpectrum',0,'p',0.01,'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels','tau',100,'verb',1,'winsize',4,'winstep',4);
signal      = struct('data', EEG.data, 'srate', EEG.srate);
lineNoiseIn = struct('lineNoiseMethod', 'clean', ...
    'lineNoiseChannels', 1:EEG.nbchan,...
    'Fs', EEG.srate, ...
    'lineFrequencies', 60,...
    'p', 0.01, ...
    'fScanBandWidth', 2, ...
    'taperBandWidth', 2, ...
    'taperWindowSize', 4, ...
    'taperWindowStep', 1, ...
    'tau', 100, ...
    'pad', 2, ...
    'fPassBand', [0 EEG.srate/2], ...
    'maximumIterations', 10);
[clnOutput, lineNoiseOut] = cleanLineNoise(signal, lineNoiseIn);
EEG.data = clnOutput.data;

poolobj = gcp('nocreate');
delete(poolobj);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EEG = pop_saveset( EEG, 'filename', FileName{1}, 'filepath', preprocDir, 'version', '7.3');
EEGori = EEG;

% 8. Fast ICA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EEG = pop_resample( EEG, 200);
% EEG = pop_runica( EEG, 'extended', 1);
EEG = pop_tesa_fastica( EEG, 'g', 'gauss', 'stabilization', 'on' );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EEG = pop_saveset( EEG, 'filename', FileName{2}, 'filepath', preprocDir, 'version', '7.3');
icaEEG = EEG;
EEG = EEGori;

EEG.icawinv     = icaEEG.icawinv;
EEG.icasphere   = icaEEG.icasphere;
EEG.icaweights  = icaEEG.icaweights;
EEG.icachansind = icaEEG.icachansind;
EEG.reject      = icaEEG.reject;
EEG.subName     = subjDir; % for naming ADJUST bad IC report text file
clear icaEEG

% 9. Automatic selection & rejection of bad ICs %%%%%%%%%%%%%%%%%%%%%%%%%%
[~,EEG,~,~] = pop_ADJUST_interface_brx ( [],EEG,[] );
EEG = pop_subcomp( EEG, find(EEG.reject.gcompreject)', 0);
EEG = pop_saveset( EEG, 'filename', FileName{3}, 'filepath', preprocDir, 'version', '7.3');
save(fullfile(subjDir, [strrep(FileName{3},'.set','') '.mat']), 'EEG', '-v7.3');

% for rejecting frequency artifacts.
% EEG = pop_zapline_plus(EEG,'noisefreqs','line','coarseFreqDetectPowerDiff',4,'chunkLength',0,'adaptiveNremove',1,'fixedNremove',1);


% 10. Extract frequency band activities %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if Filtering = 'on'
%     % EEG filtering params
%     filtFreq = [1,4; ...
%         4,8; ...
%         8,13; ...
%         15,30; ...
%         30,80];
%
%     pMV{1,1} = EEG.data; MV = cell(size(filtFreq,1)+1,1);
%
%     % fieldtrip band-pass filtering
%     for ft = 1 : size(filtFreq, 1)
%         for o = 1 : size(EEG.data, 1) % Loop over electrodes
%             MV{ft+1,1}(o,:) = ft_preproc_bandpassfilter(pMV{1,1}(o,:), EEG.srate, [filtFreq(ft,1) filtFreq(ft,2)], 4, 'but', 'twopass-average'); % necessary for filtered signals
%             %             MV{ft+(size(filtFreq,1)+1),1}(o,:) = ft_preproc_hilbert(MV{ft+1,1}(o,:), 'abs'); % angle, real, abs / necessary for phase or amplitude signals
%         end
%         fprintf('Completed band-pass filtering for freq %d, electrode %d of subject %s \n', ft, o, subjDir);
%     end
%
%     EEG.MV = MV;
%     clear pMV;
%
%     EEG_FreqBand = EEG;
%     % save
%     EEG = pop_saveset( EEG, 'filename', FileName{4}, 'filepath', preprocDir, 'version', '7.3');
%
% elseif Filtering = 'off'
%     no filtering
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% 11. Fill NaN into the erased time points for epoching %%%%%%%%%%%%%%%%%%%%%%%%

%    for i = 1 : size(EEG.MV, 1)
%        tempEEG = nan(EEG.nbchan, EEG.endIdx(end));
%        tempEEG(:, EEG.etc.clean_sample_mask) = EEG.MV{i,1};
%        EEG.MV{i,1} = tempEEG;
%    end

tempEEG = nan(size(EEG.data,1), EEG.endIdx(end));
tempEEG(:, EEG.etc.clean_sample_mask) = EEG.data;
EEG.data = tempEEG;
EEG.pnts = EEG.endIdx(end);

pop_saveset( EEG, 'filename', FileName{5}, 'filepath', preprocDir, 'version', '7.3');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
