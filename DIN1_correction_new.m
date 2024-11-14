function EEG=DIN1_correction_new(EEG,exp_behavior_path,parti_name)

% Created on March 1, 2023

parti_name_date=parti_name;
parti_name=extractBefore(parti_name,'_')

T=table();
temp_table=table();

% Load the Experiment META data to update the event file 
% for subjective invisible and visible case 
cd(exp_behavior_path);  

flist= dir;
nlist=length(flist);

cond=1;
pat=strcat(parti_name,'_META_REPORT');    % Seach the report paradigm for that participant

i=3;  % exclusing . and .. dirs
while(i<=nlist && cond)  
    if ~isempty(regexp(flist(i).name,pat,'once'));
        disp(' ++ Loading the META file ');
        disp(flist(i).name);
        load(flist(i).name);
        cond=0;
    else
        i=i+1;    % proceed to the next file
    end 
end

if cond
   error('++ No experimental behavior file exits'); 
end


% Extract the behavior details from the loaded META data

% Extracting the visibility report
a=   (((META.Visibility==0) | (META.Visibility==1)).*META.StairecaseTrial)';
b=a(:)>0;      % 1 -- SUb. InV
a=  (((META.Visibility==2) | (META.Visibility==3)).*META.StairecaseTrial)';
d=(a(:)>0)*2;  % 2 -- SUb. Vis
e=b+d;  % will be used for sorting trails with Sub. Vis, Sub. Inv
%e=nonzeros(e);  % necessary
 

% Visibility report
visibility_report =META.Visibility';
visibility_report=visibility_report(:);

% Tilt Decision
tilt_decision=META.TiltDecision';
tilt_decision=tilt_decision(:);

disp("++ Correcting for the DIN1 timings and adding conditions.")
time_window = 7;      % 8 event codes nearby where to look for
TAR_pat = 'TAR[1-6]';  % Target pattern
MSK_pat = 'MSK[1-3]';  % Mask pattern
DIN_pat = 'DIN1';      % DIN1 pattern
PRO_pat='PRO[LR]';     % Probe pattern

N=length(EEG.event);  % Number of rows in the event file

% loading the META  Probe data to compensate for any missing event codes
pro=META.true_probe_orientation';
pro=pro(:);

% loading the META  Probe data to compensate for any missing event codes 
msk=(META.true_mask_contrast + META.mask_contrast)';  % SUB   %  OBJ
msk=msk(:);
msk_presented=META.mask_contrasts_values;  % 4 values of the mask

% Get the target orientation (for checking if TAR event code is missing)
target_ori=META.true_target_orientation';
target_ori=target_ori(:); 
target_orientation={};
for kk=1:length(target_ori)
    target_orientation{kk}=get_orienation_info(target_ori(kk));
end

count=0;
lcount=0;
for k=1:N  % for each row
    
    h=[];
    if ~isempty(EEG.event(1,k).code)   % if the event code is not empty
        if regexp(EEG.event(1,k).code,TAR_pat,'once')   % if the event code is target 
            
            count=count+1;   % event counting for any missing codes

            while (~strcmpi(EEG.event(1,k).code,target_orientation{count}))
                 count=count+1;   % event counting for any missing TARget codes 
            end

            for j=1:time_window,  
            h(j)=~isempty(regexp(EEG.event(1,k+j).code, DIN_pat)); 
            end 
            idx=find(h);

            
            if isempty(idx) % This happens if DIN1 is not recognized or absent in the data
                h=[];
                disp('** WARNING **: Absence of DIN1 detected!!!');
                %for j=1:(time_window-1),  h(j)=~isempty(regexp(EEG.event(1,k+j-1).code,TAR_pat )); end 
                %idx=1;
                pos=0;
            else
                h=[];
                for j=1:length(idx) 
                h(j)= EEG.event(1,k+idx(j)).latency -...
                    EEG.event(1,k).latency; 
                 end  
                [~,pos]=min(h);
            end 
            
            
            % What kind of mask is sent?
            mask=[];
            for j=1:time_window-3,  mask(j)=~isempty(regexp(EEG.event(1,k+j).code, MSK_pat)); end 
            mask;
            % What kind of probe is sent? 
            probe=[];
            for j=1:time_window,  probe(j)=~isempty(regexp(EEG.event(1,k+j).code, PRO_pat)); end 
            
            % Some participants the probe_codes are missing
            % Compensating if probe_codes are missing in the data
                if length(k+find(probe))==0
                    if pro(count)==1
                        probe_code='PROL';
                    else
                        probe_code='PROR';
                    end 
                else
                    probe_code=EEG.event(1,k+find(probe)).code;
                end

            % Compensating for the mask event codes if  missing 
            % for some participants
                if length(k+find(mask))==0,
                    if msk(count)==msk_presented(1) 
                        mask_code='MSK1';
                    elseif msk(count)==msk_presented(4) 
                        mask_code='MSK2';
                    else 
                        mask_code='MSK3'; 
                    end 
                else
                    mask_code=EEG.event(1,k+find(mask)).code;
                end


 %disp(EEG.event(1,k).code);
 %EEG.event(1,k+find(mask)).code
 %disp(probe_code);
 %disp('----'); 
%disp(cond_name(EEG.event(1,k).code,...  % Target code
%                EEG.event(1,k+find(mask)).code, ... % Mask code
%                 probe_code)); 
 %disp(k);
 %disp(pos);
 % disp('----'); 

            % Change the DIN1 to condition string in event.code
            EEG.event(1,k+pos).code= "THIS";  % This where we need to epoch
            EEG.event(1,k+pos).type= "THIS";   % Maybe EEGLAB epoch uses this info not the 'code';
            
            % Update the behavior performance

            %temp_table.name=META.NAME;
            %temp_table.date=META.DATE;
            temp_table.mask=mask_code;
            temp_table.probe=probe_code;
            temp_table.target=EEG.event(1,k).code; 
            temp_table.visibility_report=visibility_report(count,1);
            temp_table.condition=cond_name(EEG.event(1,k).code,...  % Target code
                                  mask_code, ... % Mask code
                                  probe_code); % Probe code
            temp_table.tilt_presented=pro(count);
            temp_table.tilt_decision=tilt_decision(count,1);

            % Finally sort out the subjective visible and invisible
            % conditions in the table
            
            if regexp(temp_table.condition,'SS[1-6][LR]')
                lcount=lcount+1;
                if e(lcount,1)==1       % Subjectively Invisible
                    temp_table.condition=strrep(temp_table.condition,'SS','SI'); 
                elseif e(lcount,1)==2   % Subjectively Visible
                    temp_table.condition=strrep(temp_table.condition,'SS','SV');  
                else 
                    error('ERROR: No such Subjective case possible.');
                end  
            end 

            T = [T;temp_table]; 
            
        end 
    end
end

% Saving the behavior table in a seperate directory
save_path = create_dir(exp_behavior_path,'consolidated');
fname=fullfile(save_path,strcat(parti_name_date,'.csv'))
writetable(T,fname)


%
% a=[]
% for k=1:7494,
%     if strcmp(eeg.event(k).code,'THIS') 
%         a(k)=1;
%     end
% end
% 
% a=[]
% for k=1:11668,
%     if strcmp(EEG.event(k).code,'THIS') 
%         a(k)=1;
%     end
% end
% sum(a)
% 

% a=[]
% for k=1:10908,
%     if strcmp(EEG.event(k).code,'THIS') 
%         a(k)=1;
%     end
% end
% sum(a)

