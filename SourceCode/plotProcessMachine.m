function Layout = plotProcessMachine(Layout, info, filePD)
if ~isfield(filePD, 'my_imds')
if isfield(filePD(1).worms{1}{1}, 'WormCat')
    %% -------------------------------------------
    aa = info.ID2ind_list(info.CurrentProcessID,1);
    bb = info.ID2ind_list(info.CurrentProcessID,2);
    cc = info.ID2ind_list(info.CurrentProcessID,3);
    
    if        strcmp(info.format,'nd2')==1
        load(fullfile(pwd,[info.filename,'_nd2Folder'],[filePD(aa).Exp,'_','r',num2str(bb),'.mat']),'WellSnapshot');
    elseif    strcmp(info.format,'vid')==1
        load(fullfile(pwd,[info.filename,'_MOVfolder'],[filePD(aa).Exp,'_','r',num2str(bb),'.mat']),'WellSnapshot');
    end
    snapshots = WellSnapshot{cc};
    %---------------------------------------------   
    cla(Layout.axesImageOne,'reset'); imagesc(imadjust(snapshots),'parent', Layout.axesImageOne); hold(Layout.axesImageOne, 'on'); axis(Layout.axesImageOne,'equal');
    text(10,35,[filePD(aa).Exp(1),filePD(aa).Exp(2),'-r',num2str(bb),'-s',num2str(cc)],'FontWeight','bold','FontSize', 24, 'color','y','parent', Layout.axesImageOne);
    %---------------------------------------------
    S_AVGclassCat = filePD(aa).worms{bb}{cc}.WormCat;
    for WW=1:length(S_AVGclassCat)
        if     strcmp(S_AVGclassCat{WW},'Curled')        , colorStr{WW}='r';
        elseif strcmp(S_AVGclassCat{WW},'HalfCurled')    , colorStr{WW}='m';
        elseif strcmp(S_AVGclassCat{WW},'NearCurled')    , colorStr{WW}='g';
        elseif strcmp(S_AVGclassCat{WW},'Straight')      , colorStr{WW}='b';
        elseif strcmp(S_AVGclassCat{WW},'Censored')      , colorStr{WW}='y';
        end
    end
    %---------------------------------------------
    S_worm_bc = filePD(aa).worms{bb}{cc}.worm_bc;
    for WW=1:length(S_worm_bc)
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
        text(finalMinX,finalMinY,num2str(WW),'FontWeight','bold','FontSize', 14, 'color','r','parent', Layout.axesImageOne);

    end
    %---------------------------------------
    machinePicSize = info.UnitPicSizeML; 
    S_maskTileMatrix  = filePD(aa).worms{bb}{cc}.Worm_Mask;
    S_AVGscoreArray   = filePD(aa).worms{bb}{cc}.WormProb; 
    S_maskBoundingBox = filePD(aa).worms{bb}{cc}.W_BoundingBox;
    
    greyMachineSize   = [];
    
    for WW=1:length(S_maskTileMatrix)
        blobTile = imcrop(im2double(snapshots),S_maskBoundingBox{WW}); 
        refinedTile = imadjust(S_maskTileMatrix{WW}.*blobTile, stretchlim(blobTile(S_maskTileMatrix{WW})),[0.01,0.99]); 
        greyMachineSize{WW} = rescaleToMachineSize(machinePicSize, refinedTile);
    end
    %---------------------------------------
    
    if     length(greyMachineSize)<7,  mySZ=[3,2];  mFontSize = 10;
    elseif length(greyMachineSize)<13, mySZ=[4,3];  mFontSize = 9;
    elseif length(greyMachineSize)<21, mySZ=[5,4];  mFontSize = 8;
    elseif length(greyMachineSize)<31, mySZ=[6,5];  mFontSize = 7;
    elseif length(greyMachineSize)<43, mySZ=[7,6];  mFontSize = 6; end
    clear myMontage
    montageUnitLength = round(machinePicSize*mySZ(1)/mySZ(2));
    for WW=1:length(greyMachineSize)
        tmp22=zeros(machinePicSize,montageUnitLength);
        tmp22(:,1:machinePicSize)= greyMachineSize{WW};
        myMontage(:,:,:,WW) = tmp22;
    end
    if ~isempty(greyMachineSize)
        cla(Layout.axesImageTwo,'reset'); SMontage = montage(myMontage, 'Size',mySZ,'BorderSize',[1 1],'BackgroundColor',[0.5,0.5,0.5],'parent', Layout.axesImageTwo); hold(Layout.axesImageTwo, 'on');axis(Layout.axesImageTwo,'equal'); 
        scNumX = SMontage.XData(2)/montageUnitLength/mySZ(2);
        scNumY = SMontage.YData(2)/machinePicSize/mySZ(1);
    end
    for WW=1:length(greyMachineSize)
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
end
end
end