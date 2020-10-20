function [Layout,filePD] = Segment_Image(caseID,RoundID, SnapID, Layout, info, filePD)
%--------------------------------------accessing default process parameters
lowerWrmCritria          = str2double(info.lowerWrmCritria);
upperWrmCritria          = str2double(info.upperWrmCritria);
multiplyAreaMaskOrig     = str2double(info.multiplyAreaMask);
detectLevelCoarse        = str2double(info.detectLevelCoarse);
LevelCoarseWhich         = str2double(info.LevelCoarseWhich);
Point_rep_worm           = str2double(info.WormNumNode);
jgd_criteria             = str2double(info.jgd_criteria);
medFiltr                 = 0.01;
filterLowDimInitial      = 0.01;
WormAreaOverLap          = 0.1;
maxDetectLevelFine       = 4;
DetectFineLeveling       = [true,...
                            true, false,...
                            true, true, false,...
                            true, true, false, false];
%-------------------------------------------------------------------------- 
filepath = pwd;
if        strcmp(info.format,'nd2')==1
    load(fullfile(filepath,[info.filename,'_nd2Folder'],[filePD(caseID).Exp,'_','r',num2str(RoundID),'.mat']),'WellSnapshot');
elseif    strcmp(info.format,'vid')==1
    load(fullfile(filepath,[info.filename,'_MOVfolder'],[filePD(caseID).Exp,'_','r',num2str(RoundID),'.mat']),'WellSnapshot');
end
%--------------------------------------------------------------------------
tmpImage                 = im2double(WellSnapshot{SnapID});
currentImage             = tmpImage;
imHeight                 = size(currentImage,1);
imWidth                  = size(currentImage,2);   
%--------------------------------------------------------------------------
if strcmp(info.background,'White background')
    currentImage_1       = imcomplement(currentImage);
elseif strcmp(info.background,'Black background')
    currentImage_1       = currentImage;
end
%--------------------------------------------------------------------------
zoneOkForCompleteWorms  =[];
if get(Layout.Well, 'Value')==1
    [info, zoneOkForCompleteWorms, zoneOkForCompleteWorms_small, PixelIdxyListWell] = findWellifPossible(info,currentImage_1);
