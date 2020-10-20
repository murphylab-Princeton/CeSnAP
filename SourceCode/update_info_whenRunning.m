function info = update_info_whenRunning(Layout, info)

    info.lowerWrmCritria   = Layout.lowerWrmCritria.String;
    info.upperWrmCritria   = Layout.upperWrmCritria.String;
    info.multiplyAreaMask  = Layout.multiplyAreaMask.String;
    info.detectLevelCoarse = Layout.detectLevelCoarse.String;
    info.LevelCoarseWhich  = Layout.LevelCoarseWhich.String;
    info.WormNumNode       = Layout.WormNumNode.String;
    info.jgd_criteria      = Layout.jgd_criteria.String;
    %%-----------------------------
    info.areaBsFilter      = Layout.areaBsFilter.String;
    info.areaBsFilterH     = Layout.areaBsFilterH.String;
    info.areaBsFilterL     = Layout.areaBsFilterL.String;
    info.periBsdFilter     = Layout.periBsdFilter.String;
    info.periBsdFilterH    = Layout.periBsdFilterH.String;
    info.periBsdFilterL    = Layout.periBsdFilterL.String;
    info.dimBsdFilter      = Layout.dimBsdFilter.String;
    info.CurlCriteria      = Layout.CurlCriteria.String;
    info.NearCurlCriteria  = Layout.NearCurlCriteria.String;
    info.MagCriteria       = Layout.MagCriteria.String;
    info.ImageUnitSZ       = Layout.ImageUnitSZ .String;
    info.MontageRowNumber  = Layout.MontageRowNumber.String;

end