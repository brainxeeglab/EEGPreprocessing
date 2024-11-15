function folder_names = get_folder_names(rpath,txt,alert) 
    sp=" ";
    cd(rpath);  % It stayed in this directory till the end of program
    Folders=dir; 

    folder_names=cell(length(Folders)-2,1);
    if length(Folders)==2
        msg = strcat('++ NO',sp, txt,sp,'exists in',sp,rpath,sp);
        if strcmpi(alert,'stop')
            error(msg);
        else 
            disp(msg)
        end
    else  % Get the list of particiapants
        for p=3:length(Folders)
        folder_names{p-2,1}=Folders(p).name;
        end
    end
end 