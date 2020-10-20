function [Layout,info, filePD, ResultPD] = uploadImageDatabase(Layout, info, filePD, ResultPD)
%% ---------------------------------------------------------------------
    vid_directory  = uigetdir;
    filePD.my_imds = imageDatastore(vid_directory,'FileExtensions',{'.png'}, 'IncludeSubfolders',true, 'LabelSource','foldernames');
    %filePD.my_imds =  shuffle(splitEachLabel(filePD.my_imds,500,'randomize'));
    dirSplit       = strsplit(vid_directory,'\');
    info.filename  = dirSplit{end};
    set(Layout.command_line ,'string','>> Training Session');drawnow;
    set(Layout.TargetFileN, 'string',info.filename);       

    legendLabel{1}='';legendLabel{2}='';legendLabel{3}='';legendLabel{4}='';
    legendLabel{5}='';legendLabel{6}='';legendLabel{7}='';legendLabel{8}='';
    tmpLabel = cellstr(unique(filePD.my_imds.Labels));
    for jj=1:length(tmpLabel),legendLabel{jj} = tmpLabel{jj};end
    filePD.mLabelArray = categorical(tmpLabel);
    
    set(Layout.botLef1, 'string', legendLabel{1});set(Layout.botLef2, 'string', legendLabel{2});set(Layout.botLef3, 'string', legendLabel{3});
    set(Layout.botLef4, 'string', legendLabel{4});set(Layout.botLef5, 'string', legendLabel{5});set(Layout.botLef6, 'string', legendLabel{6});
    set(Layout.botLef7, 'string', legendLabel{7});set(Layout.botLef8, 'string', legendLabel{8});
        
    filePD.MontageRowNumer    = 7;
    filePD.MontageColNumer    = 10;
    ResultPD.plotThese_mInd   = 1:length(filePD.my_imds.Files);
    ResultPD.MaxMontageSplit  = ceil(length(ResultPD.plotThese_mInd)/(filePD.MontageColNumer*filePD.MontageRowNumer));
end