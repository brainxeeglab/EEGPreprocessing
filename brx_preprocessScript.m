clear all; clc;

% Make sure there is an EEGLAB (with neccessary plug-ins toolboxes) in the path.

% Put your project path here (project folder should have raw folder)
if ismac
    projDir = '/Users/joon/Documents/toolbox/ssPreprocessTool/NEWpreproc/example_data_and_codes_for_preprocessing'; % '/Volumes/ProjectExt/Jumping';
elseif ispc
    projDir = 'E:\ProjectExt\Gaeun\FaceCom_data';
end

% �? ?��로젝?��?�� 모든 ?��브젝?�� raw ?��?��?�� ???�� ?��?�� ?��름�? raw�? 반드?�� 만들 �?.
rawDir = fullfile(projDir, 'raw');

% ?��브젝?�� ?��름�? ?���? ?��?��?���? ?��짜로 ?�� ?��?�� ?��름으�?.
% mff ?��?�� ?��름도 eky_160727_1~6_xxxx.mff ?��?���? ?��?��?�� ?��.
subName = 'hsj_20221001'; % �? ?��브젝?�� raw ?��?��?�� ???��?�� ?��?�� ?���? �? mff ?��?�� ?���? ?��?�� �?분과 같아?�� ?��.
% 2022�? 바꾸�?.

% high-pass filtering of raw data to get rid of DC component
% if we want no fiter distortion, use Robust Detrend (NoiseTools) > 0.01 Hz
% filter using pop_basicfilter > 0.3 Hz
RobDetr = 'off'; % pop_basicfilter for highpass filtering > 0.3 Hz
% RobDetr = 'on'; % robust detrend using NoiseTools > 0.01 Hz

[EEG] = brx_openNpreprocess(rawDir, subName, RobDetr);
