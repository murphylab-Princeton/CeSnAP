function setLayoutAtLoad(Layout)
    %% --------------------------------------------------------------------
resetAllFigures(Layout)
    
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
     set(Layout.RadioC,'SelectedObject',rc_1);
     set(Layout.Wells_CheckBox    , 'visible','on');
     set(Layout.Round_CheckBox    , 'visible','on');
     %%---------------------------------------------------------------------
     set(Layout.btnProcess, 'enable', 'on');
     set(Layout.Processall, 'enable', 'on');
     set(Layout.runMachine     , 'enable'  , 'on');
     set(Layout.runMachineall  , 'enable'  , 'on');
     %%---------------------------------------------------------------------
     
     
     
     
     
end