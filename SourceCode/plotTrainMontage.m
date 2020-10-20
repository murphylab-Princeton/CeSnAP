function [Layout,info, ResultPD] = plotTrainMontage(Layout, info, filePD, ResultPD)
if isfield(filePD, 'my_imds')
%% ----------------------------------------------------------------
ImageUnitSZ         = 160;
montageUnitLength   = round(ImageUnitSZ*1.18);
locationInDatabase  = (info.montageShownID-1)*filePD.MontageRowNumer*filePD.MontageColNumer;

refinedDatabaseFiles  = filePD.my_imds.Files(ResultPD.plotThese_mInd);
refinedDatabaseLabels = filePD.my_imds.Labels(ResultPD.plotThese_mInd);
if isfield(filePD, 'neuralNet'), refinedDatabaseProbs  = ResultPD.mProbScore(ResultPD.plotThese_mInd,:); end


for iii=1:filePD.MontageRowNumer
for jjj=1:filePD.MontageColNumer
    sInd = sub2ind([filePD.MontageColNumer,filePD.MontageRowNumer],jjj,iii)+locationInDatabase;
    if (sInd<=length(refinedDatabaseFiles))
        
         clear dim_worm2 dim_worm3 dim_worm4
         m_image    = imread(refinedDatabaseFiles{sInd});
         m_maskTile = logical(m_image); m_maskTile(:)=true; 
         tmp1       = imadjust(m_image);
         m_greyScalePic{iii}{jjj} = tmp1;
         %-------------------------------------
         logicalWormTile = findBinaryWorm(im2double(tmp1),m_maskTile);
         dim_worm1= bwboundaries(logicalWormTile);
         tmp2 = 0;
         trash = 0;
         while max(size(tmp2)) ~= ImageUnitSZ
             scale = ImageUnitSZ/(max(size(tmp1))+trash);
             dim_worm2 = dim_worm1{1}*scale;
             dim_worm3 = dim_worm2; 
             tmp2  = imresize(tmp1,scale);
             trash = trash+0.1;
         end
         tmp3  = uint8(zeros(ImageUnitSZ,ImageUnitSZ));
         ind1 = floor((     max(size(tmp2))-min(size(tmp2))   )/2);
         if size(tmp2,1)>size(tmp2,2)
             tmp3(:,(ind1+1):(ind1+size(tmp2,2))) =  tmp2;
             dim_worm3(:,2) = dim_worm2(:,2)+ind1;
         else
             tmp3((ind1+1):(ind1+size(tmp2,1)),:) =  tmp2;
             dim_worm3(:,1) = dim_worm2(:,1)+ind1;
         end
         %-------------------------------------
         tmpImage=uint8(zeros(ImageUnitSZ,montageUnitLength));
         tmpImage(:,1:ImageUnitSZ)= tmp3;
         tmp_master0(:,:,1,jjj) = tmpImage;
         dim_worm4(:,1) = dim_worm3(:,1)+((iii-1)*ImageUnitSZ);
         dim_worm4(:,2) = dim_worm3(:,2)+((jjj-1)*ImageUnitSZ);
         
         worm_master{iii}{jjj} = dim_worm4;
         textPos{iii}{jjj}(1)  = ((iii-1)*ImageUnitSZ);
         textPos{iii}{jjj}(2)  = (jjj-1)*montageUnitLength;

         BoundBoxMontage{iii}{jjj}(3) = ((iii-1)*ImageUnitSZ)+1;
         BoundBoxMontage{iii}{jjj}(4) = (iii*ImageUnitSZ)-1;
         BoundBoxMontage{iii}{jjj}(1) = ((jjj-1)*montageUnitLength)+1;
         BoundBoxMontage{iii}{jjj}(2) = (jjj*montageUnitLength)-1;
    %-------------------------------------       
    else
        tmpImage=uint8(zeros(ImageUnitSZ,montageUnitLength));
        tmp_master0(:,:,1,jjj) = tmpImage;
    end
