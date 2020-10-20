function [Layout, info] = switch_to_Plot_layout(Layout, info)
%% --------------------------------------------------------------------
    Layout = resetAllFigures(Layout);
    set(Layout.axesImageOne     , 'visible','off');
    set(Layout.axesImageTen     , 'visible','off');
    set(Layout.axesImageTwo     , 'visible','off');
    set(Layout.axesImageThree   , 'visible','off');
    set(Layout.axesImageFour    , 'visible','off');
    set(Layout.axesImageSeven   , 'visible','off');
    set(Layout.axesImageFive    , 'visible','on');
    set(Layout.axesImageSix     , 'visible','on');

    set(Layout.curlReport1      , 'visible','off'); 
    set(Layout.curlReport2      , 'visible','off'); 
    set(Layout.curlReport3      , 'visible','off');
    set(Layout.nextmontage      , 'visible','off');
    set(Layout.previousmontage  , 'visible','off');
    set(Layout.previousDemoShow , 'visible','off'); 
    set(Layout.nextDemoShow     , 'visible','off');
    set(Layout.legendAnalysis   , 'visible','off');
    set(Layout.legendProcess    , 'visible','off');
    set(Layout.Wells_CheckBox   , 'visible','off');
    set(Layout.Round_CheckBox   , 'visible','off');
    %%--------------------------------------------------------------------
    set(Layout.RadioC           ,'SelectedObject',Layout.Plot);
    info.modeSelction = 'Plot';
    %%--------------------------------------------------------------------
end