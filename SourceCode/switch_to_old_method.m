function [Layout, info] = switch_to_old_method(Layout, info)
%% ------------------------------------------------------------------------
        set( Layout.btnProcess       , 'visible'  , 'on');
        set( Layout.ProcessAgn       , 'visible'  , 'on');
        set( Layout.Processall       , 'visible'  , 'on');
        set( Layout.RadioB           , 'visible'  , 'on');
        set( Layout.TxtBox1          , 'visible'  , 'on');
        set( Layout.TxtBox2          , 'visible'  , 'on');
        set( Layout.TxtBox3          , 'visible'  , 'on');
        set( Layout.TxtBox4          , 'visible'  , 'on');
        set( Layout.TxtBox5          , 'visible'  , 'on');
        set( Layout.TxtBox6          , 'visible'  , 'on');
        set( Layout.Well             , 'visible'  , 'on');
        set( Layout.lowerWrmCritria  , 'visible'  , 'on');
        set( Layout.upperWrmCritria  , 'visible'  , 'on');
        set( Layout.multiplyAreaMask , 'visible'  , 'on');
        set( Layout.detectLevelCoarse, 'visible'  , 'on');
        set( Layout.LevelCoarseWhich , 'visible'  , 'on');
        set( Layout.WormNumNode      , 'visible'  , 'on');
        set( Layout.jgd_criteria     , 'visible'  , 'on');
        set( Layout.AnalyzeAll       , 'visible'  , 'on');
        set( Layout.saveSnapOld      , 'visible'  , 'on');
        set( Layout.TxtBox7          , 'visible'  , 'on');
        set( Layout.TxtBox8          , 'visible'  , 'on');
        set( Layout.TxtBox9          , 'visible'  , 'on');
        set( Layout.TxtBox10         , 'visible'  , 'on');
        set( Layout.TxtBox11         , 'visible'  , 'on');
        set( Layout.TxtBox12         , 'visible'  , 'on');
        set( Layout.TxtBox13         , 'visible'  , 'on');
        set( Layout.TxtBox14         , 'visible'  , 'on');
        set( Layout.MontageRowNumber , 'visible'  , 'on');
        set( Layout.ImageUnitSZ      , 'visible'  , 'on');
        set( Layout.areaBsFilter     , 'visible'  , 'on');
        set( Layout.areaBsFilterH    , 'visible'  , 'on');
        set( Layout.areaBsFilterL    , 'visible'  , 'on');
        set( Layout.periBsdFilter    , 'visible'  , 'on');
        set( Layout.periBsdFilterH   , 'visible'  , 'on');
        set( Layout.periBsdFilterL   , 'visible'  , 'on');
        set( Layout.dimBsdFilter     , 'visible'  , 'on');
        set( Layout.CurlCriteria     , 'visible'  , 'on');
        set( Layout.NearCurlCriteria , 'visible'  , 'on');
        set( Layout.MagCriteria      , 'visible'  , 'on');
        set( Layout.legendProcess    , 'visible'  , 'on');
        set( Layout.legendAnalysis   , 'visible'  , 'on');
        set( Layout.axesImageTen     , 'visible'  , 'on');
        set( Layout.RadioC           , 'visible'  , 'on');
        
        set( Layout.CNN_Machine      , 'visible'  , 'off');
        set( Layout.runMachine       , 'visible'  , 'off');
        set( Layout.runMachineAgn    , 'visible'  , 'off');
        set( Layout.runMachineall    , 'visible'  , 'off');
        set( Layout.lengthArea       , 'visible'  , 'off');
        set( Layout.saveSnapSmart    , 'visible'  , 'off');
        
        set( Layout.loadTrain        , 'visible'  , 'off');
        set( Layout.loadNet          , 'visible'  , 'off');
        set( Layout.AnalyzeNet       , 'visible'  , 'off');
        set( Layout.startTrain       , 'visible'  , 'off');
        set( Layout.confusionBox     , 'visible'  , 'off');
        set( Layout.mOutputTage      , 'visible'  , 'off');
        
        set( Layout.legendTrain      , 'visible'   ,'off');
        set( Layout.legendAnalysis   , 'visible'   ,'off');
        set( Layout.legendProcess    , 'visible'   ,'off');
        %%-----------------------------------------------------------------
        set(Layout.RadioMain         ,'SelectedObject',Layout.OldMethod);
        info.analyzeMethod  = 'OldMethod';
        %%-----------------------------------------------------------------
        set(Layout.Savebtn          , 'visible','on');
        set(Layout.OpenDatabtn      , 'visible','on');
        set(Layout.btnAddND2        , 'visible','on');
        set(Layout.addImageSeq      , 'visible','on')
%%-------------------------------------------------------------------------
end