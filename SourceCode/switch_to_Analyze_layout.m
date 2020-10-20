function [Layout, info] = switch_to_Analyze_layout(Layout, info, ResultPD)
%% ------------------------------------------------------------------------
    Layout = resetAllFigures(Layout);
    set(Layout.axesImageOne     , 'visible','off');
    set(Layout.axesImageTen     , 'visible','off');
    set(Layout.axesImageTwo     , 'visible','off');
    set(Layout.axesImageFive    , 'visible','off');
    set(Layout.axesImageSix     , 'visible','off');
    %%---------------------------------------------------------------------
    if strcmp(info.analyzeMethod,'SnapMachine')
        set(Layout.axesImageThree   , 'visible','off');
        set(Layout.axesImageFour    , 'visible','off');
        set(Layout.axesImageSeven   , 'visible','on'); 
        set(Layout.curlReport1      , 'visible','off');  
        set(Layout.curlReport2      , 'visible','off'); 
        set(Layout.curlReport3      , 'visible','off');
        set(Layout.previousmontage  , 'position', Layout.premontageDim_machine);
        set(Layout.nextmontage      , 'position', Layout.nextmontageDim_machine);
        set(Layout.legendAnalysis   , 'visible' ,'off');
        set(Layout.legendProcess    , 'visible' ,'off');
    
    elseif strcmp(info.analyzeMethod,'OldMethod')
        set(Layout.axesImageThree   , 'visible','on');
        set(Layout.axesImageFour    , 'visible','on');
        set(Layout.axesImageSeven   , 'visible','off'); 
        set(Layout.curlReport1      , 'visible','on');  
        set(Layout.curlReport2      , 'visible','on'); 
        set(Layout.curlReport3      , 'visible','on');
        set(Layout.previousmontage  , 'position', Layout.premontageDim_oldMethod);
        set(Layout.nextmontage      , 'position', Layout.nextmontageDim_oldMethod);
        set(Layout.legendAnalysis   , 'visible' ,'on');
        set(Layout.legendProcess    , 'visible' ,'off');
    end
    %%---------------------------------------------------------------------
    set(Layout.nextmontage      , 'visible','on');
    set(Layout.previousmontage  , 'visible','on');
    set(Layout.previousDemoShow , 'visible','off'); 
    set(Layout.nextDemoShow     , 'visible','off');
    set(Layout.Wells_CheckBox   , 'visible','off');
    set(Layout.Round_CheckBox   , 'visible','off');
    %%---------------------------------------------------------------------
    set(Layout.RadioC           ,'SelectedObject',Layout.Anlyz);
    info.modeSelction = 'Anlyz';
    %%---------------------------------------------------------------------
    if (~isempty(ResultPD)  && isfield(ResultPD, 'totalNum'))
        set(Layout.curlReport1      , 'string',['#AreaFiltered/#Total= ',num2str(ResultPD.tagAreaNum),' / ',num2str(ResultPD.totalNum)]); 
        set(Layout.curlReport2      , 'string',['#PeriFiltered/#Total= ',num2str(ResultPD.tagPeriNum),' / ',num2str(ResultPD.totalNum)]);
        set(Layout.curlReport3      , 'string',['#DimFiltered/#Total= ' ,num2str(ResultPD.tagDimNum) ,' / ',num2str(ResultPD.totalNum)]);
    end 
    %%---------------------------------------------------------------------
end