end
%--------------------------------------------------------------------------
std_Image0              = stdfilt(medfilt2(currentImage_1,[floor(medFiltr*imWidth)   floor(medFiltr*imHeight)],'symmetric'));
std_Image1              = imadjust(std_Image0,stretchlim(std_Image0,[0.01 0.99]));
if get(Layout.Well,'Value')==1, std_Image2 = std_Image1.*zoneOkForCompleteWorms_small; else, std_Image2 = std_Image1; end
thresh                  = multithresh(std_Image2 ,detectLevelCoarse);
filled_Image            = imbinarize(std_Image2,thresh(LevelCoarseWhich));
%--------------------------------------------------------------------------  
struc_Image             = bwconncomp(filled_Image,8);
struc_area              = cellfun(@numel,struc_Image.PixelIdxList);
idx                     = find (  struc_area>(lowerWrmCritria*info.worm_criteria/2)  &  struc_area<(upperWrmCritria*info.worm_criteria*2)   );
idx2                    = find (  struc_area>(lowerWrmCritria*info.worm_criteria)  &  struc_area<(upperWrmCritria*info.worm_criteria)   );
minAreaRatio1           = min(struc_area(idx2))/info.worm_criteria;
maxAreaRatio1           = max(struc_area(idx2))/info.worm_criteria;
%--------------------------------------------------------------------------  
%--------------------------------------------------------------------------  
%--------------------------------------------------------------------------  
%-------------------------------------------------------------------------- 
if ~isempty(idx) 
for worm = 1:length(idx)
tag_CircleIssue      = true;
tag_BiggerThanCircle = false;
while tag_CircleIssue == true
             tag_CircleIssue      = false;
             tmp = zeros(size(currentImage_1));                               %#ok<*AGROW>
             tmp(struc_Image.PixelIdxList{idx(worm)}) =1;
             StatsPreFillHole      = regionprops(tmp,'Area');
             wormCandidate         = imfill(tmp,'holes');
             wormStats             = regionprops(wormCandidate,'Area','Perimeter');
             if (4*pi*StatsPreFillHole.Area/(wormStats.Perimeter^2))<filterLowDimInitial && isempty(zoneOkForCompleteWorms), worm_bc_trash_ID{worm} = 'VeryThin';tmpii = bwboundaries(wormCandidate); worm_bc_trash{worm}=tmpii{1}; worm_bc{worm}=[]; dimensionless{worm}=[]; perimeter_worm{worm}=[]; area_worm{worm}=[]; PixelIdxyImageCoor{worm}=[]; wormMaskOrig{worm}=[]; BoundingBox{worm}=[]; wormMaskCrpd{worm}=[]; break; end
             if StatsPreFillHole.Area<lowerWrmCritria*info.worm_criteria, worm_bc_trash_ID{worm} = 'LowAreaMargin';tmpii = bwboundaries(wormCandidate); worm_bc_trash{worm}=tmpii{1}; worm_bc{worm}=[]; dimensionless{worm}=[]; perimeter_worm{worm}=[]; area_worm{worm}=[]; PixelIdxyImageCoor{worm}=[]; wormMaskOrig{worm}=[];BoundingBox{worm}=[]; wormMaskCrpd{worm}=[]; break; end
             if StatsPreFillHole.Area>upperWrmCritria*info.worm_criteria, worm_bc_trash_ID{worm} = 'UpAreaMargin';tmpii = bwboundaries(wormCandidate); worm_bc_trash{worm}=tmpii{1}; worm_bc{worm}=[]; dimensionless{worm}=[]; perimeter_worm{worm}=[]; area_worm{worm}=[]; PixelIdxyImageCoor{worm}=[]; wormMaskOrig{worm}=[];BoundingBox{worm}=[]; wormMaskCrpd{worm}=[]; break; end
             if (wormStats.Area/StatsPreFillHole.Area)>1.1, multiplyAreaMask = 3; else, multiplyAreaMask = multiplyAreaMaskOrig;  end
             wormMaskOrig{worm}    = logical(imdilate(wormCandidate,strel('disk',floor(multiplyAreaMask*StatsPreFillHole.Area/wormStats.Perimeter),4)));
             if tag_BiggerThanCircle == true, wormMaskOrig{worm} = wormMaskOrig{worm}.*zoneOkForCompleteWorms_small; if ~any(wormMaskOrig{worm}(:)), worm_bc_trash_ID{worm} = 'DeleteOutofCircle';tmpii = bwboundaries(wormCandidate); worm_bc_trash{worm}=tmpii{1}; worm_bc{worm}=[]; dimensionless{worm}=[]; perimeter_worm{worm}=[]; area_worm{worm}=[]; PixelIdxyImageCoor{worm}=[]; wormMaskOrig{worm}=[]; BoundingBox{worm}=[]; wormMaskCrpd{worm}=[]; break; end; end
             currentImageA         = currentImage_1  -  0.9*regionfill(currentImage_1,wormMaskOrig{worm});
             currentImageA         = currentImageA -  min(currentImageA(:));
             ImageProp             = regionprops(wormMaskOrig{worm},'BoundingBox');
             BoundingBox{worm}     = ImageProp.BoundingBox;
             wormTile{worm}        = imcrop(currentImageA,BoundingBox{worm});
             wormMaskCrpd{worm}    = imcrop(wormMaskOrig{worm},BoundingBox{worm});
             perimIDMask           = find(bwperim(wormMaskCrpd{worm})==1);
             %-------------------------------------------------------------
             for i=1:maxDetectLevelFine
                 tmpThresh{i} = multithresh(wormTile{worm}(find(wormMaskCrpd{worm}==1)),i);
             end
             tmp = cell2mat(tmpThresh);
             wromThresh = sort(tmp(DetectFineLeveling),'ascend');
             %-------------------------------------------------------------
             clear WormBC  AreaWorm  PerimeterWorm  jgd_worm  DimLess
             for i=1:length(wromThresh)
                            slimBinary     = imfill( imbinarize(wormMaskCrpd{worm}.*wormTile{worm},wromThresh(i)), 'holes');
                            tmp0           = bwconncomp(slimBinary,8);
                            [~, id]        = max(cellfun(@numel,tmp0.PixelIdxList)); 
                            PixelIdxyListInWormCoor{i} =     tmp0.PixelIdxList{id};
                            tmp1           = zeros(size(wormTile{worm}));                            
                            tmp1(PixelIdxyListInWormCoor{i}) = 1;
                            perimIDSlim{i} = find(bwperim(tmp1)==1);
                            if ~isempty(intersect(perimIDMask,perimIDSlim{i})) && tag_BiggerThanCircle==false, jgd_worm(i)=5; continue; end
                            tmp2         = bwboundaries(tmp1);
                            WormBC{i}    = tmp2{1};
                            AreaWorm{i}  = length(PixelIdxyListInWormCoor{i});      
                            %%---------------------------------------------
                            listPoint    = WormBC{i}(1:end-1,:);
                            lngth        = length(listPoint);
                            smoothLevel  = floor(lngth/Point_rep_worm);
                            if smoothLevel<2, jgd_worm(i)=4; continue; end
                            [WormBCSmooth] = CSTSmooth_Parkinson(listPoint, lngth, smoothLevel);
                             %%--------------------------------------------
                             PerimeterWorm{i}       = sum(sqrt(sum(diff(WormBC{i}).^2,2)));
                             PerimeterWormSmooth    = sum(sqrt(sum(diff(WormBCSmooth).^2,2)));
                             jgd_worm(i)            = PerimeterWorm{i}/PerimeterWormSmooth;
                             DimLess{i}             = 4*pi*AreaWorm{i}/((PerimeterWorm{i} ^2));
             end
             %------------------------------------------------------------- 
             logical_jgd   = (jgd_worm<jgd_criteria);
             if any(logical_jgd)
                 
                 if tag_BiggerThanCircle==false
                    [~, idw]                  = min(logical_jgd.*wromThresh + (~logical_jgd).*1);
                    localWorm_bc{worm}        = WormBC{idw};
                    dimensionless{worm}       = DimLess{idw};
                    perimeter_worm{worm}      = PerimeterWorm{idw};
                    area_worm{worm}           = AreaWorm{idw};
                    [PixelId_X,PixelId_Y]     = ind2sub(size(wormMaskCrpd{worm}),PixelIdxyListInWormCoor{idw} );
                    PixelIdxyImageCoor{worm}  = sub2ind(size(currentImage_1) , (PixelId_X+floor(BoundingBox{worm}(2))),(PixelId_Y+floor(BoundingBox{worm}(1)))  ); 
                    localWorm_bc_trash{worm}  = [];
                    worm_bc_trash_ID{worm}    = [];
                 else
                     %-----------------------------------------------------
                     for q=1:length(AreaWorm),lngth_Q(q) = AreaWorm{q};end; [~, idwx] = min(logical_jgd.*lngth_Q+(~logical_jgd).*max(lngth_Q));
                     if  (length(intersect(perimIDMask,perimIDSlim{idwx}))>(0.25*length(perimIDMask))), worm_bc_trash_ID{worm} = 'DeleteOutofCircle'; worm_bc_trash{worm} = [WormBC{idwx}(:,1),WormBC{idwx}(:,2)]; localWorm_bc{worm}=[]; dimensionless{worm}=[]; perimeter_worm{worm}=[]; area_worm{worm}=[]; PixelIdxyImageCoor{worm}=[]; wormMaskOrig{worm}=[];
                     else,localWorm_bc{worm}=WormBC{idwx}; dimensionless{worm}=DimLess{idwx};perimeter_worm{worm}=PerimeterWorm{idwx};area_worm{worm}=AreaWorm{idwx};[PixelId_X,PixelId_Y]=ind2sub(size(wormMaskCrpd{worm}),PixelIdxyListInWormCoor{idwx});PixelIdxyImageCoor{worm}=sub2ind(size(currentImage_1),(PixelId_X+floor(BoundingBox{worm}(2))),(PixelId_Y+floor(BoundingBox{worm}(1))));localWorm_bc_trash{worm}=[];worm_bc_trash_ID{worm}=[];end
                     %-----------------------------------------------------
                 end
             else
                 [value,idq] = min(jgd_worm);
                 localWorm_bc{worm}=[]; dimensionless{worm}=[]; perimeter_worm{worm}=[]; area_worm{worm}=[]; PixelIdxyImageCoor{worm}=[]; wormMaskOrig{worm}=[];
                 if value == 5
                     worm_bc_trash_ID{worm} = 'intersectMask';tmpii = bwboundaries(wormMaskCrpd{worm}); localWorm_bc_trash{worm}=tmpii{1};
                     if ~isempty(zoneOkForCompleteWorms),[PixelId_X,PixelId_Y]=ind2sub(size(wormMaskCrpd{worm}),PixelIdxyListInWormCoor{idq});PixelIdxyImageCoor{worm}=sub2ind(size(currentImage_1),(PixelId_X+floor(BoundingBox{worm}(2))),(PixelId_Y+floor(BoundingBox{worm}(1))));end
                 elseif value == 4
                     worm_bc_trash_ID{worm} = 'fewBCPoints';localWorm_bc_trash{worm}= WormBC{idq};
                 else
                     worm_bc_trash_ID{worm} = 'jgdFiltered';localWorm_bc_trash{worm}= WormBC{idq};
                 end
             end
             %-------------------------------------------------------------   
             if ~isempty(localWorm_bc{worm})
                 tmpX = localWorm_bc{worm}(:,1)+ BoundingBox{worm}(2)-0.5;
                 tmpY = localWorm_bc{worm}(:,2)+ BoundingBox{worm}(1)-0.5;
                 worm_bc{worm} = [tmpX,tmpY];
             else
                 worm_bc{worm}  = [];
             end 
             if ~isempty(localWorm_bc_trash{worm})
                 tmpX = localWorm_bc_trash{worm}(:,1)+ BoundingBox{worm}(2)-0.5;
                 tmpY = localWorm_bc_trash{worm}(:,2)+ BoundingBox{worm}(1)-0.5;
                 worm_bc_trash{worm} = [tmpX,tmpY];
             else
                 worm_bc_trash{worm} = [];
             end
        %------------------------------------------------------------------
        if worm~=1
        if ~isempty(worm_bc{worm})
        for jj = (worm-1):-1:1
        if ~isempty(worm_bc{jj})
            max(length(PixelIdxyImageCoor{worm}),length(PixelIdxyImageCoor{jj}));
            intersectNum = length(intersect(PixelIdxyImageCoor{worm},PixelIdxyImageCoor{jj}));
                    if  intersectNum>(WormAreaOverLap*max(length(PixelIdxyImageCoor{worm}),length(PixelIdxyImageCoor{jj})))
                        %--------------------------------------------------
                        if  length(PixelIdxyImageCoor{jj})<length(PixelIdxyImageCoor{worm})
                             worm_bc_trash{jj}       = worm_bc{jj};
                             worm_bc_trash_ID{jj}    = 'SacrificeSmaller';
                             worm_bc{jj}             = [];
                             dimensionless{jj}       = [];
                             perimeter_worm{jj}      = [];
                             area_worm{jj}           = [];
                             PixelIdxyImageCoor{jj}  = [];
                             wormMaskOrig{jj}        = [];
                             wormMaskCrpd{jj}        = [];
                             BoundingBox{jj}         = [];
                        %--------------------------------------------------
                        elseif length(PixelIdxyImageCoor{worm})<=length(PixelIdxyImageCoor{jj})
                             worm_bc_trash{worm}       = worm_bc{worm};
                             worm_bc_trash_ID{worm}    = 'SacrificeSmaller';
                             worm_bc{worm}             = [];
                             dimensionless{worm}       = [];
                             perimeter_worm{worm}      = [];
                             area_worm{worm}           = [];
                             PixelIdxyImageCoor{worm}  = [];
                             wormMaskOrig{worm}        = [];
                             wormMaskCrpd{worm}        = [];
                             BoundingBox{worm}         = [];
                        end
                    end
        end
        end
        end
        end
        %------------------------------------------------------------------   
        if ~isempty(zoneOkForCompleteWorms)
            if ~isempty(worm_bc{worm}) ||  strcmp(worm_bc_trash_ID{worm},'intersectMask')
            if ~isempty(intersect(PixelIdxyListWell,PixelIdxyImageCoor{worm}))    &&    tag_BiggerThanCircle==false
                tag_CircleIssue       = true;
                tag_BiggerThanCircle  = true;
            end
            end
        end
        %------------------------------------------------------------------        
