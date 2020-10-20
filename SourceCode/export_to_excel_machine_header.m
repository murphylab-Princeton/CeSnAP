function export_to_excel_machine_header(info, filePD)
if isfield(filePD(1).worms{1}{1}, 'WormCat')
%% ------------------------------------------------------------------------
    [file,path]     = uigetfile('*.xlsx','open template excel file');
    
    dirSplit       = strsplit(file,'.');
    mName          = strsplit(dirSplit{1},'_');
    copyfile(fullfile(path,file),[mName{1},'.xlsx']);
    
    if strcmp(dirSplit{1},'SmartData_Template')
        export_to_excel_machine_smart(info, filePD)
    elseif strcmp(dirSplit{1},'DataOutput_Template')
        export_to_excel_machine_classic(info, filePD)
    end

end
end
