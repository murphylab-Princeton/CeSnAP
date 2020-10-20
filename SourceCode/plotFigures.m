function Layout = plotFigures(Layout, info, filePD, ResultPD) 

    if strcmp(info.analyzeMethod,'OldMethod')
        Layout = plotFiguresThreshhold(Layout, info, filePD, ResultPD);
    elseif strcmp(info.analyzeMethod,'SnapMachine')
        Layout = plotFiguresMachine(Layout, info, filePD);
    end
end