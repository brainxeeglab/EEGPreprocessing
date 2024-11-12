clear all; clc;

% Make sure there is an EEGLAB (with neccessary plug-ins toolboxes) in the path.

% Put your project path here (project folder should have raw folder)
if ismac
    projDir = '/Users/joon/Documents/toolbox/ssPreprocessTool/NEWpreproc/example_data_and_codes_for_preprocessing'; % '/Volumes/ProjectExt/Jumping';
elseif ispc
    projDir = 'E:\ProjectExt\Gaeun\FaceCom_data';
end

% ê°? ?”„ë¡œì ?Š¸?˜ ëª¨ë“  ?„œë¸Œì ?Š¸ raw ?°?´?„° ???ž¥ ?´?” ?´ë¦„ì? rawë¡? ë°˜ë“œ?‹œ ë§Œë“¤ ê²?.
rawDir = fullfile(projDir, 'raw');

% ?„œë¸Œì ?Š¸ ?´ë¦„ì? ?´ë¦? ?´?‹ˆ?…œê³? ?‚ ì§œë¡œ ?œ ?´?” ?´ë¦„ìœ¼ë¡?.
% mff ?ŒŒ?¼ ?´ë¦„ë„ eky_160727_1~6_xxxx.mff ?‹?œ¼ë¡? ?˜?–´?•¼ ?•¨.
subName = 'hsj_20221001'; % ê°? ?„œë¸Œì ?Š¸ raw ?°?´?„° ???ž¥?œ ?´?” ?´ë¦? ë°? mff ?ŒŒ?¼ ?´ë¦? ?‹œ?ž‘ ë¶?ë¶„ê³¼ ê°™ì•„?•¼ ?•¨.
% 2022ë¡? ë°”ê¾¸ê¸?.

% high-pass filtering of raw data to get rid of DC component
% if we want no fiter distortion, use Robust Detrend (NoiseTools) > 0.01 Hz
% filter using pop_basicfilter > 0.3 Hz
RobDetr = 'off'; % pop_basicfilter for highpass filtering > 0.3 Hz
% RobDetr = 'on'; % robust detrend using NoiseTools > 0.01 Hz

[EEG] = brx_openNpreprocess(rawDir, subName, RobDetr);
