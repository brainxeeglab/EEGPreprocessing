function epoch_conditions_new(eeg,ALLEEG,cond,epoch_duration,parti_name,baseline_int) 

try
[eeg,idx_accepted_events] = pop_epoch(eeg, {cond},epoch_duration, 'newname', cond, 'epochinfo', 'yes');
[ALLEEG, eeg, ~] = pop_newset(ALLEEG, eeg, 1,'gui','off');
eeg = eeg_checkset(eeg);
eeg = pop_rmbase( eeg, baseline_int,[]);  % baseline subtraction here  
[~,  eeg ,~] = pop_newset(ALLEEG,eeg, 2,'gui','off');
eeg = eeg_checkset( eeg );

data= eeg.data;

disp(["Data size before trial rejection ", num2str(size(data))]);
 
% Reject any trials with nan at any time point or electrode
%RejTrl = find(isnan(squeeze(data(72,10,:))))'; % this is not good
disp('++ Finding any rejected trials ...')
[row,col,depth]=ind2sub(size(data),find(isnan(data)));
RejTrl=unique(depth);  % indices where nan present
if length(RejTrl),
    disp('++ Index of rejected Trials->'); 
    disp(RejTrl);
    disp('++ No. of rejected trials->'); 
    disp(length(RejTrl)); 
    data(:,:,RejTrl)=[];  % remove the rejected trials
    
else
   disp('++ NO rejected Trials in this condition');  
end 

disp(["Data size after trial rejection  ", num2str(size(data))]); 
disp('++ Saving epoched data, accepted and rejected trials...');   
 
writematrix(idx_accepted_events,strcat(parti_name,'_accepted_trials.csv')) 
save(strcat(parti_name,'.mat'),'data','-v7.3');  % Not saving right now


%Save the rejected trial files 
if length(RejTrl)~=0
    writematrix(RejTrl,strcat(parti_name,'_rejected_trials.csv'))
else  % write a value for later identification
    writematrix([9999],strcat(parti_name,'_rejected_trials.csv'))
end
 
disp('++ Done with epoching and all files saved');   

catch
    disp('Condition not present');
end
end
