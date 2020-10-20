function saveSegmented_snapTiles(Layout, info, filePD, ResultPD)
if isfield(ResultPD,'CurlCrit')
%% ------------------------------------------------------------------------
     machinePicSize=2*128;
     mHeadFolder = fullfile(pwd, 'savedBlobsSegmented'); 
     if ~exist(mHeadFolder, 'dir'),mkdir(mHeadFolder);end
     %%--------------------------------------------------------------------
     for aa = 1:length(filePD)
     set(Layout.command_line,'string',['>> SavingTiles #',num2str(aa),'/',num2str(length(filePD))]);drawnow; 
     for bb = 1:length(filePD(aa).worms)
         if        strcmp(info.format,'nd2')==1
             load(fullfile(pwd,[info.filename,'_nd2Folder'],[filePD(aa).Exp,'_','r',num2str(bb),'.mat']),'WellSnapshot');
         elseif    strcmp(info.format,'vid')==1
             load(fullfile(pwd,[info.filename,'_MOVfolder'],[filePD(aa).Exp,'_','r',num2str(bb),'.mat']),'WellSnapshot');
         end
         %%----------------------------------------------------------------
         for cc = 1:length(filePD(aa).worms{bb})
         wormData= filePD(aa).worms{bb}{cc};
         for j = 1:length(filePD(aa).worms{bb}{cc}.worm_bc)
            
                    %----------------------------------------------
                    [myNewBoundingBox, myNewWormMask]=dilateOldMaskALittle(im2double(WellSnapshot{cc}), wormData.W_BoundingBox{j},wormData.Worm_Mask{j},wormData.worm_bc{j},wormData.perimeter_worm{j},wormData.area_worm{j});
                    tmp1 = excludeNotWormInFinalPic(im2double(WellSnapshot{cc}), myNewBoundingBox, myNewWormMask ,wormData.worm_bc{j});
                    tmp3 = rescaleToMachineSize(machinePicSize, tmp1);
                    %--------------------------------------------------------------------------
                    if ResultPD.CurlCrit{aa}{bb}{cc}{j}==2,            folderName='Censored';
                    elseif ResultPD.CurlCrit{aa}{bb}{cc}{j}==1,        folderName='Curled'; 
                    elseif ResultPD.tagNearCurlState{aa}{bb}{cc}{j}==1,folderName='NearCurled';
                    elseif ResultPD.tagNearCurlState{aa}{bb}{cc}{j}==0,folderName='Straight';
                    end
                    %--------------------------------------------------------------------------
                    myNameText = strcat(info.filename,'_',num2str(aa),'_',num2str(bb),'_',num2str(cc),'_',num2str(j),'.png');     
                    mFolder     = fullfile(mHeadFolder,folderName);
                    if ~exist(mFolder,'dir'),mkdir(mFolder);end
                    imwrite(tmp3,fullfile(mFolder,myNameText));
                    %--------------------------------------------------------------------------
         end         
         end  
     end
     end
     set(Layout.command_line,'string','>> SavingTiles done!');drawnow;
end
end
%%--------------------------------------------------------------------- 
function refinedTile = excludeNotWormInFinalPic(bigImage, BoundingBox,wormMaskCrpd,wormBC)

        maxDetectLevelFine       = 4;
        DetectFineLeveling       = [true,...
                                    true, false,...
                                    true, true, false,...
                                    true, true, false, false]; 
                  
         wormTile = imcrop(bigImage,BoundingBox); 
         actualMaskOfworm = imcrop(poly2mask(wormBC(:,2),wormBC(:,1),size(bigImage,1),size(bigImage,2)),BoundingBox); 
         PixelID_of_Worm = find(actualMaskOfworm);

         for i=1:maxDetectLevelFine
             tmpThresh{i} = multithresh(wormTile(find(wormMaskCrpd==1)),i);
         end
         tmp = cell2mat(tmpThresh);
         wromThresh = sort(tmp(DetectFineLeveling),'ascend');


        mm=0; 
        for i=1:length(wromThresh)
            slimBinary     = imfill( imbinarize(wormMaskCrpd.*wormTile,wromThresh(i)), 'holes');
            tmp0           = bwconncomp(slimBinary,8);
            
            [~,col,~] = find(    cellfun(@numel,tmp0.PixelIdxList)  >  (0.01*length(PixelID_of_Worm))       );
            
            for kk=1:length(col)
                mm=mm+1;
                PixelID_of_notWorms{mm} = tmp0.PixelIdxList{col(kk)};
            end
        end

        makeBlackThisID={};
        ff=0;
        for ee=1:length(PixelID_of_notWorms)
            if ( length(intersect(PixelID_of_notWorms{ee},PixelID_of_Worm)) < (0.005*length(PixelID_of_Worm)))
                ff=ff+1; 
                makeBlackThisID{ff}=PixelID_of_notWorms{ee};
            end
        end  
        
        for gg=1:length(makeBlackThisID)
            wormMaskCrpd(makeBlackThisID{gg}) = false;
            wormTile(makeBlackThisID{gg}) = 0;
        end 
        refinedTile = imadjust(wormMaskCrpd.*wormTile, stretchlim(wormTile(find(wormMaskCrpd==1))),[0.01,0.99]);   