end 
end
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
LogicalWormID      = ~cellfun('isempty',worm_bc);
Perimeter_Worm     = perimeter_worm(LogicalWormID);
Dimensionless      = dimensionless(LogicalWormID);
Worm_Bc            = worm_bc(LogicalWormID);
Area_Worm          = area_worm(LogicalWormID);
Worm_MaskOrig      = wormMaskOrig(LogicalWormID);
Worm_Mask          = wormMaskCrpd(LogicalWormID);
W_BoundingBox      = BoundingBox(LogicalWormID);
Worm_Bc_Trash      = worm_bc_trash(~cellfun('isempty',worm_bc_trash)); 
Worm_Bc_Trash_ID   = worm_bc_trash_ID(~cellfun('isempty',worm_bc_trash));
%--------------------------------------------------------------------------
cla(Layout.axesImageOne,'reset'); imagesc(currentImage,'parent', Layout.axesImageOne); hold(Layout.axesImageOne, 'on'); axis(Layout.axesImageOne,'equal');
cla(Layout.axesImageTwo,'reset'); imagesc(currentImage,'parent', Layout.axesImageTwo); hold(Layout.axesImageTwo, 'on');axis(Layout.axesImageTwo,'equal');

text(10,35,[filePD(caseID).Exp(1),filePD(caseID).Exp(2),'-r',num2str(RoundID),'-s',num2str(SnapID)],'FontWeight','bold','FontSize', 24, 'color','y','parent', Layout.axesImageTwo);
WormMask_bc{1}=[];
for i=1:length(Worm_Bc)
    hold on; plot(Worm_Bc{i}(:,2), Worm_Bc{i}(:,1), 'b', 'LineWidth', 1,'parent', Layout.axesImageTwo)
    text(mean(Worm_Bc{i}(:,2)),mean(Worm_Bc{i}(:,1)),num2str(i),'FontWeight','bold','FontSize', 14, 'color','r','parent', Layout.axesImageTwo);
    clear B, B= bwboundaries(Worm_MaskOrig{i},'noholes');plot(B{1}(:,2), B{1}(:,1), 'y--', 'LineWidth', 0.5,'parent', Layout.axesImageTwo)
    WormMask_bc{i} = B{1};
