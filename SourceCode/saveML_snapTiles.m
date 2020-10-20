function saveML_snapTiles(Layout, info, filePD)
if isfield(filePD(1).worms{1}{1}, 'WormCat')
%% ------------------------------------------------------------------------ 
     machinePicSize=2*128;
     mHeadFolder = fullfile(pwd, 'savedBlobsML'); 
     if ~exist(mHeadFolder, 'dir'),mkdir(mHeadFolder);end
     %%---------------------------------------------------------------------  
     for aa = 1:length(filePD)
     set(Layout.command_line,'string',['>> SavingTiles #',num2str(aa),'/',num2str(length(filePD))]);drawnow; 
     for bb = 1:length(filePD(aa).worms)
         if        strcmp(info.format,'nd2')==1
             load(fullfile(pwd,[info.filename,'_nd2Folder'],[filePD(aa).Exp,'_','r',num2str(bb),'.mat']),'WellSnapshot');
         elseif    strcmp(info.format,'vid')==1
             load(fullfile(pwd,[info.filename,'_MOVfolder'],[filePD(aa).Exp,'_','r',num2str(bb),'.mat']),'WellSnapshot');
         end
         %%---------------------------------------------------------------------
         for cc = 1:length(filePD(aa).worms{bb})
         wormData= filePD(aa).worms{bb}{cc};
         for j = 1:length(filePD(aa).worms{bb}{cc}.worm_bc)
         blobTile      = im2double(imcrop(WellSnapshot{cc},wormData.W_BoundingBox{j}));
         refinedTile   = imadjust(wormData.Worm_Mask{j}.*blobTile, stretchlim(blobTile(wormData.Worm_Mask{j}),[0.01 0.99])); 
         tmp3          = rescaleToMachineSize(machinePicSize, refinedTile);
         myNameText = strcat(info.filename,'_',num2str(aa),'_',num2str(bb),'_',num2str(cc),'_',num2str(j),'.png');     
         mFolder     = fullfile(mHeadFolder,char(wormData.WormCat{j}));
         if ~exist(mFolder,'dir'),mkdir(mFolder);end
         imwrite(tmp3,fullfile(mFolder,myNameText));  
        %---------------------------------------------------------------------    
         end
         end
     end
     end
     %%---------------------------------------------------------------------
set(Layout.command_line,'string',['>> SavingTiles done!']);drawnow;      
end
end