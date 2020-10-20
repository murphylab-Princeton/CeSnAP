function Layout = plotProcessedThreshold(Layout, info, filePD,ResultPD)
if ~isfield(filePD, 'my_imds')
if isfield(filePD(1).worms{1}{1}, 'worm_bc_trash')
%% ------------------------------------
        aa = info.ID2ind_list(info.CurrentProcessID,1);
        bb = info.ID2ind_list(info.CurrentProcessID,2);
        cc = info.ID2ind_list(info.CurrentProcessID,3);
        
        if        strcmp(info.format,'nd2')==1
            load(fullfile(pwd,[info.filename,'_nd2Folder'],[filePD(aa).Exp,'_','r',num2str(bb),'.mat']),'WellSnapshot');
        elseif    strcmp(info.format,'vid')==1
            load(fullfile(pwd,[info.filename,'_MOVfolder'],[filePD(aa).Exp,'_','r',num2str(bb),'.mat']),'WellSnapshot');
        end
        snapshots = WellSnapshot{cc};
        
       imagesc(snapshots,'parent', Layout.axesImageOne); hold(Layout.axesImageOne, 'on'); axis(Layout.axesImageOne,'equal')
        imagesc(snapshots,'parent', Layout.axesImageTwo); hold(Layout.axesImageTwo, 'on'); axis(Layout.axesImageTwo,'equal')
        
        text(10,35,[filePD(aa).Exp(1),filePD(aa).Exp(2),'-r',num2str(bb),'-s',num2str(cc)],'FontWeight','bold','FontSize', 24, 'color','y','parent', Layout.axesImageTwo);
        %%-----------------------------------------------------------------
        sally = fieldnames(filePD);
        trigger = false;
        for i=1:length(sally)
            if strcmp(sally{i},'worms')==1
                trigger = true;
            end    
        end
        if trigger==true
        for i=1:length(filePD(aa).worms{bb}{cc}.worm_bc)
            hold on; plot(filePD(aa).worms{bb}{cc}.worm_bc{i}(:,2), filePD(aa).worms{bb}{cc}.worm_bc{i}(:,1), 'b', 'LineWidth', 1,'parent', Layout.axesImageTwo)
            text(mean(filePD(aa).worms{bb}{cc}.worm_bc{i}(:,2)),mean(filePD(aa).worms{bb}{cc}.worm_bc{i}(:,1)),num2str(i),'FontWeight','bold','FontSize', 14, 'color','r','parent', Layout.axesImageTwo);
            if ~isempty(ResultPD)
                    if     ResultPD.tagAreaBased{aa}{bb}{cc}{i}==1  &&  ResultPD.tagPeriBased{aa}{bb}{cc}{i}==1  &&  ResultPD.tagDimBased{aa}{bb}{cc}{i}==1
                         plot(filePD(aa).worms{bb}{cc}.WormMask_bc{i}(:,2), filePD(aa).worms{bb}{cc}.WormMask_bc{i}(:,1), 'r--', 'LineWidth', 2,'parent', Layout.axesImageTwo);
                    elseif ResultPD.tagAreaBased{aa}{bb}{cc}{i}==0  &&  ResultPD.tagPeriBased{aa}{bb}{cc}{i}==1
                         plot(filePD(aa).worms{bb}{cc}.WormMask_bc{i}(:,2), filePD(aa).worms{bb}{cc}.WormMask_bc{i}(:,1), 'c--', 'LineWidth', 2,'parent', Layout.axesImageTwo);
                    elseif ResultPD.tagAreaBased{aa}{bb}{cc}{i}==1  &&  ResultPD.tagPeriBased{aa}{bb}{cc}{i}==0
                         plot(filePD(aa).worms{bb}{cc}.WormMask_bc{i}(:,2), filePD(aa).worms{bb}{cc}.WormMask_bc{i}(:,1), 'y--', 'LineWidth', 2,'parent', Layout.axesImageTwo);
                    elseif ResultPD.tagAreaBased{aa}{bb}{cc}{i}==0  &&  ResultPD.tagPeriBased{aa}{bb}{cc}{i}==0
                        plot(filePD(aa).worms{bb}{cc}.WormMask_bc{i}(:,2), filePD(aa).worms{bb}{cc}.WormMask_bc{i}(:,1), 'm--', 'LineWidth', 2,'parent', Layout.axesImageTwo);
                    elseif ResultPD.tagDimBased{aa}{bb}{cc}{i}==0
                        plot(filePD(aa).worms{bb}{cc}.WormMask_bc{i}(:,2), filePD(aa).worms{bb}{cc}.WormMask_bc{i}(:,1), 'g--', 'LineWidth', 2,'parent', Layout.axesImageTwo);
                    end
            end
        end
        %%-----------------------------------------------------------------
        if ~isempty(filePD(aa).worms{bb}{cc}.worm_bc_trash) 
        for j=1:length(filePD(aa).worms{bb}{cc}.worm_bc_trash)
            if strcmp(filePD(aa).worms{bb}{cc}.worm_bc_trash_ID{j},'VeryThin')
                hold on; plot(filePD(aa).worms{bb}{cc}.worm_bc_trash{j}(:,2), filePD(aa).worms{bb}{cc}.worm_bc_trash{j}(:,1), 'r', 'LineWidth', 1,'parent', Layout.axesImageOne);
            elseif strcmp(filePD(aa).worms{bb}{cc}.worm_bc_trash_ID{j},'intersectMask')
                hold on; plot(filePD(aa).worms{bb}{cc}.worm_bc_trash{j}(:,2), filePD(aa).worms{bb}{cc}.worm_bc_trash{j}(:,1), 'g', 'LineWidth', 1,'parent', Layout.axesImageOne);
            elseif strcmp(filePD(aa).worms{bb}{cc}.worm_bc_trash_ID{j},'fewBCPoints')
                hold on; plot(filePD(aa).worms{bb}{cc}.worm_bc_trash{j}(:,2), filePD(aa).worms{bb}{cc}.worm_bc_trash{j}(:,1), 'r.', 'LineWidth', 3,'parent', Layout.axesImageOne);
            elseif strcmp(filePD(aa).worms{bb}{cc}.worm_bc_trash_ID{j},'SacrificeSmaller')
                hold on; plot(filePD(aa).worms{bb}{cc}.worm_bc_trash{j}(:,2), filePD(aa).worms{bb}{cc}.worm_bc_trash{j}(:,1), 'c', 'LineWidth', 1,'parent', Layout.axesImageOne);
            elseif strcmp(filePD(aa).worms{bb}{cc}.worm_bc_trash_ID{j},'jgdFiltered')
                hold on; plot(filePD(aa).worms{bb}{cc}.worm_bc_trash{j}(:,2), filePD(aa).worms{bb}{cc}.worm_bc_trash{j}(:,1), 'y', 'LineWidth', 1,'parent', Layout.axesImageOne);
            elseif strcmp(filePD(aa).worms{bb}{cc}.worm_bc_trash_ID{j},'DeleteOutofCircle')
                hold on; plot(filePD(aa).worms{bb}{cc}.worm_bc_trash{j}(:,2), filePD(aa).worms{bb}{cc}.worm_bc_trash{j}(:,1), 'm', 'LineWidth', 2,'parent', Layout.axesImageOne);
            elseif strcmp(filePD(aa).worms{bb}{cc}.worm_bc_trash_ID{j},'LowAreaMargin')
                hold on; plot(filePD(aa).worms{bb}{cc}.worm_bc_trash{j}(:,2), filePD(aa).worms{bb}{cc}.worm_bc_trash{j}(:,1), 'Color',[1 0.6 0] , 'LineWidth', 1,'parent', Layout.axesImageOne);
            elseif strcmp(filePD(aa).worms{bb}{cc}.worm_bc_trash_ID{j},'UpAreaMargin')
                hold on; plot(filePD(aa).worms{bb}{cc}.worm_bc_trash{j}(:,2), filePD(aa).worms{bb}{cc}.worm_bc_trash{j}(:,1), 'Color',[251 111 66]./ 255 , 'LineWidth', 1,'parent', Layout.axesImageOne);
                
            end
        end
        end
        %--------------------------------------------------------------------------
        cla(Layout.axesImageTen  , 'reset');
        if ~isempty(filePD(aa).worms{bb}{cc}.area_worm) 
            for iii = 1:length(filePD(aa).worms{bb}{cc}.area_worm)
                histArea(iii) = filePD(aa).worms{bb}{cc}.area_worm {iii}/info.worm_criteria;
            end
            histImage = histogram(histArea,'NumBins',10,'parent', Layout.axesImageTen,'LineWidth', 1.5, 'FaceColor','r'); 
            Layout.axesImageTen.XTickLabelRotation = 90;
            set(Layout.axesImageTen  , 'FontWeight','bold','FontSize',11, 'YLim', [0,1+max(histImage.Values)]);
            lowerWrmCritria          = str2double(info.lowerWrmCritria);
            upperWrmCritria          = str2double(info.upperWrmCritria );
            lowTick = 1:-0.3:lowerWrmCritria;
            highTick = 1:0.5:upperWrmCritria;
            Layout.axesImageTen.XTick = [flip(lowTick(2:end)),highTick];
            Layout.axesImageTen.TickDir = 'out';
            Layout.axesImageTen.TickLength = [0.02 0.05];
            Layout.axesImageTen.LineWidth  = 3;
            Layout.axesImageTen.XColor = [0,0,0];
            Layout.axesImageTen.YColor = [0,0,0];
        end
        %--------------------------------------------------------------------------
        end
        set(Layout.axesImageTwo  , 'XTick'   ,[],'YTick',[]);
        set(Layout.axesImageOne  , 'XTick'   ,[],'YTick',[]);  
end
end
end