end
if ~isempty(Worm_Bc_Trash) 
for j=1:length(Worm_Bc_Trash)
    if     strcmp(Worm_Bc_Trash_ID{j},'VeryThin')
        hold on; plot(Worm_Bc_Trash{j}(:,2), Worm_Bc_Trash{j}(:,1), 'r', 'LineWidth', 1,'parent', Layout.axesImageOne);
    elseif strcmp(Worm_Bc_Trash_ID{j},'intersectMask')
        hold on; plot(Worm_Bc_Trash{j}(:,2), Worm_Bc_Trash{j}(:,1), 'g', 'LineWidth', 1,'parent', Layout.axesImageOne);
    elseif strcmp(Worm_Bc_Trash_ID{j},'fewBCPoints')
        hold on; plot(Worm_Bc_Trash{j}(:,2), Worm_Bc_Trash{j}(:,1), 'r.', 'LineWidth', 3,'parent', Layout.axesImageOne);
    elseif strcmp(Worm_Bc_Trash_ID{j},'SacrificeSmaller')
        hold on; plot(Worm_Bc_Trash{j}(:,2), Worm_Bc_Trash{j}(:,1), 'c', 'LineWidth', 1,'parent', Layout.axesImageOne);
    elseif strcmp(Worm_Bc_Trash_ID{j},'jgdFiltered')
        hold on; plot(Worm_Bc_Trash{j}(:,2), Worm_Bc_Trash{j}(:,1), 'y', 'LineWidth', 1,'parent', Layout.axesImageOne);
    elseif strcmp(Worm_Bc_Trash_ID{j},'DeleteOutofCircle')
        hold on; plot(Worm_Bc_Trash{j}(:,2), Worm_Bc_Trash{j}(:,1), 'm', 'LineWidth', 2,'parent', Layout.axesImageOne);
    elseif strcmp(Worm_Bc_Trash_ID{j},'LowAreaMargin')
        hold on; plot(Worm_Bc_Trash{j}(:,2), Worm_Bc_Trash{j}(:,1),'Color',[1 0.6 0],   'LineWidth', 3,'parent', Layout.axesImageOne);
    elseif strcmp(Worm_Bc_Trash_ID{j},'UpAreaMargin')
        hold on; plot(Worm_Bc_Trash{j}(:,2), Worm_Bc_Trash{j}(:,1),'Color',[251 111 66]./ 255, 'LineWidth', 3,'parent', Layout.axesImageOne);
    end
    if get(Layout.Well, 'Value')==1, if ~isempty(info.Well{2})
        plot(info.Well{3} + info.Well{2}*cos(2*pi*(0:200)/200), info.Well{4}+ info.Well{2}*sin(2*pi*(0:200)/200), '.r', 'linewidth', 1,'parent', Layout.axesImageTwo);
    end; end
