function  [Layout,info,filePD] = StartSnapMachine(caseID,RoundID,SnapID,Layout,info,filePD,neuralNet)
%% ------------------------------------------------------------------------
machinePicSize = info.UnitPicSizeML; 

mFolderName = strcat(num2str(caseID),'_',num2str(RoundID),'_',num2str(SnapID));
% mkdir(fullfile(pwd, 'PicList'),mFolderName);
% 
% mkdir(fullfile(pwd, 'PicList',mFolderName),'Curled');
% mkdir(fullfile(pwd, 'PicList',mFolderName),'HalfCurled');
% mkdir(fullfile(pwd, 'PicList',mFolderName),'NearCurled');
% mkdir(fullfile(pwd, 'PicList',mFolderName),'Straight');
% mkdir(fullfile(pwd, 'PicList',mFolderName),'Censored');

diskSizeArray = [5 10 15 20]; 
maxDetectLevelSnapShot   =3;
DetectlevelsSnap         = [false,...
                            true, false,...
                            true, false, false];  
maxDetectLevelTile       = 5;
DetectlevelsTile         = [true,...
                            true, true,...
                            true, true, false,...
                            true, true, false, false,...
                            true, true, false, false, false];
medFiltr                 = 0.01;
lowerWrmCritria          = str2double(info.lowerWrmCritria);
upperWrmCritria          = str2double(info.upperWrmCritria);

% winnerProbabilityCutOff = 50;
% differnceToCensor = 30;
%-------------------------------------------------------------------------- 
if        strcmp(info.format,'nd2')==1
    load(fullfile(pwd,[info.filename,'_nd2Folder'],[filePD(caseID).Exp,'_','r',num2str(RoundID),'.mat']),'WellSnapshot');
elseif    strcmp(info.format,'vid')==1
    load(fullfile(pwd,[info.filename,'_MOVfolder'],[filePD(caseID).Exp,'_','r',num2str(RoundID),'.mat']),'WellSnapshot');
end
%--------------------------------------------------------------------------
currentImage                = im2double(WellSnapshot{SnapID});
if strcmp(info.background,'White background'), currentImage_1 = imcomplement(currentImage);
elseif strcmp(info.background,'Black background'), currentImage_1 = currentImage; end
%--------------------------------------------------------------------------
 std_Image0  = stdfilt(medfilt2(currentImage_1,[floor(medFiltr*size(currentImage,2)),floor(medFiltr*size(currentImage,1))],'symmetric'));
 std_Image1  = imadjust(std_Image0,stretchlim(std_Image0,[0.01 0.99]));
 for i=1:maxDetectLevelSnapShot
     myThresh{i} = multithresh(std_Image1,i);
 end
 tmp = cell2mat(myThresh);
 wromThresh = tmp(DetectlevelsSnap);
 %-------------------------------------------------------------
 blobCounter=0;
 for i=1:length(wromThresh)
        slimBinary     = imbinarize(std_Image1,wromThresh(i));
        struc_Image    = bwconncomp(slimBinary,8);
        struc_area     = cellfun(@numel,struc_Image.PixelIdxList);
        idx            = find (  struc_area>(lowerWrmCritria*info.worm_criteria/2)  &  struc_area<(upperWrmCritria*info.worm_criteria*2)   );        
        for jj=1:length(idx)
            blobCounter = blobCounter+1;
            myBlobGradientList{blobCounter}= struc_Image.PixelIdxList{idx(jj)};
        end 
 end
%--------------------------------------------------------------------------  
%--------------------------------------------------------------------------  
maskBlank = logical(currentImage_1); 
maskBlank(:)= false;
blobMaskCounter = 0;
for myBlob = 1:length(myBlobGradientList)
        
        gradientSlimBlob = maskBlank;
        gradientSlimBlob(myBlobGradientList{myBlob})= true;
        blobStats = regionprops(gradientSlimBlob,'Area','Perimeter');
        hollowSlimBlob     = imcomplement(gradientSlimBlob);
        structHollow       = bwconncomp(hollowSlimBlob,8);
        hollowStats        = regionprops(structHollow,'Area','Perimeter');
        hollowPerimeter=0;
        for kk=1:length(hollowStats)
            if (hollowStats(kk).Perimeter < (3*blobStats.Perimeter))
                hollowPerimeter = hollowStats(kk).Perimeter + hollowPerimeter;
            end
        end
 
        for pp=1:length(diskSizeArray)
            blobMaskCounter = blobMaskCounter+1;
            gradientBlobDilatedMask{blobMaskCounter} = logical(imdilate(gradientSlimBlob,strel('disk',floor(diskSizeArray(pp)*(blobStats.Area)/(blobStats.Perimeter+hollowPerimeter)),4)));
            myGradientblob{blobMaskCounter} = gradientSlimBlob;
        end
