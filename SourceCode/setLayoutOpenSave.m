function setLayoutOpenSave(info, Layout)



    set(Layout.lowerWrmCritria   , 'string', info.lowerWrmCritria  );
    set(Layout.upperWrmCritria   , 'string', info.upperWrmCritria  );
    set(Layout.multiplyAreaMask  , 'string', info.multiplyAreaMask );
    set(Layout.detectLevelCoarse , 'string', info.detectLevelCoarse);
    set(Layout.LevelCoarseWhich  , 'string', info.LevelCoarseWhich );
    set(Layout.WormNumNode       , 'string', info.WormNumNode      );
    set(Layout.jgd_criteria      , 'string', info. jgd_criteria    );
    set(Layout.MontageRowNumber  , 'string', info.MontageRowNumber );
    set(Layout.ImageUnitSZ       , 'string', info.ImageUnitSZ      );
    set(Layout.areaBsFilter      , 'string', info.areaBsFilter     );
    set(Layout.areaBsFilterH     , 'string', info.areaBsFilterH    );
    set(Layout.areaBsFilterL     , 'string', info.areaBsFilterL    );
    set(Layout.periBsdFilter     , 'string', info.periBsdFilter    );
    set(Layout.periBsdFilterH    , 'string', info.periBsdFilterH   );
    set(Layout.periBsdFilterL    , 'string', info.periBsdFilterL   );
    set(Layout.dimBsdFilter      , 'string', info.dimBsdFilter     );
    set(Layout.CurlCriteria      , 'string', info.CurlCriteria     );
    set(Layout.NearCurlCriteria  , 'string', info.NearCurlCriteria );
    set(Layout.MagCriteria       , 'string', info. MagCriteria     );







     set(Layout.btnProcess     , 'enable'  , 'on');
     set(Layout.ProcessAgn     , 'enable'  , 'on');
     set(Layout.Processall     , 'enable'  , 'on');
     set(Layout.AnalyzeAll     , 'enable'  , 'on');
     set(Layout.Savebtn        , 'enable'  , 'on');
     set(Layout.runMachine     , 'enable'  , 'on');
     set(Layout.runMachineAgn  , 'enable'  , 'on');
     set(Layout.runMachineall  , 'enable'  , 'on');
     %%---------------------------------------------------------------------
     cla(Layout.axesImageOne,'reset');
     cla(Layout.axesImageTen,'reset');
     cla(Layout.axesImageTwo,'reset');
     cla(Layout.axesImageThree,'reset');
     cla(Layout.axesImageFour,'reset');
     cla(Layout.axesImageFive,'reset');
     cla(Layout.axesImageSix ,'reset');
     
     set(Layout.axesImageOne     , 'visible','on');
     set(Layout.axesImageTen     , 'visible','on');
     set(Layout.axesImageTwo     , 'visible','on');
     set(Layout.axesImageThree   , 'visible','off');
     set(Layout.axesImageFour    , 'visible','off');
     set(Layout.curlReport1      , 'visible','off'); 
     set(Layout.curlReport2      , 'visible','off'); 
     set(Layout.curlReport3      , 'visible','off'); 
     set(Layout.nextmontage      , 'visible','off');
     set(Layout.previousmontage  , 'visible','off');
     set(Layout.previousDemoShow , 'visible','on'); 
     set(Layout.nextDemoShow     , 'visible','on');
     set(Layout.legendAnalysis   , 'visible','off');
     set(Layout.legendProcess    , 'visible','on');
     set(Layout.axesImageFive    , 'visible','off');
     set(Layout.axesImageSix     , 'visible','off');
     set(Layout.RadioC           ,'SelectedObject',rc_1);
     set(Layout.Wells_CheckBox   , 'visible','on');
     set(Layout.Round_CheckBox   , 'visible','on');


     
  
     
     
         if        strcmp(info.format,'nd2')==1
         info.Well{1}      = uicontrol('parent', mainPanel, 'style', 'checkbox', 'string', 'FindWell'      , 'position', [1,mainPanel_dim(4)-270,65,20], 'Value',1);
     elseif    strcmp(info.format,'vid')==1
         info.Well{1}      = uicontrol('parent', mainPanel, 'style', 'checkbox', 'string', 'FindWell'      , 'position', [1,mainPanel_dim(4)-270,65,20], 'Value',0);
     end
    
    
     

end