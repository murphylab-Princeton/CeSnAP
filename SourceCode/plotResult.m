%%-------------------------------------------------------------------------
%%---------------------- Function for plotting montage images after analyze
function [Layout, info,ResultPD] = plotResult(Layout, info, filePD, ResultPD) 
    [Layout, info] = switch_to_Analyze_layout(Layout, info, ResultPD);
    if strcmp(info.analyzeMethod,'OldMethod')
        Layout = plotResultThreshold(Layout, info,filePD, ResultPD);
    elseif strcmp(info.analyzeMethod,'SnapMachine')
        [Layout, info,ResultPD]  = plotResultMachine(Layout,info,filePD, ResultPD);
    elseif strcmp(info.analyzeMethod,'train')   
        [Layout,info, ResultPD] = plotTrainMontage(Layout, info, filePD, ResultPD);
    end
end