end
%--------------------------------------------------------------------------  
%-------------------------------------------------------------------------- 
winnerIDs=[];
winCount =0;
for rr=1:length(gradientBlobDilatedMask)
     struc_maskBoundingBox = regionprops(gradientBlobDilatedMask{rr},'BoundingBox');
     maskTile = imcrop(gradientBlobDilatedMask{rr},struc_maskBoundingBox.BoundingBox); 
     blobTile = imcrop(currentImage_1,struc_maskBoundingBox.BoundingBox); 
     PixelID_of_gradientBlob = find(imcrop(myGradientblob{rr},struc_maskBoundingBox.BoundingBox));
     %-----------------------
     maskBoundingBox{rr} = struc_maskBoundingBox.BoundingBox;
     OriginalMaskTileMatrix{rr} = maskTile;
     %-----------------------
     clear threshListCell 
     for i=1:maxDetectLevelTile
         threshListCell{i} = multithresh(blobTile(find(maskTile==true)),i);
     end
     threshList = cell2mat(threshListCell); TileThreshList= threshList(DetectlevelsTile); 
     %-----------------------
     clear PixelID_of_notWorms
     mm=0; 
     for i=1:length(TileThreshList)
         slimBinary     = imbinarize(maskTile.*blobTile,TileThreshList(i));
         tmp0           = bwconncomp(slimBinary,8);
         [~,col,~] = find(    cellfun(@numel,tmp0.PixelIdxList)  >  (0.01*length(PixelID_of_gradientBlob))       );
         for kk=1:length(col)
             mm=mm+1;
             PixelID_of_notWorms{mm} = tmp0.PixelIdxList{col(kk)};
         end
     end
     %-----------------------
     for ee=1:length(PixelID_of_notWorms)
         if isempty(   intersect(PixelID_of_notWorms{ee},PixelID_of_gradientBlob)   )
             maskTile(PixelID_of_notWorms{ee}) = false;
         end
     end 
     maskTileMatrix{rr} = maskTile;
     refinedTile = imadjust(maskTile.*blobTile, stretchlim(blobTile(find(maskTile==true))),[0.01,0.99]); 
     greyScaleTile{rr}=refinedTile;
     %---------------------------------------------------------------------    
     tmp3 = rescaleToMachineSize(machinePicSize, refinedTile);
     greyMachineSize{rr}= im2uint8(tmp3);
     [ClassCat{rr}, myScoreArray]= classify(neuralNet, im2uint8(imresize(tmp3,[128 128])));
     scoreArray{rr}= round(myScoreArray*100);
     myNameText = strcat('\',num2str(rr),'_',num2str(scoreArray{rr}(1)),'_',num2str(scoreArray{rr}(2)),'_',num2str(scoreArray{rr}(3)),'_',num2str(scoreArray{rr}(4)),'_',num2str(scoreArray{rr}(5)));
%      imwrite(tmp3,strcat(fullfile(pwd,'PicList',mFolderName, char(ClassCat{rr})),myNameText,'.png'));   
     %--------------------------------------
     if (ClassCat{rr}~='Censored')   %&&     max(scoreArray{rr})>winnerProbabilityCutOff     &&   (max(scoreArray{rr})-scoreArray{rr}(1))>differnceToCensor  )
        winCount = winCount+1;
        winnerIDs(winCount) = rr;
     end
     %--------------------------------------
end
%--------------------------------------------------------------------------
winnerIDs2=[];
winnerIDs3=[];
myFinalWinnerList=[];
%-------------------------------------------- wormBob should not Touch mask
winCount=0;
for cc=1:length(winnerIDs)
    logicalWormTile{winnerIDs(cc)}= findBinaryWorm(greyScaleTile{winnerIDs(cc)},maskTileMatrix{winnerIDs(cc)});
    wormTilePixelList{winnerIDs(cc)} = find(logicalWormTile{winnerIDs(cc)}==true);
    OriginalMaskBoundaryNodes = find(bwperim(OriginalMaskTileMatrix{winnerIDs(cc)}));
    %if isempty(intersect(wormTilePixelList{winnerIDs(cc)},OriginalMaskBoundaryNodes)) 
            winCount=winCount+1;
            winnerIDs2(winCount)=winnerIDs(cc);  
    %end
