

%--------------------------------------------------------------------------
cla(axesImageOne,'reset'); imagesc(currentImage,'parent', axesImageOne); hold(axesImageOne, 'on'); axis(axesImageOne,'equal');
cla(axesImageTwo,'reset'); imagesc(currentImage,'parent', axesImageTwo); hold(axesImageTwo, 'on');axis(axesImageTwo,'equal');

text(10,35,[filePD(caseID).Exp(1),filePD(caseID).Exp(2),'-r',num2str(RoundID),'-s',num2str(SnapID)],'FontWeight','bold','FontSize', 24, 'color','y','parent', axesImageTwo);
WormMask_bc{1}=[];
for i=1:length(Worm_Bc)
    hold on; plot(Worm_Bc{i}(:,2), Worm_Bc{i}(:,1), 'b', 'LineWidth', 1,'parent', axesImageTwo)
    text(mean(Worm_Bc{i}(:,2)),mean(Worm_Bc{i}(:,1)),num2str(i),'FontWeight','bold','FontSize', 14, 'color','r','parent', axesImageTwo);
    clear B, B= bwboundaries(Worm_MaskOrig{i},'noholes');plot(B{1}(:,2), B{1}(:,1), 'y--', 'LineWidth', 0.5,'parent', axesImageTwo)
    WormMask_bc{i} = B{1};
end
if ~isempty(Worm_Bc_Trash) 
for j=1:length(Worm_Bc_Trash)
    if     strcmp(Worm_Bc_Trash_ID{j},'VeryThin')
        hold on; plot(Worm_Bc_Trash{j}(:,2), Worm_Bc_Trash{j}(:,1), 'r', 'LineWidth', 1,'parent', axesImageOne);
    elseif strcmp(Worm_Bc_Trash_ID{j},'intersectMask')
        hold on; plot(Worm_Bc_Trash{j}(:,2), Worm_Bc_Trash{j}(:,1), 'g', 'LineWidth', 1,'parent', axesImageOne);
    elseif strcmp(Worm_Bc_Trash_ID{j},'fewBCPoints')
        hold on; plot(Worm_Bc_Trash{j}(:,2), Worm_Bc_Trash{j}(:,1), 'r.', 'LineWidth', 3,'parent', axesImageOne);
    elseif strcmp(Worm_Bc_Trash_ID{j},'SacrificeSmaller')
        hold on; plot(Worm_Bc_Trash{j}(:,2), Worm_Bc_Trash{j}(:,1), 'c', 'LineWidth', 1,'parent', axesImageOne);
    elseif strcmp(Worm_Bc_Trash_ID{j},'jgdFiltered')
        hold on; plot(Worm_Bc_Trash{j}(:,2), Worm_Bc_Trash{j}(:,1), 'y', 'LineWidth', 1,'parent', axesImageOne);
    elseif strcmp(Worm_Bc_Trash_ID{j},'DeleteOutofCircle')
        hold on; plot(Worm_Bc_Trash{j}(:,2), Worm_Bc_Trash{j}(:,1), 'm', 'LineWidth', 2,'parent', axesImageOne);
    elseif strcmp(Worm_Bc_Trash_ID{j},'LowAreaMargin')
        hold on; plot(Worm_Bc_Trash{j}(:,2), Worm_Bc_Trash{j}(:,1),'Color',[1 0.6 0],   'LineWidth', 3,'parent', axesImageOne);
    elseif strcmp(Worm_Bc_Trash_ID{j},'UpAreaMargin')
        hold on; plot(Worm_Bc_Trash{j}(:,2), Worm_Bc_Trash{j}(:,1),'Color',[251 111 66]./ 255, 'LineWidth', 3,'parent', axesImageOne);
    end
    if get(info.Well{1}, 'Value')==1, if ~isempty(info.Well{2})
        plot(info.Well{3} + info.Well{2}*cos(2*pi*(0:200)/200), info.Well{4}+ info.Well{2}*sin(2*pi*(0:200)/200), '.r', 'linewidth', 1,'parent', axesImageTwo);
    end; end
end
end

%--------------------------------------------------------------------------  
set(axesImageTwo  , 'XTick'   ,[],'YTick',[]);
set(axesImageOne  , 'XTick'   ,[],'YTick',[]);
cla(axesImageTen  , 'reset');