end
end
%--------------------------------------------------------------------------  
set(Layout.axesImageTwo  , 'XTick'   ,[],'YTick',[]);
set(Layout.axesImageOne  , 'XTick'   ,[],'YTick',[]);
cla(Layout.axesImageTen  , 'reset');
%--------------------------------------------------------------------------  
if ~isempty(Area_Worm)
    for iii = 1:length(Area_Worm)
        histArea(iii) = Area_Worm{iii}/info.worm_criteria;
    end
    histImage = histogram(histArea,'NumBins',10,'parent', Layout.axesImageTen,'LineWidth', 1.5, 'FaceColor','r'); 
    Layout.axesImageTen.XTickLabelRotation = 90;
    set(Layout.axesImageTen  , 'FontWeight','bold','FontSize',11, 'YLim', [0,1+max(histImage.Values)]);
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
%--------------------------------------------------------------------------  
 filePD(caseID).worms{RoundID}{SnapID}.minAreaRatio1       = minAreaRatio1;
 filePD(caseID).worms{RoundID}{SnapID}.maxAreaRatio1       = maxAreaRatio1;
 filePD(caseID).worms{RoundID}{SnapID}.perimeter_worm      = Perimeter_Worm;
 filePD(caseID).worms{RoundID}{SnapID}.dimensionless       = Dimensionless;
 filePD(caseID).worms{RoundID}{SnapID}.worm_bc             = Worm_Bc;
 filePD(caseID).worms{RoundID}{SnapID}.area_worm           = Area_Worm;
 filePD(caseID).worms{RoundID}{SnapID}.worm_bc_trash       = Worm_Bc_Trash;
 filePD(caseID).worms{RoundID}{SnapID}.worm_bc_trash_ID    = Worm_Bc_Trash_ID;
 filePD(caseID).worms{RoundID}{SnapID}.W_BoundingBox       = W_BoundingBox;
 filePD(caseID).worms{RoundID}{SnapID}.WormMask_bc         = WormMask_bc;
 filePD(caseID).worms{RoundID}{SnapID}.Worm_Mask           = Worm_Mask;