end
%--------------------------------------------------------------------------
for dd=1:length(winnerIDs2)
    [PixelId_X,PixelId_Y]     = ind2sub(size(maskTileMatrix{winnerIDs2(dd)}),wormTilePixelList{winnerIDs2(dd)});
    PixelIdxyImageCoor{winnerIDs2(dd)}  = sub2ind(size(currentImage_1),(    PixelId_X+floor(maskBoundingBox{winnerIDs2(dd)}(2))  ),(   PixelId_Y+floor(maskBoundingBox{winnerIDs2(dd)}(1)))  ); 
end
%-------------------------------------------------------------------------- 
if get(Layout.Well, 'Value')==1
    
    [info, pixelOutOfWell] = findWellForMachine(info,currentImage_1);
    bCount=0;
    for BBB = 1:length(winnerIDs2)
        if isempty(intersect(PixelIdxyImageCoor{winnerIDs2(BBB)},pixelOutOfWell)) 
                bCount=bCount+1;
                winnerIDs3(bCount)=winnerIDs2(BBB);  
        end
    end
else
    winnerIDs3 = winnerIDs2;
end
%-------------------------------------------------------------------------- 
clear myFinalWinnerListProb probSumWinnerGroup
if ~isempty(winnerIDs3)
    countW=1;
    myFinalWinnerList(countW)=winnerIDs3(1);
    myFinalWinnerListProb(countW)=max(scoreArray{winnerIDs3(1)});
    probSumWinnerGroup(countW,:)=scoreArray{winnerIDs3(1)};
end
for wBB = 2:length(winnerIDs3)
    flagThisLoop=false;
    
     for jj = 1:length(myFinalWinnerList)
         
        if (length(intersect(PixelIdxyImageCoor{winnerIDs3(wBB)},PixelIdxyImageCoor{myFinalWinnerList(jj)}))   >  0.01*length(PixelIdxyImageCoor{myFinalWinnerList(jj)})   )
            flagThisLoop=true;
            probSumWinnerGroup(jj,:)= scoreArray{winnerIDs3(wBB)}+probSumWinnerGroup(jj,:);
            
                    %---------------------------------------- wBB is winner
                    ProbCandidate = max(scoreArray{winnerIDs3(wBB)}(2:5));
                    ProbOriginal = myFinalWinnerListProb(jj);
                    M_areaCand = bwarea(maskTileMatrix{winnerIDs3(wBB)});
                    M_areaOrig = bwarea(maskTileMatrix{myFinalWinnerList(jj)});
                    
                    if ProbCandidate >= ProbOriginal
                        
                        if (M_areaCand>M_areaOrig)||(ProbCandidate>ProbOriginal)
                            
                            myFinalWinnerList(jj)      = winnerIDs3(wBB);
                            myFinalWinnerListProb(jj)  = max(scoreArray{winnerIDs3(wBB)});
                        end
                        
                    end
                    %------------------------------------------------------
        end
     end
     if (flagThisLoop==false)
        countW=countW+1;
        myFinalWinnerList(countW)      = winnerIDs3(wBB);
        myFinalWinnerListProb(countW)  = max(scoreArray{winnerIDs3(wBB)});
        probSumWinnerGroup(countW,:)   = scoreArray{winnerIDs3(wBB)};
     end     
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
for Sworm=1:length(myFinalWinnerList)
    S_AVGscoreArray{Sworm}   = round(100*probSumWinnerGroup(Sworm,:)/sum(probSumWinnerGroup(Sworm,:)));
    [~,maxII] = max(S_AVGscoreArray{Sworm});
    if maxII==2, S_AVGclassCat{Sworm}='Curled'              ; elseif maxII==3, S_AVGclassCat{Sworm}='HalfCurled';
    elseif maxII==4, S_AVGclassCat{Sworm}='NearCurled'      ; elseif maxII==5, S_AVGclassCat{Sworm}='Straight'; 
    else S_AVGclassCat{Sworm}='Censored'; end
    
    tmpLocalBC{1}=[];
    if (strcmp(S_AVGclassCat{Sworm},'NearCurled'))  ||  (strcmp(S_AVGclassCat{Sworm},'Straight'))
       %mTTMP =splineOutlineOfWorms(logicalWormTile{myFinalWinnerList(Sworm)}, greyScaleTile{myFinalWinnerList(Sworm)});
       %tmpLocalBC{1}=flip(mTTMP,2);
    end
    if isempty(tmpLocalBC{1})
        tmpLocalBC = bwboundaries(logicalWormTile{myFinalWinnerList(Sworm)});
    end
    tmpPerimeter=0;
    clear tmpBigBC
    countThis = 0;
    for ik=1:length(tmpLocalBC)
        if (max(size(tmpLocalBC{ik}))>10)
                tmpPerimeter = tmpPerimeter + sum(sqrt(sum(diff(tmpLocalBC{ik}).^2,2)));
                tmpX = tmpLocalBC{ik}(:,1)+ maskBoundingBox{myFinalWinnerList(Sworm)}(2);
                tmpY = tmpLocalBC{ik}(:,2)+ maskBoundingBox{myFinalWinnerList(Sworm)}(1);
                countThis = countThis+1;
                tmpBigBC{countThis} = [tmpX,tmpY];
        end
    end
    
    S_wormPerimeter{Sworm}   = tmpPerimeter;
    S_worm_bc{Sworm}         = tmpBigBC;
    S_greyScaleTile{Sworm}   = greyScaleTile{myFinalWinnerList(Sworm)};
    S_maskBoundingBox{Sworm} = maskBoundingBox{myFinalWinnerList(Sworm)};
    S_maskTileMatrix{Sworm}  = maskTileMatrix{myFinalWinnerList(Sworm)};
    S_logicalWormTile{Sworm} = logicalWormTile{myFinalWinnerList(Sworm)};
    S_wormArea{Sworm}        = bwarea(logicalWormTile{myFinalWinnerList(Sworm)});
    S_greyMachineSize{Sworm} = greyMachineSize{myFinalWinnerList(Sworm)};
    
    
