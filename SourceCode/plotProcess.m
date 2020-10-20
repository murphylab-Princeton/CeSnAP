%%-------------------------------------------------------------------------
%%--------------------------------------- Outlining the processed snapshots
function Layout = plotProcess(Layout, info, filePD, ResultPD)
    [Layout, info] = switch_to_Process_layout(Layout, info);
    if strcmp(info.analyzeMethod,'SnapMachine')
        Layout = plotProcessMachine(Layout, info, filePD);
    elseif strcmp(info.analyzeMethod,'OldMethod')
        Layout = plotProcessedThreshold(Layout, info, filePD,ResultPD);
    end
end