end
%%-------------------------------------------------------------------------
%%-------------------------------------------------------------------------
function [myNewBoundingBox,croppedDilatedWormMask]=dilateOldMaskALittle(bigImage, BoundingBox,wormMaskCrpd,wormBC, perimeterOfThisWorm, areaOfThisWorm)

        maxDetectLevelFine =4;
        DetectFineLeveling       = [true,...
                                    true, false,...
                                    true, true, false,...
                                    true, true, false, false];  
                         
         wormTile = imcrop(bigImage,BoundingBox); 
         actualMaskOfworm = imcrop(poly2mask(wormBC(:,2),wormBC(:,1),size(bigImage,2),size(bigImage,1)),BoundingBox); 
         PixelID_of_Worm = find(actualMaskOfworm);

         for i=1:maxDetectLevelFine
             tmpThresh{i} = multithresh(wormTile(find(wormMaskCrpd==1)),i);
         end
         tmp = cell2mat(tmpThresh);
         wromThresh = sort(tmp(DetectFineLeveling),'ascend');

        mm=0; 
        for i=1:length(wromThresh)
            slimBinary     = imcomplement( imbinarize(wormMaskCrpd.*wormTile,wromThresh(i)));
            tmp0           = bwconncomp(slimBinary,8);
           
            [~,col,~] = find(    cellfun(@numel,tmp0.PixelIdxList)  >  (0.05*length(PixelID_of_Worm))       );
            
            for kk=1:length(col)
                mm=mm+1;
                PixelID_of_reverseWorms{mm} = tmp0.PixelIdxList{col(kk)};
            end
        end

         for ee=1:length(PixelID_of_reverseWorms)
            theIntersectLength(ee) = length(intersect(PixelID_of_reverseWorms{ee},PixelID_of_Worm));
            if (theIntersectLength(ee)~=length(PixelID_of_reverseWorms{ee}))
                theIntersectLength(ee) =0;
            end
         end 
         [maxIntersectLength, myII] = max(theIntersectLength); 
         holesInsideWorms = wormMaskCrpd; holesInsideWorms(:)=false;
         holesInsideWorms(PixelID_of_reverseWorms{myII})=true;
         reverseStats = regionprops(holesInsideWorms,'Area','Perimeter');
         
        if (maxIntersectLength==0)
            holeArea = 0;
            holePerimeter = 0;
        else
            holeArea = reverseStats.Area;
            holePerimeter = reverseStats.Perimeter;
        end
       
        bigImageMask = poly2mask(wormBC(:,2),wormBC(:,1),size(bigImage,1),size(bigImage,2));
        wormMaskdilated    = logical(imdilate(bigImageMask,strel('disk',floor(4*(areaOfThisWorm-holeArea)/(perimeterOfThisWorm+holePerimeter)),4)));
        ImageProp             = regionprops(wormMaskdilated,'BoundingBox');
        myNewBoundingBox     = ImageProp.BoundingBox;
        croppedDilatedWormMask = imcrop(wormMaskdilated,myNewBoundingBox);                         
end
%%-------------------------------------------------------------------------



