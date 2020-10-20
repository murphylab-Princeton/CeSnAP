function [Layout, info, filePD, ResultPD] = initLayout(Layout,info, filePD, ResultPD)
%% -------------------------------------------------------------------------  
scrsz                    = get(0,'ScreenSize');
mainW                    = scrsz(3);
mainH                    = scrsz(4);
Layout.mainFigure_dim    = [5,40,mainW-10,mainH-70];
Coef                     = (8*((mainW-1366)/554))+16;
defaultImSize            = [floor(Coef*1002/32) floor(Coef*1004/32)]; Layout.defaultImSize = defaultImSize;
Layout.mainPanel_dim     = [1,1,Layout.mainFigure_dim(3)-2,Layout.mainFigure_dim(4)-2];
%%-------------------------------------------------------------------------
Layout.mainFigure        = figure('Visible','off','Position',Layout.mainFigure_dim,'Name','CeSnAP (C. elegans Snapshot Analysis Platform)','numbertitle','off', 'menubar', 'none', 'colormap',gray);
Layout.mainPanel         = uipanel('parent', Layout.mainFigure,'BorderType', 'line','units','pixels', 'position',Layout.mainPanel_dim);
%%-------------------------------------------------------------------------
Layout.TargetFileN       = uicontrol('parent',Layout.mainPanel,'style', 'text', 'string',' ', 'position'        , [1,Layout.mainPanel_dim(4)-62.5,150,20]);
Layout.command_line      = uicontrol('parent',Layout.mainPanel,'style','text', 'FontWeight', 'bold','HorizontalAlignment' , 'left','String','>> Load ND2s or videos','position',[1, Layout.mainPanel_dim(4)-15, 150,13]);
%%-------------------------------------------------------------------------
Layout.btnAddND2         = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string','nd2 Folder'   , 'position', [1,Layout.mainPanel_dim(4)-90,74.5,30]       );
Layout.addImageSeq       = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string','Video Folder'  , 'position', [75.5,Layout.mainPanel_dim(4)-90,75.5,30]    );
Layout.btnExport         = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', 'SaveXLSX'     , 'position', [1,Layout.mainPanel_dim(4)-510,74.5,30]      );
Layout.btnClose          = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', 'Close'        , 'position', [75.5,Layout.mainPanel_dim(4)-510,75.5,30]   );
Layout.Savebtn           = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', 'SaveProject'  , 'position', [1,Layout.mainPanel_dim(4)-120,74.5,30]      );
Layout.OpenDatabtn       = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', 'OpenSaved'    , 'position', [75.5,Layout.mainPanel_dim(4)-120,75.5,30]   );
Layout.btnProcess        = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', 'Process Next' , 'position', [1,Layout.mainPanel_dim(4)-150,150,30]       );
Layout.ProcessAgn        = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', 'Process Again', 'position', [1,Layout.mainPanel_dim(4)-180,150,30]       );
Layout.Processall        = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', 'Process All'  , 'position', [1,Layout.mainPanel_dim(4)-210,150,30]       );
Layout.CNN_Machine       = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', 'Load trained network'     , 'position', [1,Layout.mainPanel_dim(4)-150,150,30]       );
Layout.runMachine        = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', 'Run Next'     , 'position', [1,Layout.mainPanel_dim(4)-180,150,30]       );
Layout.runMachineAgn     = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', 'Run Again'    , 'position', [1,Layout.mainPanel_dim(4)-210,150,30]       );
Layout.runMachineall     = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', 'Run All'      , 'position', [1,Layout.mainPanel_dim(4)-240,150,30]       );
Layout.lengthArea        = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', 'Length/Area'  , 'position', [1,Layout.mainPanel_dim(4)-560,74.5,30]       );
Layout.saveSnapSmart     = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', 'Save Blobs'   , 'position', [75.5,Layout.mainPanel_dim(4)-560,75.5,30]       );
Layout.loadTrain         = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', 'Load worm blobs'    , 'position', [1,Layout.mainPanel_dim(4)-90,150,30]       );
Layout.loadNet           = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', 'Load C-NN', 'position', [1,Layout.mainPanel_dim(4)-120,99.5,30]       );
Layout.AnalyzeNet        = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', 'Refresh'         , 'position', [100.5,Layout.mainPanel_dim(4)-120,51,30]       );
Layout.startTrain        = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', 'Train new C-NN'       , 'position', [1,Layout.mainPanel_dim(4)-150,150,30]       );
%%-------------------------------------------------------------------------
%%-------------------------------------------------------------------------
Layout.RadioMain         = uibuttongroup('parent',Layout.mainPanel,'Visible','on','units','pixels','position',[1,Layout.mainPanel_dim(4)-40,150,20]);
Layout.OldMethod         = uicontrol('parent',Layout.RadioMain,'Style','radiobutton','String','Sgmnt','position',  [1  ,1,55,20],'HandleVisibility','off','FontSize',8,'FontWeight', 'bold');
Layout.train             = uicontrol('parent',Layout.RadioMain,'Style','radiobutton','String','Train','position',      [56 ,1,48,20],'HandleVisibility','off','FontSize',8,'FontWeight', 'bold');
Layout.SnapMachine       = uicontrol('parent',Layout.RadioMain,'Style','radiobutton','String','Qntfy','position',[101,1,65,20],'HandleVisibility','off','FontSize',8,'FontWeight', 'bold');
Layout.RadioB            = uibuttongroup('parent',Layout.mainPanel,'Visible','on','units','pixels','position',[1,Layout.mainPanel_dim(4)-230,150,20]);
Layout.BlackBackG        = uicontrol('parent',Layout.RadioB,'Style','radiobutton','String','BlackBackG','position',[1,1,74.5,20],'HandleVisibility','off');
Layout.WhiteBackG        = uicontrol('parent',Layout.RadioB,'Style','radiobutton','String','WhiteBackG','position',[75.5,1,74.5,20],'HandleVisibility','off');
Layout.RadioC            = uibuttongroup('parent',Layout.mainPanel,'Visible','on','units','pixels','position',[1,Layout.mainPanel_dim(4)-530,150,20]);
Layout.Prcss             = uicontrol('parent',Layout.RadioC,'Style','radiobutton','String','Prcss','position',[1,1,55,20],'HandleVisibility','off');
Layout.Anlyz             = uicontrol('parent',Layout.RadioC,'Style','radiobutton','String','Anlyz','position',[55,1,55,20],'HandleVisibility','off');
Layout.Plot              = uicontrol('parent',Layout.RadioC,'Style','radiobutton','String','Plot','position',[110,1,150,20],'HandleVisibility','off');
%%-------------------------------------------------------------------------
Layout.TxtBox1           = uicontrol('parent', Layout.mainPanel, 'style', 'text', 'string', '-'                   , 'position', [25,Layout.mainPanel_dim(4)-250,10,20]);
Layout.TxtBox2           = uicontrol('parent', Layout.mainPanel, 'style', 'text', 'string', 'min/max area-limit'  , 'position', [60,Layout.mainPanel_dim(4)-252,90,20]); 
Layout.TxtBox3           = uicontrol('parent', Layout.mainPanel, 'style', 'text', 'string', 'Mask-area'           , 'position', [65,Layout.mainPanel_dim(4)-272,60,20]); 
Layout.TxtBox4           = uicontrol('parent', Layout.mainPanel, 'style', 'text', 'string', 'Levels-Otsu method'  , 'position', [1,Layout.mainPanel_dim(4)-292 ,100,20]);
Layout.TxtBox5           = uicontrol('parent', Layout.mainPanel, 'style', 'text', 'string', 'N-Node'              , 'position', [1,Layout.mainPanel_dim(4)-312,45,20]);
Layout.TxtBox6           = uicontrol('parent', Layout.mainPanel, 'style', 'text', 'string', 'Jggedns'             , 'position', [75,Layout.mainPanel_dim(4)-312,45,20]);
Layout.Well              = uicontrol('parent', Layout.mainPanel, 'style', 'checkbox', 'string', 'FindWell'        , 'position', [1,Layout.mainPanel_dim(4)-270,65,20], 'Value',1);
Layout.lowerWrmCritria   = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info.lowerWrmCritria  , 'position', [1,Layout.mainPanel_dim(4)-250,25,20]);
Layout.upperWrmCritria   = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info.upperWrmCritria  , 'position', [35,Layout.mainPanel_dim(4)-250,25,20]);
Layout.multiplyAreaMask  = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info.multiplyAreaMask , 'position', [125,Layout.mainPanel_dim(4)-270,25,20]);
Layout.detectLevelCoarse = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info.detectLevelCoarse, 'position', [100,Layout.mainPanel_dim(4)-290 ,24.75,20]);
Layout.LevelCoarseWhich  = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info.LevelCoarseWhich , 'position', [125.25,Layout.mainPanel_dim(4)-290 ,24.75,20]);
Layout.WormNumNode       = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info.WormNumNode      , 'position', [45,Layout.mainPanel_dim(4)-310,30,20]);
Layout.jgd_criteria      = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info. jgd_criteria    , 'position', [120,Layout.mainPanel_dim(4)-310,30,20]);
%%-------------------------------------------------------------------------
Layout.AnalyzeAll        = uicontrol('parent', Layout.mainPanel, 'style', 'pushbutton', 'string', 'Analyze'       , 'position', [1,Layout.mainPanel_dim(4)-340,74.5,30]);
Layout.saveSnapOld       = uicontrol('parent', Layout.mainPanel, 'style', 'pushbutton', 'string', 'Save Blobs'    , 'position', [75.5,Layout.mainPanel_dim(4)-340,75.5,30]);
Layout.TxtBox7           = uicontrol('parent', Layout.mainPanel, 'style', 'text', 'string',  'MRow-N'             , 'position', [1,Layout.mainPanel_dim(4)-362,45,20]);
Layout.TxtBox8           = uicontrol('parent', Layout.mainPanel, 'style', 'text', 'string',  'MUnitSize'          , 'position', [70,Layout.mainPanel_dim(4)-362,50,20]);
Layout.TxtBox9           = uicontrol('parent', Layout.mainPanel, 'style', 'text', 'string', 'Censor area outliers', 'position', [1,Layout.mainPanel_dim(4)-382,100,20]);
Layout.TxtBox10          = uicontrol('parent', Layout.mainPanel, 'style', 'text', 'string', 'Censor peri outliers', 'position', [1,Layout.mainPanel_dim(4)-402,100,20]);
Layout.TxtBox11          = uicontrol('parent', Layout.mainPanel, 'style', 'text', 'string', 'Circularity filter'  , 'position', [1,Layout.mainPanel_dim(4)-422,100,20]);
Layout.TxtBox12          = uicontrol('parent', Layout.mainPanel, 'style', 'text', 'string', 'Curl cut-off'        , 'position', [1,Layout.mainPanel_dim(4)-442 ,100,20]);
Layout.TxtBox13          = uicontrol('parent', Layout.mainPanel, 'style', 'text', 'string', 'Near-curl shrink-f'  , 'position', [1,Layout.mainPanel_dim(4)-462,100,20]);
Layout.TxtBox14          = uicontrol('parent', Layout.mainPanel, 'style', 'text', 'string', 'Near-curl circ-ratio', 'position', [1,Layout.mainPanel_dim(4)-480,100,20]);
Layout.MontageRowNumber  = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info.MontageRowNumber  , 'position', [47,Layout.mainPanel_dim(4)-360,20,20]);
Layout.ImageUnitSZ       = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info.ImageUnitSZ      , 'position', [120,Layout.mainPanel_dim(4)-360,30,20]);
Layout.areaBsFilter      = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info.areaBsFilter     , 'position', [100,Layout.mainPanel_dim(4)-380,17,20]);
Layout.areaBsFilterH     = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info.areaBsFilterH    , 'position', [133,Layout.mainPanel_dim(4)-380,16,20]);
Layout.areaBsFilterL     = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info.areaBsFilterL    , 'position', [117,Layout.mainPanel_dim(4)-380,16,20]);
Layout.periBsdFilter     = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info.periBsdFilter    , 'position', [100,Layout.mainPanel_dim(4)-400,17,20]);
Layout.periBsdFilterH    = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info.periBsdFilterH   , 'position', [133,Layout.mainPanel_dim(4)-400,16,20]);
Layout.periBsdFilterL    = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info.periBsdFilterL   , 'position', [117,Layout.mainPanel_dim(4)-400,16,20]);
Layout.dimBsdFilter      = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info.dimBsdFilter     , 'position', [100,Layout.mainPanel_dim(4)-420,50,20]);
Layout.CurlCriteria      = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info.CurlCriteria     , 'position', [100,Layout.mainPanel_dim(4)-440 ,50,20]);
Layout.NearCurlCriteria  = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info.NearCurlCriteria , 'position', [100,Layout.mainPanel_dim(4)-460,50,20]);
Layout.MagCriteria       = uicontrol('parent', Layout.mainPanel, 'style', 'edit', 'string', info. MagCriteria     , 'position', [100,Layout.mainPanel_dim(4)-480,50,20]);
%%-------------------------------------------------------------------------
figOneDim                = [160, Layout.mainPanel_dim(4)-defaultImSize(2)-5, defaultImSize(1), defaultImSize(2)]; Layout.figOneDim = figOneDim;
Layout.axesImageOne      = axes('parent',Layout.mainPanel,'SortMethod','childorder','units','pixels','Position',figOneDim,'XTick',[],'YTick',[],'visible','on', 'box', 'on'); 
figTwoDim                = [figOneDim(1)+defaultImSize(1)+10, Layout.mainPanel_dim(4)-defaultImSize(2)-5, defaultImSize(1), defaultImSize(2)]; Layout.figTwoDim = figTwoDim;
Layout.axesImageTwo      = axes('parent',Layout.mainPanel,'SortMethod','childorder','units','pixels','Position',figTwoDim,'XTick',[],'YTick',[],'visible','on', 'box', 'on');
Layout.previousDemoShow  = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', '<<', 'FontSize',25 ,'FontWeight', 'bold', 'position', [160,Layout.mainPanel_dim(4)-defaultImSize(2)-100,70,50], 'visible', 'on');
Layout.nextDemoShow      = uicontrol('parent',Layout.mainPanel,'style','pushbutton', 'string', '>>', 'FontSize',25 ,'FontWeight', 'bold','position', [230,Layout.mainPanel_dim(4)-defaultImSize(2)-100,70,50], 'visible', 'on');
FontSizeReport           = 12*Layout.mainPanel_dim(4)/694;
figThreeDim              = [170,(16.40*Layout.mainPanel_dim(4)/32),(Layout.mainPanel_dim(3)-180),(15.5*Layout.mainPanel_dim(4)/32)];
figFourDim               = [170,(0.1*Layout.mainPanel_dim(4)/32),(Layout.mainPanel_dim(3)-180),(15.5*Layout.mainPanel_dim(4)/32)];
premontageDim_oldMethod  = [170,(figThreeDim(2)+figFourDim(2)+figFourDim(4))/2 - Layout.mainPanel_dim(4)/34.7/2,Layout.mainPanel_dim(3)/30.05,Layout.mainPanel_dim(4)/34.7];                                       Layout.premontageDim_oldMethod=premontageDim_oldMethod;
nextmontageDim_oldMethod = [170+Layout.mainPanel_dim(3)/28.8,(figThreeDim(2)+figFourDim(2)+figFourDim(4))/2 - Layout.mainPanel_dim(4)/34.7/2,Layout.mainPanel_dim(3)/30.05,Layout.mainPanel_dim(4)/34.7];          Layout.nextmontageDim_oldMethod=nextmontageDim_oldMethod;
premontageDim_machine    = [1,Layout.mainPanel_dim(4)-480,74.5,30];         Layout.premontageDim_machine  = premontageDim_machine;
nextmontageDim_machine   = [75.5,Layout.mainPanel_dim(4)-480,74.5,30];      Layout.nextmontageDim_machine = nextmontageDim_machine;
Layout.curlReport1       = uicontrol('parent', Layout.mainPanel,'style','text', 'string', 'area-based censor', 'position', [250,(figThreeDim(2)+figFourDim(2)+figFourDim(4))/2 - Layout.mainPanel_dim(4)/34.7/2,(Layout.mainPanel_dim(3)-300)/3,Layout.mainPanel_dim(4)/38.55], 'visible','off', 'FontWeight','bold','FontSize', FontSizeReport);
Layout.curlReport2       = uicontrol('parent', Layout.mainPanel,'style','text', 'string', 'peri-based censor', 'position', [250+(figThreeDim(2)+figFourDim(2)+figFourDim(4))/2 - Layout.mainPanel_dim(4)/34.7/2,(15.57*Layout.mainPanel_dim(4)/32),(Layout.mainPanel_dim(3)-300)/3,Layout.mainPanel_dim(4)/38.55], 'visible','off', 'FontWeight','bold','FontSize', FontSizeReport);
Layout.curlReport3       = uicontrol('parent', Layout.mainPanel,'style','text', 'string', 'Circ-based censor', 'position', [250+2*(Layout.mainPanel_dim(3)-250)/3,(15.57*Layout.mainPanel_dim(4)/32),(Layout.mainPanel_dim(3)-300)/3,Layout.mainPanel_dim(4)/38.55], 'visible','off', 'FontWeight','bold','FontSize', FontSizeReport);
Layout.previousmontage   = uicontrol('parent', Layout.mainPanel,'style','pushbutton', 'string', '<<', 'position', premontageDim_oldMethod, 'visible', 'off','FontWeight','bold','FontSize', 20);
Layout.nextmontage       = uicontrol('parent', Layout.mainPanel,'style','pushbutton', 'string', '>>', 'position', nextmontageDim_oldMethod,'visible', 'off','FontWeight','bold','FontSize', 20);
Layout.axesImageThree    = axes('parent',Layout.mainPanel,'SortMethod','childorder','units','pixels','Position', figThreeDim ,'XTick',[],'YTick',[],'visible','off', 'box', 'on');         
Layout.axesImageFour     = axes('parent',Layout.mainPanel,'SortMethod','childorder','units','pixels','Position', figFourDim  ,'XTick',[],'YTick',[],'visible','off', 'box', 'on');        
%%-------------------------------------------------------------------------
figFiveDim               = [160,Layout.mainPanel_dim(4)-defaultImSize(2)*3/4,defaultImSize(1),defaultImSize(2)/2];
figSixDim                = [figOneDim(1)+defaultImSize(1)+10, Layout.mainPanel_dim(4)-defaultImSize(2)*3/4, defaultImSize(1), defaultImSize(2)/2];
Layout.axesImageFive     = axes('parent',Layout.mainPanel,'SortMethod','childorder','units','pixels','Position',[figFiveDim(1)+floor(0.15*figFiveDim(3)),figFiveDim(2),floor(0.85*figFiveDim(3)),figFiveDim(4)],'XTick',[],'YTick',[],'visible','off', 'box', 'on' );
Layout.axesImageSix      = axes('parent',Layout.mainPanel,'SortMethod','childorder','units','pixels','Position',[figSixDim(1)+floor(0.15*figSixDim(3)),figSixDim(2),floor(0.85*figSixDim(3)),figSixDim(4)],'XTick',[],'YTick',[],'visible','off', 'box', 'on');
%%-------------------------------------------------------------------------
figSevenDim              = [179,(0.1*Layout.mainPanel_dim(4)/32),(Layout.mainPanel_dim(3)-180),(31.9*Layout.mainPanel_dim(4)/32)];
Layout.axesImageSeven    = axes('parent',Layout.mainPanel,'SortMethod','childorder','units','pixels','Position', figSevenDim ,'XTick',[],'YTick',[],'visible','off', 'box', 'on');         
%%-------------------------------------------------------------------------
figTenDim                = [160, Layout.mainPanel_dim(4)-defaultImSize(2)-5, floor(0.4*defaultImSize(1)), floor(0.2*defaultImSize(2))];
Layout.axesImageTen      = axes('parent',Layout.mainPanel,'SortMethod','childorder','units','pixels','Position',figTenDim,'XTick',[],'YTick',[],'visible','on', 'box', 'on');
%%-------------------------------------------------------------------------
Layout.Wells_CheckBox    = uipanel('parent',Layout.mainPanel,'BorderType','line','BackgroundColor','c','units','pixels','Position', [figTwoDim(1)+defaultImSize(1)-400, Layout.mainPanel_dim(4)-defaultImSize(2)-60,400,55]);
Layout.Round_CheckBox    = uipanel('parent',Layout.mainPanel,'BorderType','line','BackgroundColor','c','units','pixels','Position', [figOneDim(1)+defaultImSize(1)-300, Layout.mainPanel_dim(4)-defaultImSize(2)-75,300,25]);
%%-------------------------------------------------------------------------
Layout.legendAnalysisDim = [1,Layout.mainPanel_dim(4)-695,150,165];
Layout.legendAnalysis    = uipanel('parent', Layout.mainPanel,'BorderType', 'line','units','pixels', 'position',Layout.legendAnalysisDim);
Layout.upLeg             = uicontrol('parent', Layout.legendAnalysis, 'style', 'text', 'string', 'Top figure legend' , 'position'                                         ,[20,Layout.legendAnalysisDim(4)-20,100,20],'FontSize',10,'FontAngle','italic');
Layout.upPan1            = uipanel  ('parent', Layout.legendAnalysis,'BorderType', 'line','units','pixels', 'BackgroundColor', 'red', 'position'                          ,[10,Layout.legendAnalysisDim(4)-35,15,15]);
Layout.upLeg1            = uicontrol('parent', Layout.legendAnalysis, 'style', 'text', 'string',                               'Passed all filters' , 'position'          ,[20,Layout.legendAnalysisDim(4)-35,100,15]);
Layout.upPan2            = uipanel  ('parent', Layout.legendAnalysis,'BorderType', 'line','units','pixels', 'BackgroundColor', 'yellow', 'position'                       ,[10,Layout.legendAnalysisDim(4)-50,15,15]);
Layout.upLeg2            = uicontrol('parent', Layout.legendAnalysis, 'style', 'text', 'string',                               'Censored area outliers' , 'position'      ,[20,Layout.legendAnalysisDim(4)-50,100,15]);
Layout.upPan3            = uipanel  ('parent', Layout.legendAnalysis,'BorderType', 'line','units','pixels', 'BackgroundColor', 'cyan', 'position'                         ,[10,Layout.legendAnalysisDim(4)-65,15,15]);
Layout.upLeg3            = uicontrol('parent', Layout.legendAnalysis, 'style', 'text', 'string',                               'Censored perimiter outliers' , 'position' ,[20,Layout.legendAnalysisDim(4)-65,100,15]);
Layout.upPan4            = uipanel  ('parent', Layout.legendAnalysis,'BorderType', 'line','units','pixels', 'BackgroundColor', 'green', 'position'                        ,[10,Layout.legendAnalysisDim(4)-80,15,15]);
Layout.upLeg4            = uicontrol('parent', Layout.legendAnalysis, 'style', 'text', 'string',                               'area+perimeter outliers' , 'position'     ,[20,Layout.legendAnalysisDim(4)-80,100,15]);
Layout.upPan5            = uipanel  ('parent', Layout.legendAnalysis,'BorderType', 'line','units','pixels', 'BackgroundColor', 'magenta', 'position'                      ,[10,Layout.legendAnalysisDim(4)-95,15,15]);
Layout.upLeg5            = uicontrol('parent', Layout.legendAnalysis, 'style', 'text', 'string',                               'Low circularity' , 'position'             ,[20,Layout.legendAnalysisDim(4)-95,100,15]);
Layout.botLeg            = uicontrol('parent', Layout.legendAnalysis, 'style', 'text', 'string', 'Bottom figure legend' , 'position', [20,Layout.legendAnalysisDim(4)-120,100,20],'FontSize',10,'FontAngle','italic');
Layout.botPan1           = uipanel  ('parent', Layout.legendAnalysis,'BorderType', 'line','units','pixels', 'BackgroundColor', 'red', 'position'                          ,[10,Layout.legendAnalysisDim(4)-130,15,15]);
Layout.botLeg1           = uicontrol('parent', Layout.legendAnalysis, 'style', 'text', 'string',                               'Curled' , 'position'                      ,[20,Layout.legendAnalysisDim(4)-130,100,15]);
Layout.botPan2           = uipanel  ('parent', Layout.legendAnalysis,'BorderType', 'line','units','pixels', 'BackgroundColor', 'green', 'position'                        ,[10,Layout.legendAnalysisDim(4)-145,15,15]);
Layout.botLeg2           = uicontrol('parent', Layout.legendAnalysis, 'style', 'text', 'string',                               'Nearlr-curled' , 'position'               ,[20,Layout.legendAnalysisDim(4)-145,100,15]);
Layout.botPan3           = uipanel  ('parent', Layout.legendAnalysis,'BorderType', 'line','units','pixels', 'BackgroundColor', 'blue', 'position'                         ,[10,Layout.legendAnalysisDim(4)-160,15,15]);
Layout.botLeg3           = uicontrol('parent', Layout.legendAnalysis, 'style', 'text', 'string',                               'Non-curled' , 'position'                  ,[20,Layout.legendAnalysisDim(4)-160,100,15]);
%%-------------------------------------------------------------------------
Layout.legendProcessDim  = [1,Layout.mainPanel_dim(4)-695,130,165];
Layout.legendProcess     = uipanel('parent', Layout.mainPanel,'BorderType', 'line','units','pixels', 'position',Layout.legendProcessDim);
Layout.botLef            = uicontrol('parent', Layout.legendProcess, 'style', 'text', 'string', 'legendProcess' , 'position'                                               ,[20,Layout.legendProcessDim(4)-20,100,20],'FontSize',10,'FontAngle','italic');
Layout.botPam1           = uipanel  ('parent', Layout.legendProcess,'BorderType', 'line','units','pixels', 'BackgroundColor', 'blue', 'position'                           ,[2,Layout.legendProcessDim(4)-35,15,15]);
Layout.botLef1           = uicontrol('parent', Layout.legendProcess, 'style', 'text', 'string',                               'Detected objects' , 'position'              ,[17,Layout.legendProcessDim(4)-37,100,15]);
Layout.botPam2           = uipanel  ('parent', Layout.legendProcess,'BorderType', 'line','units','pixels', 'BackgroundColor', 'green', 'position'                          ,[2,Layout.legendProcessDim(4)-50,15,15]);
Layout.botLef2           = uicontrol('parent', Layout.legendProcess, 'style', 'text', 'string',                               'Objects hit mask' , 'position'              ,[22,Layout.legendProcessDim(4)-52,100,15]);
Layout.botPam3           = uipanel  ('parent', Layout.legendProcess,'BorderType', 'line','units','pixels', 'BackgroundColor', 'cyan', 'position'                           ,[2,Layout.legendProcessDim(4)-65,15,15]);
Layout.botLef3           = uicontrol('parent', Layout.legendProcess, 'style', 'text', 'string',                               'Sacrificed smaller' , 'position'       ,[17,Layout.legendProcessDim(4)-67,120,15]);
Layout.botPam4           = uipanel  ('parent', Layout.legendProcess,'BorderType', 'line','units','pixels', 'BackgroundColor', 'red', 'position'                            ,[2,Layout.legendProcessDim(4)-80,15,15]);
Layout.botLef4           = uicontrol('parent', Layout.legendProcess, 'style', 'text', 'string',                               'Very thin objects' , 'position'             ,[22,Layout.legendProcessDim(4)-82,100,15]);
Layout.botPam5           = uipanel  ('parent', Layout.legendProcess,'BorderType', 'line','units','pixels', 'BackgroundColor', 'red', 'position'                            ,[2,Layout.legendProcessDim(4)-95,15,15]);
Layout.botLef5           = uicontrol('parent', Layout.legendProcess, 'style', 'text', 'string',                               'Few boundary nodes' , 'position'            ,[17,Layout.legendProcessDim(4)-97,120,15]);
Layout.botPam6           = uipanel  ('parent', Layout.legendProcess,'BorderType', 'line','units','pixels', 'BackgroundColor', 'yellow', 'position'                         ,[2,Layout.legendProcessDim(4)-110,15,15]);
Layout.botLef6           = uicontrol('parent', Layout.legendProcess, 'style', 'text', 'string',                               'Jaggedness filtered' , 'position'           ,[22,Layout.legendProcessDim(4)-112,100,15]);
Layout.botPam7           = uipanel  ('parent', Layout.legendProcess,'BorderType', 'line','units','pixels', 'BackgroundColor', [1 0.6 0], 'position'                        ,[2,Layout.legendProcessDim(4)-125,15,15]);
Layout.botLef7           = uicontrol('parent', Layout.legendProcess, 'style', 'text', 'string',                               'Low area pre-filtered' , 'position'         ,[17,Layout.legendProcessDim(4)-127,110,15]);
Layout.botPam8           = uipanel  ('parent', Layout.legendProcess,'BorderType', 'line','units','pixels', 'BackgroundColor', [251 111 66]./ 255, 'position'               ,[2,Layout.legendProcessDim(4)-140,15,15]);
Layout.botLef8           = uicontrol('parent', Layout.legendProcess, 'style', 'text', 'string',                               'High area pre-filered' , 'position'         ,[17,Layout.legendProcessDim(4)-142,110,15]);
Layout.botPam9           = uipanel  ('parent', Layout.legendProcess,'BorderType', 'line','units','pixels', 'BackgroundColor', 'magenta', 'position'                        ,[2,Layout.legendProcessDim(4)-155,15,15]);
Layout.botLef9           = uicontrol('parent', Layout.legendProcess, 'style', 'text', 'string',                               'Out of Well objects' , 'position'           ,[22,Layout.legendProcessDim(4)-157,100,15]);
%%-------------------------------------------------------------------------
%%-------------------------------------------------------------------------
Layout.legendTrainDim    = [1,Layout.mainPanel_dim(4)-695,130,165];
Layout.mStrColor         = {'yellow','red','magenta','green','blue','cyan',[1 0.6 0],[251 111 66]./ 255};
Layout.legendTrain       = uipanel('parent', Layout.mainPanel,'BorderType', 'line','units','pixels', 'position',Layout.legendTrainDim);
Layout.botLef            = uicontrol('parent', Layout.legendTrain, 'style', 'text', 'string', 'legendTrain' , 'position'                                 ,[20,Layout.legendTrainDim(4)-20,100,20],'FontSize',10,'FontAngle','italic');
Layout.botPam1           = uipanel  ('parent', Layout.legendTrain,'BorderType', 'line','units','pixels', 'BackgroundColor', Layout.mStrColor{1} , 'position'           ,[5,Layout.legendTrainDim(4)-35,15,15]);
Layout.botLef1           = uicontrol('parent', Layout.legendTrain, 'style', 'text', 'string',                               'Label-1' , 'position'         ,[30,Layout.legendTrainDim(4)-37,100,15],'HorizontalAlignment', 'left');
Layout.botPam2           = uipanel  ('parent', Layout.legendTrain,'BorderType', 'line','units','pixels', 'BackgroundColor', Layout.mStrColor{2}, 'position'             ,[5,Layout.legendTrainDim(4)-50,15,15]);
Layout.botLef2           = uicontrol('parent', Layout.legendTrain, 'style', 'text', 'string',                               'Label-2' , 'position'         ,[30,Layout.legendTrainDim(4)-52,100,15],'HorizontalAlignment', 'left');
Layout.botPam3           = uipanel  ('parent', Layout.legendTrain,'BorderType', 'line','units','pixels', 'BackgroundColor', Layout.mStrColor{3}, 'position'            ,[5,Layout.legendTrainDim(4)-65,15,15]);
Layout.botLef3           = uicontrol('parent', Layout.legendTrain, 'style', 'text', 'string',                               'Label-3' , 'position'         ,[30,Layout.legendTrainDim(4)-67,120,15],'HorizontalAlignment', 'left');
Layout.botPam4           = uipanel  ('parent', Layout.legendTrain,'BorderType', 'line','units','pixels', 'BackgroundColor', Layout.mStrColor{4}, 'position'              ,[5,Layout.legendTrainDim(4)-80,15,15]);
Layout.botLef4           = uicontrol('parent', Layout.legendTrain, 'style', 'text', 'string',                               'Label-4' , 'position'         ,[30,Layout.legendTrainDim(4)-82,100,15],'HorizontalAlignment', 'left');
Layout.botPam5           = uipanel  ('parent', Layout.legendTrain,'BorderType', 'line','units','pixels', 'BackgroundColor', Layout.mStrColor{5}, 'position'             ,[5,Layout.legendTrainDim(4)-95,15,15]);
Layout.botLef5           = uicontrol('parent', Layout.legendTrain, 'style', 'text', 'string',                               'Label-5' , 'position'         ,[30,Layout.legendTrainDim(4)-97,120,15],'HorizontalAlignment', 'left');
Layout.botPam6           = uipanel  ('parent', Layout.legendTrain,'BorderType', 'line','units','pixels', 'BackgroundColor', Layout.mStrColor{6}, 'position'          ,[5,Layout.legendTrainDim(4)-110,15,15]);
Layout.botLef6           = uicontrol('parent', Layout.legendTrain, 'style', 'text', 'string',                               'Label-6' , 'position'         ,[30,Layout.legendTrainDim(4)-112,100,15],'HorizontalAlignment', 'left');
Layout.botPam7           = uipanel  ('parent', Layout.legendTrain,'BorderType', 'line','units','pixels', 'BackgroundColor', Layout.mStrColor{7}, 'position'          ,[5,Layout.legendTrainDim(4)-125,15,15]);
Layout.botLef7           = uicontrol('parent', Layout.legendTrain, 'style', 'text', 'string',                               'Label-7' , 'position'         ,[30,Layout.legendTrainDim(4)-127,110,15],'HorizontalAlignment', 'left');
Layout.botPam8           = uipanel  ('parent', Layout.legendTrain,'BorderType', 'line','units','pixels', 'BackgroundColor', Layout.mStrColor{8}, 'position' ,[5,Layout.legendTrainDim(4)-140,15,15]);
Layout.botLef8           = uicontrol('parent', Layout.legendTrain, 'style', 'text', 'string',                               'Label-8' , 'position'         ,[30,Layout.legendTrainDim(4)-142,110,15],'HorizontalAlignment', 'left');
%%-------------------------------------------------------------------------
%%-------------------------------------------------------------------------
Layout.mLabelWidth   = 25;
Layout.CNNlabelWidth = 25;
Layout.textHight     = 15;
Layout.mOutputTage       = uicontrol('parent',Layout.mainPanel,'style', 'text', 'string','Output Class','units','pixels','Position', [Layout.mLabelWidth,Layout.mainPanel_dim(4)-229,175-Layout.mLabelWidth,Layout.textHight],'FontSize',10,'FontWeight','bold','visible','off');
Layout.confusionBox      = uipanel('parent',Layout.mainPanel,'BorderType','line','HighlightColor','k','units','pixels','Position', [1,Layout.mainPanel_dim(4)-450,175,220]);
Layout.confMatrixPanel   = uipanel('parent',Layout.confusionBox,'BorderType','line','HighlightColor','k','units','pixels','Position', [Layout.mLabelWidth,1,Layout.confusionBox.Position(3)-Layout.mLabelWidth,Layout.confusionBox.Position(4)-Layout.textHight]);
for i=1:8
    Layout.mLabelTag{i}  = uicontrol('parent',Layout.confusionBox,'style', 'text', 'string','','position',[1,1,10,10],'FontSize',8,'HandleVisibility','off','visible','off');      
