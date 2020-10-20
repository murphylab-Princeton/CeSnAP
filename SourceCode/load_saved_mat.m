function [Layout, info, filePD, ResultPD] = load_saved_mat(Layout, info, filePD, ResultPD)
%% ---------------------------------------------------------------------
    [name,~]     = uigetfile('*.mat','open *.mat file');
    set(Layout.command_line ,'string','>> Reading MATLAB file');drawnow;
    load(name);
    %%---------------------------------------------------------------------
    if info.CurrentProcessID==0
        if        strcmp(info.format,'nd2')==1
            load(fullfile(pwd,[info.filename,'_nd2Folder'],[filePD(1).Exp,'_','r',num2str(1),'.mat']),'WellSnapshot');
        elseif    strcmp(info.format,'vid')==1
            load(fullfile(pwd,[info.filename,'_MOVfolder'],[filePD(1).Exp,'_','r',num2str(1),'.mat']),'WellSnapshot');
        end
        imagesc(WellSnapshot{1},'parent', Layout.axesImageOne);set(Layout.axesImageOne  , 'XTick'   ,[],'YTick',[]);
        hold(Layout.axesImageOne, 'on');axis(Layout.axesImageOne,'equal');
    else
         %%--------------------------------------------------------------------
         if strcmp(info.analyzeMethod,'SnapMachine')
             [Layout,info] = switch_to_ML_method(Layout,info);      
         elseif strcmp(info.analyzeMethod,'OldMethod')
             [Layout,info] = switch_to_old_method(Layout,info);     
         end
         if strcmp(info.modeSelction,'Prcss')
                 [Layout, info] = switch_to_Process_layout(Layout, info);
                 if ~isempty(filePD), Layout = plotProcess(Layout, info, filePD, ResultPD); end     
        elseif strcmp(info.modeSelction,'Anlyz')
                 [Layout, info] = switch_to_Analyze_layout(Layout, info, ResultPD);
                 if ~isempty(ResultPD), Layout = plotResult(Layout, info, filePD, ResultPD); end     
        elseif strcmp(info.modeSelction,'Plot')
                 [Layout, info] = switch_to_Plot_layout(Layout, info);
                 if ~isempty(ResultPD), Layout = plotFigures(Layout, info, filePD, ResultPD) ; end   
        end
        %%---------------------------------------------------------------------
    end
    %%-------------------------------------------------------------------------
    set(Layout.TargetFileN, 'string',info.filename);
    %%---------------------------------------------------------------------
    [Layout, info] = WellRoundSelection(max(info.ID2ind_list(:,2)), Layout, info, filePD);
    %%--------------------------------------------------------------------
    sally = fieldnames(filePD);
    trigger = false;
    for i=1:length(sally)
         if strcmp(sally{i},'worms')==1
             trigger = true;
         end    
     end
     set(Layout.command_line ,'string','>> Click Process');drawnow;
     if trigger==true
         set(Layout.AnalyzeAll      , 'enable'  , 'on');
     else
         set(Layout.AnalyzeAll      , 'enable'  , 'off');
         set(Layout.command_line ,'string','>> Click Analyze');drawnow;
     end
     %%--------------------------------------------------------------------
     if isempty(ResultPD)==1
        set(Layout.btnExport       , 'enable'  , 'off');
     else
         set(Layout.btnExport       , 'enable'  , 'on');
         set(Layout.command_line ,'string','>> Export data');drawnow;
     end
     %%--------------------------------------------------------------------
end