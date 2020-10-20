function [Layout, info] = switch_to_training(Layout, info)
%% --------------------------------------------------------------------
        set( Layout.btnProcess       , 'visible'  , 'off');
        set( Layout.ProcessAgn       , 'visible'  , 'off');
        set( Layout.Processall       , 'visible'  , 'off');
        set( Layout.RadioB           , 'visible'  , 'off');
        set( Layout.TxtBox1          , 'visible'  , 'off');
        set( Layout.TxtBox2          , 'visible'  , 'off');
        set( Layout.TxtBox3          , 'visible'  , 'off');
        set( Layout.TxtBox4          , 'visible'  , 'off');
        set( Layout.TxtBox5          , 'visible'  , 'off');
        set( Layout.TxtBox6          , 'visible'  , 'off');
        set( Layout.Well             , 'visible'  , 'off');
        set( Layout.lowerWrmCritria  , 'visible'  , 'off');
        set( Layout.upperWrmCritria  , 'visible'  , 'off');
        set( Layout.multiplyAreaMask , 'visible'  , 'off');
        set( Layout.detectLevelCoarse, 'visible'  , 'off');
        set( Layout.LevelCoarseWhich , 'visible'  , 'off');
        set( Layout.WormNumNode      , 'visible'  , 'off');
        set( Layout.jgd_criteria     , 'visible'  , 'off');
        set( Layout.AnalyzeAll       , 'visible'  , 'off');
        set( Layout.saveSnapOld      , 'visible'  , 'off');
        set( Layout.TxtBox7          , 'visible'  , 'off');
        set( Layout.TxtBox8          , 'visible'  , 'off');
        set( Layout.TxtBox9          , 'visible'  , 'off');
        set( Layout.TxtBox10         , 'visible'  , 'off');
        set( Layout.TxtBox11         , 'visible'  , 'off');
        set( Layout.TxtBox12         , 'visible'  , 'off');
        set( Layout.TxtBox13         , 'visible'  , 'off');
        set( Layout.TxtBox14         , 'visible'  , 'off');
        set( Layout.MontageRowNumber , 'visible'  , 'off');
        set( Layout.ImageUnitSZ      , 'visible'  , 'off');
        set( Layout.areaBsFilter     , 'visible'  , 'off');
        set( Layout.areaBsFilterH    , 'visible'  , 'off');
        set( Layout.areaBsFilterL    , 'visible'  , 'off');
        set( Layout.periBsdFilter    , 'visible'  , 'off');
        set( Layout.periBsdFilterH   , 'visible'  , 'off');
        set( Layout.periBsdFilterL   , 'visible'  , 'off');
        set( Layout.dimBsdFilter     , 'visible'  , 'off');
        set( Layout.CurlCriteria     , 'visible'  , 'off');
        set( Layout.NearCurlCriteria , 'visible'  , 'off');
        set( Layout.MagCriteria      , 'visible'  , 'off');
        set( Layout.legendProcess    , 'visible'  , 'off');
        set( Layout.legendAnalysis   , 'visible'  , 'off');
        set( Layout.axesImageTen     , 'visible'  , 'off');
        set( Layout.CNN_Machine      , 'visible'  , 'off');
        set( Layout.runMachine       , 'visible'  , 'off');
        set( Layout.runMachineAgn    , 'visible'  , 'off');
        set( Layout.runMachineall    , 'visible'  , 'off');
        set( Layout.lengthArea       , 'visible'  , 'off');
        set( Layout.saveSnapSmart    , 'visible'  , 'off');
        set( Layout.RadioC           , 'visible'  , 'off');
        
        
        set( Layout.legendTrain      , 'visible'   ,'on');
        set( Layout.legendAnalysis   , 'visible'   ,'off');
        set( Layout.legendProcess    , 'visible'   ,'off');
        
        set( Layout.loadTrain        , 'visible'  , 'on');
        set( Layout.loadNet          , 'visible'  , 'on');
        set( Layout.AnalyzeNet       , 'visible'  , 'on');
        set( Layout.startTrain       , 'visible'  , 'on');
        set( Layout.confusionBox     , 'visible'  , 'on');
        set( Layout.mOutputTage      , 'visible'  , 'on');
        
        %%-----------------------------------------------------------------
        set(Layout.RadioMain         ,'SelectedObject',Layout.train);
        info.analyzeMethod  = 'train';
%%-------------------------------------------------------------------------
end