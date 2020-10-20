function [Layout,filePD] = openCNN_file(Layout, filePD)
if isfield(filePD, 'my_imds')
%% ------------------------------------------------------------------------ 
    [mDir,~]     = uigetfile('*.mat','open *.mat file');
    set(Layout.command_line ,'string','>> Loading Network');drawnow;
    CNN =load(mDir);
    dirSplit = strsplit(mDir,'\');
    set(Layout.loadNet         , 'string', ['Network: ',dirSplit{end}]);
    set(Layout.command_line ,'string','>> Training Session');drawnow;
    filePD.neuralNet = CNN.salmanNet;
end
end
