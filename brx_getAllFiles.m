function fileList = brx_getAllFiles(dirName, fileExtension, appendFullPath)
% fileList = getAllFiles(dirName, fileExtension, appendFullPath)
% appendFullpath = 1 for uploading eeg raw data (mff / raw) that requires full path
% appendFullpath = 0 for just raw eeg data file names without path

  dirData = dir([dirName '/' fileExtension]);      % Get the data for the current directory
  dirWithSubFolders = dir(dirName);
  dirIndex = [dirWithSubFolders.isdir];  %  Find the index for directories
  fileList = {dirData.name}';  %'  Get a list of the files
  if ~isempty(fileList)
    if appendFullPath
      fileList = cellfun(@(x) fullfile(dirName,x),...  %  Prepend path to files
                       fileList,'UniformOutput',false);
    end
  end
  subDirs = {dirWithSubFolders(dirIndex).name};  %  Get a list of the subdirectories
  validIndex = ~ismember(subDirs,{'.','..'});  %  Find index of subdirectories
                                               %    that are not '.' or '..'
  for iDir = find(validIndex)                  %  Loop over valid subdirectories
    nextDir = fullfile(dirName,subDirs{iDir});    %  Get the subdirectory path
    fileList = [fileList; brx_getAllFiles(nextDir, fileExtension, appendFullPath)];  %  Recursively call getAllFiles
  end

end