end
%-------------------------------------------------------------------------- 
%-------------------------------------------------------------------------- 
 if isempty(myFinalWinnerList)
    S_wormPerimeter={};     S_worm_bc={};    S_maskBoundingBox={}; S_maskTileMatrix={};  
    S_logicalWormTile={};   S_wormArea={};   S_AVGscoreArray={};   S_AVGclassCat={};
 end   
 filePD(caseID).worms{RoundID}{SnapID}.perimeter_worm    = S_wormPerimeter;
 filePD(caseID).worms{RoundID}{SnapID}.worm_bc           = S_worm_bc;
 filePD(caseID).worms{RoundID}{SnapID}.W_BoundingBox     = S_maskBoundingBox;
 filePD(caseID).worms{RoundID}{SnapID}.Worm_Mask         = S_maskTileMatrix;
 filePD(caseID).worms{RoundID}{SnapID}.wormBlob          = S_logicalWormTile;
 filePD(caseID).worms{RoundID}{SnapID}.area_worm         = S_wormArea;
 filePD(caseID).worms{RoundID}{SnapID}.WormProb          = S_AVGscoreArray;
 filePD(caseID).worms{RoundID}{SnapID}.WormCat           = S_AVGclassCat;

%-------------------------------------------------------------------------- 
%-------------------------------------------------------------------------- 
cla(Layout.axesImageOne,'reset'); imagesc(imadjust(currentImage),'parent', Layout.axesImageOne); hold(Layout.axesImageOne, 'on'); axis(Layout.axesImageOne,'equal');
%text(10,35,[filePD(caseID).Exp(1),filePD(caseID).Exp(2),'-r',num2str(RoundID),'-s',num2str(SnapID)],'FontWeight','bold','FontSize', 24, 'color','y','parent', Layout.axesImageOne);

for WW=1:length(myFinalWinnerList)
    if     strcmp(S_AVGclassCat{WW},'Curled')        , colorStr{WW}='r';
    elseif strcmp(S_AVGclassCat{WW},'HalfCurled')    , colorStr{WW}='m';
    elseif strcmp(S_AVGclassCat{WW},'NearCurled')    , colorStr{WW}='g';
    elseif strcmp(S_AVGclassCat{WW},'Straight')      , colorStr{WW}='b';
    elseif strcmp(S_AVGclassCat{WW},'Censored')      , colorStr{WW}='y';
    end
end
for WW=1:length(myFinalWinnerList)
    minX=[];
    minY=[];
    for jj=1:length(S_worm_bc{WW})
        hold on; plot(S_worm_bc{WW}{jj}(:,2),S_worm_bc{WW}{jj}(:,1),'Color',colorStr{WW}, 'LineWidth', 1,'parent', Layout.axesImageOne);
        
        [~, mIndex]=min(sqrt(S_worm_bc{WW}{jj}(:,2).^2)+sqrt(S_worm_bc{WW}{jj}(:,1).^2));
        minX(jj)=S_worm_bc{WW}{jj}(mIndex,2);
        minY(jj)=S_worm_bc{WW}{jj}(mIndex,1);
    end
    mOffset = 15;
    if ((min(minX)-mOffset)>mOffset), finalMinX=min(minX)-mOffset; else, finalMinX = min(minX); end
    if ((min(minY)-mOffset)>mOffset), finalMinY=min(minY)-mOffset; else, finalMinY = min(minY); end   
    text(finalMinX,finalMinY,num2str(WW),'FontWeight','bold','FontSize', 14, 'color','y','parent', Layout.axesImageOne);
    
