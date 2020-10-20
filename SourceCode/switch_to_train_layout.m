function [Layout, info] = switch_to_train_layout(Layout, info, ResultPD)
%% ------------------------------------------------------------------------
    Layout = resetAllFigures(Layout);
    set(Layout.axesImageOne     , 'visible','off');
    set(Layout.axesImageTen     , 'visible','off');
    set(Layout.axesImageTwo     , 'visible','off');
    set(Layout.axesImageFive    , 'visible','off');
    set(Layout.axesImageSix     , 'visible','off');
    %%---------------------------------------------------------------------
    set(Layout.axesImageThree   , 'visible','off');
    set(Layout.axesImageFour    , 'visible','off');
    set(Layout.axesImageSeven   , 'visible','on'); 
    set(Layout.curlReport1      , 'visible','off');  
    set(Layout.curlReport2      , 'visible','off'); 
    set(Layout.curlReport3      , 'visible','off');
    set(Layout.previousmontage  , 'position', Layout.premontageDim_machine);
    set(Layout.nextmontage      , 'position', Layout.nextmontageDim_machine);
    %%---------------------------------------------------------------------
    set(Layout.nextmontage      , 'visible','on');
    set(Layout.previousmontage  , 'visible','on');
    set(Layout.previousDemoShow , 'visible','off'); 
    set(Layout.nextDemoShow     , 'visible','off');
    set(Layout.legendAnalysis   , 'visible','off');
    set(Layout.legendProcess    , 'visible','off');
    set(Layout.Wells_CheckBox   , 'visible','off');
    set(Layout.Round_CheckBox   , 'visible','off');
    %%---------------------------------------------------------------------
    if (~isempty(ResultPD)  && isfield(ResultPD, 'totalNum'))
        set(Layout.curlReport1      , 'string',['#AreaFiltered/#Total= ',num2str(ResultPD.tagAreaNum),' / ',num2str(ResultPD.totalNum)]); 
        set(Layout.curlReport2      , 'string',['#PeriFiltered/#Total= ',num2str(ResultPD.tagPeriNum),' / ',num2str(ResultPD.totalNum)]);
        set(Layout.curlReport3      , 'string',['#DimFiltered/#Total= ' ,num2str(ResultPD.tagDimNum) ,' / ',num2str(ResultPD.totalNum)]);
    end 
    %%---------------------------------------------------------------------
    set(Layout.Savebtn          , 'visible','off');
    set(Layout.OpenDatabtn      , 'visible','off');
    set(Layout.btnAddND2        , 'visible','off');
    set(Layout.addImageSeq      , 'visible','off');
    %%--------------------------------------------------------------------- 
    
end