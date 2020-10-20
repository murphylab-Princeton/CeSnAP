function [Layout,info,filePD, ResultPD] = useCNN_to_analyzeBlobs(Layout, info, filePD, ResultPD)
if isfield(filePD, 'neuralNet')
%% ----------------------------------------------------------------
set(Layout.command_line ,'string','>> Processing...');drawnow;
mConfusionCheckMatrix =  info.confusionCheckMatrix(1:length(filePD.mLabelArray),1:length(ResultPD.CNN_labels));

%%-------------------------------------------------------------------------
ResultPD.plotThese_mInd = [];
for fL=1:length(filePD.mLabelArray)
    for sL=1:length(ResultPD.CNN_labels) 
        if mConfusionCheckMatrix(fL,sL)==true
            ResultPD.plotThese_mInd = cat(1,ResultPD.posInDatabase{fL}{sL},ResultPD.plotThese_mInd); 
        end
    end
end
ResultPD.MaxMontageSplit  = ceil(length(ResultPD.plotThese_mInd)/(filePD.MontageColNumer*filePD.MontageRowNumer));
%%-------------------------------------------------------------------------  
set(Layout.command_line ,'string','>> Done Plotting!');drawnow;
%%------------------------------------------------------------------------- 
end
end