end
%---------------------------------------
if     length(myFinalWinnerList)<7,  mySZ=[3,2];  mFontSize = 10;
elseif length(myFinalWinnerList)<13, mySZ=[4,3];  mFontSize = 9;
elseif length(myFinalWinnerList)<21, mySZ=[5,4];  mFontSize = 8;
elseif length(myFinalWinnerList)<31, mySZ=[6,5];  mFontSize = 7;
elseif length(myFinalWinnerList)<43, mySZ=[7,6];  mFontSize = 6; end
clear myMontage
montageUnitLength = round(machinePicSize*mySZ(1)/mySZ(2));
for WW=1:length(myFinalWinnerList)
    
    tmp22=im2uint8(zeros(machinePicSize,montageUnitLength));
    tmp22(:,1:machinePicSize)=S_greyMachineSize{WW};
    myMontage(:,:,:,WW) = tmp22;
end
if ~isempty(myFinalWinnerList)
    cla(Layout.axesImageTwo,'reset'); SMontage = montage(myMontage, 'Size',mySZ,'BorderSize',[1 1],'BackgroundColor',[0.5,0.5,0.5],'parent', Layout.axesImageTwo); hold(Layout.axesImageTwo, 'on');axis(Layout.axesImageTwo,'equal'); 
    scNumX = SMontage.XData(2)/montageUnitLength/mySZ(2);
    scNumY = SMontage.YData(2)/machinePicSize/mySZ(1);
end
for WW=1:length(myFinalWinnerList)
    [mRow,mCol] = ind2sub(flip(mySZ),WW);
    text( ((mRow-1)*montageUnitLength +0.10*machinePicSize)*scNumX, ((mCol-1)*machinePicSize+0.15*machinePicSize)*scNumY,num2str(WW),'FontWeight','bold','FontSize', mFontSize+6, 'color',colorStr{WW},'parent', Layout.axesImageTwo);
    
    text( ((mRow-1)*montageUnitLength +0.85*machinePicSize)*scNumX, ((mCol-1)*machinePicSize+40)*scNumY, ['Co = %'  ,num2str(S_AVGscoreArray{WW}(2))],'FontWeight','bold','FontSize', mFontSize, 'color','r','parent', Layout.axesImageTwo);
    text( ((mRow-1)*montageUnitLength +0.85*machinePicSize)*scNumX, ((mCol-1)*machinePicSize+80)*scNumY, ['Cu = %'  ,num2str(S_AVGscoreArray{WW}(3))],'FontWeight','bold','FontSize', mFontSize, 'color','m','parent', Layout.axesImageTwo);
    text( ((mRow-1)*montageUnitLength +0.85*machinePicSize)*scNumX, ((mCol-1)*machinePicSize+120)*scNumY,['Nc = %'  ,num2str(S_AVGscoreArray{WW}(4))],'FontWeight','bold','FontSize', mFontSize, 'color','g','parent', Layout.axesImageTwo);
    text( ((mRow-1)*montageUnitLength +0.85*machinePicSize)*scNumX, ((mCol-1)*machinePicSize+160)*scNumY,['St = %'  ,num2str(S_AVGscoreArray{WW}(5))],'FontWeight','bold','FontSize', mFontSize, 'color','b','parent', Layout.axesImageTwo);
    text( ((mRow-1)*montageUnitLength +0.85*machinePicSize)*scNumX, ((mCol-1)*machinePicSize+200)*scNumY,['Ce = %'  ,num2str(S_AVGscoreArray{WW}(1))],'FontWeight','bold','FontSize', mFontSize, 'color','y','parent', Layout.axesImageTwo);
end
set(Layout.axesImageTwo  , 'XTick'   ,[],'YTick',[]);
set(Layout.axesImageOne  , 'XTick'   ,[],'YTick',[]);
%-------------------------------------------------------------------------- 
%-------------------------------------------------------------------------- 
end
 
 
 function [info, PixelIdxyListWell] = findWellForMachine(info,currentImage_1)
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
    PixelIdxyListWell            = find(zoneOkForCompleteWorms==false);
 end


 
 
 

 
 
 
 
 
 
 
 
 