end
for j=1:8
    Layout.mCNNTag{j}    = uicontrol('parent',Layout.confusionBox,'style', 'text', 'string','','position',[1,1,10,10],'FontSize',8,'HandleVisibility','off','visible','off');      
end
for i=1:8
for j=1:8
    Layout.confButton{i}{j}   = uicontrol('parent',Layout.confMatrixPanel,'Style','checkbox','Value',0,'position',[1,1,10,10],'FontSize',7,'HandleVisibility','off','visible','off');
    Layout.confPercent{i}{j}  = uicontrol('parent',Layout.confMatrixPanel,'style', 'text', 'string','','position',[1,1,10,10],'FontSize',7,'HandleVisibility','off', 'FontWeight','bold','visible','off'); 
end
end
%%-------------------------------------------------------------------------
%%-------------------------------------------------------------------------
for well_ID = 1:96,    Layout.WellButton{well_ID} = uicontrol('parent',Layout.Wells_CheckBox ,'Style','checkbox','String','','Value',1,'position',[1,1,45,13],'FontSize',9,'HandleVisibility','off','visible','off' );end
for condition_num=1:8, Layout.ConditionName{condition_num}=uicontrol('parent', Layout.Wells_CheckBox,'style', 'edit'   ,'string', '', 'position', [1,1,59,15],'visible','off');end
for k = 1:15,          Layout.RoundButton{k}=uicontrol('parent',Layout.Round_CheckBox,'Style' ,'checkbox','String','','Value',1,'position',[1,1,45,15],'FontSize',9,'HandleVisibility','off', 'visible','off'); end                                   
%%-------------------------------------------------------------------------
%%-------------------------------------------------------------------------
end