end
%-------------------------------------------------------------
tmp_master1(:,:,1,iii) = reshape(tmp_master0,size(tmp_master0,1),[]);
%-------------------------------------------------------------
end
%-------------------------------------------------------------------------
ResultPD.LittleMontage      = reshape(permute(tmp_master1,[2 1 3 4]),size(tmp_master1,2),[])';
ResultPD.worm_bc_smoothed   = worm_master;
ResultPD.textPos            = textPos;      
ResultPD.BoundBoxMontage    = BoundBoxMontage;
%%-------------------------------------------------------------------------
 cla(Layout.axesImageSeven   ,'reset');
 imagesc(ResultPD.LittleMontage,'parent',Layout.axesImageSeven);colormap('Gray');axis equal; hold(Layout.axesImageSeven, 'on');
 for iii=1:filePD.MontageRowNumer
 for jjj=1:filePD.MontageColNumer
            %%-------------------------------------------------------------
            sInd = sub2ind([filePD.MontageColNumer,filePD.MontageRowNumer],jjj,iii)+locationInDatabase;
            %-------------------------------------------------------------- 
            if sInd<=length(refinedDatabaseFiles)
                ii = num2str(iii); jj = num2str(jjj);
                plot_name = ['h',ii,'_',jj]; 

                if     (refinedDatabaseLabels(sInd)==filePD.mLabelArray(1))        , colorStr=Layout.mStrColor{1};
                elseif (refinedDatabaseLabels(sInd)==filePD.mLabelArray(2))        , colorStr=Layout.mStrColor{2};
                elseif (refinedDatabaseLabels(sInd)==filePD.mLabelArray(3))        , colorStr=Layout.mStrColor{3};
                elseif (refinedDatabaseLabels(sInd)==filePD.mLabelArray(4))        , colorStr=Layout.mStrColor{4};
                elseif (refinedDatabaseLabels(sInd)==filePD.mLabelArray(5))        , colorStr=Layout.mStrColor{5};
                elseif (refinedDatabaseLabels(sInd)==filePD.mLabelArray(6))        , colorStr=Layout.mStrColor{6};
                elseif (refinedDatabaseLabels(sInd)==filePD.mLabelArray(7))        , colorStr=Layout.mStrColor{7};
                elseif (refinedDatabaseLabels(sInd)==filePD.mLabelArray(8))        , colorStr=Layout.mStrColor{8};
                end

                ResultPD.MTG.tmp = rectangle('Position',[ResultPD.textPos{iii}{jjj}(2)+6,ResultPD.textPos{iii}{jjj}(1)+6,montageUnitLength-6,ImageUnitSZ-6],'EdgeColor',colorStr,'LineWidth',2,'parent', Layout.axesImageSeven);
                ResultPD.MTG.(plot_name) = ResultPD.MTG.tmp;
                %%-------------------------------------------------------------
                 dirSplit = strsplit(refinedDatabaseFiles{sInd},'\');
                 mSplit   = strsplit(dirSplit{end},'.');
                 text(ResultPD.textPos{iii}{jjj}(2)+6,ResultPD.textPos{iii}{jjj}(1)+14,mSplit{1},'FontWeight','bold','FontSize', 8, 'color','white','Interpreter', 'none','parent', Layout.axesImageSeven); 

                 if isfield(filePD, 'neuralNet') 
                     scoreArray= round(refinedDatabaseProbs(sInd,:)*100);
                     Y_increment = ImageUnitSZ/(length(ResultPD.CNN_labels)+1);
                     for mkk=1:length(ResultPD.CNN_labels)
                        text(ResultPD.textPos{iii}{jjj}(2)+ImageUnitSZ-5,ResultPD.textPos{iii}{jjj}(1)+(mkk*Y_increment),num2str(scoreArray(mkk)),'FontWeight','bold','FontSize', 9, 'color',Layout.mStrColor{mkk},'parent', Layout.axesImageSeven); 
                     end
                 end
                 %%-------------------------------------------------------------
            end
 end
 end                
axis(Layout.axesImageSeven,'equal');set(Layout.axesImageSeven  , 'XTick'   ,[],'YTick',[]);
axis(Layout.axesImageSeven,'equal');set(Layout.axesImageSeven   , 'XTick'   ,[],'YTick',[]);  
end
end