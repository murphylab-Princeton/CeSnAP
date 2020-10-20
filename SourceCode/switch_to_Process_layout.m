function [Layout, info] = switch_to_Process_layout(Layout, info)
%% ------------------------------------------------------------------------
    Layout = resetAllFigures(Layout);
    set(Layout.axesImageOne     , 'visible','on');
    set(Layout.axesImageTwo     , 'visible','on');
    set(Layout.axesImageThree   , 'visible','off');
    set(Layout.axesImageFour    , 'visible','off');
    set(Layout.axesImageSeven   , 'visible','off');
    %%---------------------------------------------------------------------
    if strcmp(info.analyzeMethod,'SnapMachine')
        set(Layout.axesImageTen     , 'visible','off');
        set(Layout.legendAnalysis   , 'visible','off');
        set(Layout.legendProcess    , 'visible','off');
    
    elseif strcmp(info.analyzeMethod,'OldMethod')
        set(Layout.axesImageTen     , 'visible','on');
        set(Layout.legendAnalysis   , 'visible','off');
        set(Layout.legendProcess    , 'visible','on');
    end
    %%---------------------------------------------------------------------
    set(Layout.curlReport1      , 'visible','off'); 
    set(Layout.curlReport2      , 'visible','off'); 
    set(Layout.curlReport3      , 'visible','off'); 
    set(Layout.nextmontage      , 'visible','off');
    set(Layout.previousmontage  , 'visible','off');
    set(Layout.previousDemoShow , 'visible','on'); 
    set(Layout.nextDemoShow     , 'visible','on');
    set(Layout.axesImageFive    , 'visible','off');
    set(Layout.axesImageSix     , 'visible','off');
    set(Layout.Wells_CheckBox    , 'visible','on');
    set(Layout.Round_CheckBox    , 'visible','on');
%%-------------------------------------------------------------------------
    set(Layout.RadioC           ,'SelectedObject',Layout.Prcss);
    info.modeSelction ='Prcss';
%%-------------------------------------------------------------------------
end