end


function [info,zoneOkForCompleteWorms, zoneOkForCompleteWorms_small, PixelIdxyListWell] = findWellifPossible(info,currentImage_1)
    if ~isempty(info.Well{2})
                tmpRadii = []; CircSensitivity = 0.95;
                while isempty(tmpRadii)  && CircSensitivity<1
                        [tmpCenters,tmpRadii] = imfindcircles(currentImage_1, floor([0.9,1.1]*info.Well{2})   ,'ObjectPolarity','dark','Sensitivity',CircSensitivity);
                        CircSensitivity = CircSensitivity + 0.01;
                end  
                if ~isempty(tmpRadii)  &&  tmpCenters(1,1)>0.8*info.Well{3}  &&  tmpCenters(1,1)<1.2*info.Well{3}   &&  tmpCenters(1,2)>0.8*info.Well{4}  &&  tmpCenters(1,2)<1.2*info.Well{4}
                    info.Well{2}   = tmpRadii(1)*0.98;
                    info.Well{3}   = tmpCenters(1,1);
                    info.Well{4}   = tmpCenters(1,2);
                end
    end
    imHeight                     = size(currentImage_1,1);
    imWidth                      = size(currentImage_1,2);   
    zoneOkForCompleteWorms       = (  repmat((1-info.Well{3}:imWidth-info.Well{3}).^2,imHeight,1) + repmat((1-info.Well{4}:imHeight-info.Well{4})'.^2, 1, imWidth) <= (info.Well{2}).^2 );   
    zoneOkForCompleteWorms_small = (  repmat((1-info.Well{3}:imWidth-info.Well{3}).^2,imHeight,1) + repmat((1-info.Well{4}:imHeight-info.Well{4})'.^2, 1, imWidth) <= (info.Well{2}-5).^2 );   
    PixelIdxyListWell            = find(zoneOkForCompleteWorms_small==0);
end
