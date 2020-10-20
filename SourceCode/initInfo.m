function info = initInfo(info)
%% ------------------------------------------------------------------------
info.listOfExtensions = {'avi', 'MOV'};
info.CurrentProcessID = 0; 
info.montageShownID   = 0;
%%-----------------------------
info.lowerWrmCritria   = '0.1';
info.upperWrmCritria   = '8';
info.multiplyAreaMask  = '12';
info.detectLevelCoarse = '2';
info.LevelCoarseWhich  = '1';
info.WormNumNode       = '60';
info.jgd_criteria      = '1.3';
%%-----------------------------
info.areaBsFilter      = '15';
info.areaBsFilterH     = '0';
info.areaBsFilterL     = '1';
info.periBsdFilter     = '3';
info.periBsdFilterH    = '3';
info.periBsdFilterL    = '0';
info.dimBsdFilter      = '0.05';
info.CurlCriteria      = '0.45';
info.NearCurlCriteria  = '0.7';
info.MagCriteria       = '2';
info.ImageUnitSZ       = '100';
info.MontageRowNumber  = '7';
%%-------------------------------------------------------------------------
info.UnitPicSizeML     = 128*2;
info.analyzeMethod     = 'OldMethod';
info.background        = 'Black background';
info.modeSelction      = 'Process'; 
%%-------------------------------------------------------------------------
info.Well{2}=[]; info.Well{3}=[]; info.Well{4}=[]; info.Well{5}=[]; info.Well{6}=[]; info.Well{7}=[]; 
%%-------------------------------------------------------------------------
info.confusionCheckMatrix    = false(8,8);
%%-------------------------------------------------------------------------
end