function [info,ResultPD] = createResultMontageForMachine(Layout,info, filePD)
%% -----------------------------------------------------------------
        MontageRowNumer = 8;
        ImageUnitSZ = 100;
        for aa=1:length(filePD)
        set(Layout.command_line,'string',['>> CreatingMontage #',num2str(aa),'/',num2str(length(filePD))]);drawnow; 
        for bb=1:length(filePD(aa).worms)   
            %-------------------------------------------------------------
            if        strcmp(info.format,'nd2')==1
                 load(fullfile(pwd,[info.filename,'_nd2Folder'],[filePD(aa).Exp,'_','r',num2str(bb),'.mat']),'WellSnapshot');
            elseif    strcmp(info.format,'vid')==1
                 load(fullfile(pwd,[info.filename,'_MOVfolder'],[filePD(aa).Exp,'_','r',num2str(bb),'.mat']),'WellSnapshot');
            end
            %-------------------------------------------------------------
            %-------------------------------------------------------------
                    for cc=1:length(filePD(aa).worms{bb})

                     iter = find(ismember(info.ID2ind_list,[aa,bb,cc],'rows'));
                     clear tmp_master0 
                     wormData= filePD(aa).worms{bb}{cc};
                     %-------------------------------------------------------------
                     for j=1:length(wormData.perimeter_worm)
                                             clear dim_worm1 dim_worm2 dim_worm3 dim_worm4
                                             %-------------------------------------
                                             tmp0           = im2double(imcrop(WellSnapshot{cc},wormData.W_BoundingBox{j}));
                                             tmp1           = imadjust(wormData.Worm_Mask{j}.*tmp0, stretchlim(tmp0(wormData.Worm_Mask{j}),[0.01 0.99]));
                                             tmp1           = im2uint8(tmp1);
                                             %-------------------------------------
                                             dim_worm0      = wormData.worm_bc{j};
                                             for ik=1:length(dim_worm0)
                                                dim_worm1{ik}(:,1) = dim_worm0{ik}(:,1) - wormData.W_BoundingBox{j}(2);
                                                dim_worm1{ik}(:,2) = dim_worm0{ik}(:,2) - wormData.W_BoundingBox{j}(1);
                                             end
                                             tmp2 = 0;
                                             trash = 0;
                                             while max(size(tmp2)) ~= ImageUnitSZ
                                                 scale = ImageUnitSZ/(max(size(tmp1))+trash);
                                                 for ik=1:length(dim_worm1)
                                                     dim_worm2{ik} = dim_worm1{ik}*scale;
                                                     dim_worm3{ik} = dim_worm2{ik};
                                                 end
                                                 tmp2  = imresize(tmp1,scale);
                                                 trash = trash+0.1;
                                             end
                                             tmp3  = uint8(zeros(ImageUnitSZ,ImageUnitSZ));
                                             ind1 = floor((     max(size(tmp2))-min(size(tmp2))   )/2);
                                             if size(tmp2,1)>size(tmp2,2)
                                                 tmp3(:,(ind1+1):(ind1+size(tmp2,2))) =  tmp2;
                                                 for ik=1:length(dim_worm2)
                                                    dim_worm3{ik}(:,2) = dim_worm2{ik}(:,2)+ind1;
                                                 end
                                             else
                                                 tmp3((ind1+1):(ind1+size(tmp2,1)),:) =  tmp2;
                                                 for ik=1:length(dim_worm2)
                                                    dim_worm3{ik}(:,1) = dim_worm2{ik}(:,1)+ind1;
                                                 end
                                             end
                                             %-------------------------------------
                                             tmp_master0(:,:,1,j) = tmp3;
                                             for ik=1:length(dim_worm3)
                                                dim_worm4{ik}(:,1) = dim_worm3{ik}(:,1)+((iter-1)*ImageUnitSZ);
                                                dim_worm4{ik}(:,2) = dim_worm3{ik}(:,2)+((j-1)*ImageUnitSZ);
                                             end
                                             worm_master{aa}{bb}{cc}{j} = dim_worm4;
                                             textPos{aa}{bb}{cc}{j}(1) =  20  +((iter-1)*ImageUnitSZ);
                                             textPos{aa}{bb}{cc}{j}(2) =  20  +(j-1)*ImageUnitSZ;

                                             BoundBoxMontage{aa}{bb}{cc}{j}(3) = ((iter-1)*ImageUnitSZ)+1;
                                             BoundBoxMontage{aa}{bb}{cc}{j}(4) = (iter*ImageUnitSZ)-1;
                                             BoundBoxMontage{aa}{bb}{cc}{j}(1) = ((j-1)*ImageUnitSZ)+1;
                                             BoundBoxMontage{aa}{bb}{cc}{j}(2) = (j*ImageUnitSZ)-1;
                                             %-------------------------------------                  
                     end
                     %-------------------------------------------------------------
                     if length(wormData.perimeter_worm)==0
                         tmp_master0  = uint8(zeros(ImageUnitSZ,ImageUnitSZ));
                         textPos{aa}{bb}{cc}{1}(1) =  20  +((iter-1)*ImageUnitSZ);
                         textPos{aa}{bb}{cc}{1}(2) =  20  +(1-1)*ImageUnitSZ;

                         BoundBoxMontage{aa}{bb}{cc}{1}(3) = ((iter-1)*ImageUnitSZ)+1;
                         BoundBoxMontage{aa}{bb}{cc}{1}(4) = (iter*ImageUnitSZ)-1;
                         BoundBoxMontage{aa}{bb}{cc}{1}(1) = (0*ImageUnitSZ)+1;
                         BoundBoxMontage{aa}{bb}{cc}{1}(2) = (1*ImageUnitSZ)-1;
                     end
                     %-------------------------------------------------------------
                     tstruc = reshape(tmp_master0,size(tmp_master0,1),[]);
                     if iter==1
                         tmp_master1 =  tstruc;
                     else
                         if size(tstruc,2) < size(tmp_master1,2)
                             tstruc_tmp  = zeros([size(tmp_master1,1),size(tmp_master1,2)]);
                             tstruc_tmp(:,1:(size(tstruc,2))) =  tstruc;
                             tstruc      =  tstruc_tmp;
                         elseif size(tstruc,2) > size(tmp_master1,2)
                             tmp_master1__     = zeros(size(tstruc,1),size(tstruc,2),1,size(tmp_master1,4));
                             tmp_master1__(:,1:(size(tmp_master1,2)),:,:) = tmp_master1;
                             tmp_master1       = tmp_master1__;
                         end
                     end
                     %-------------------------------------------------------------
                     tmp_master1(:,:,1,iter) = tstruc;
                    end  
         end
         end
         montage = reshape(permute(tmp_master1,[2 1 3 4]),size(tmp_master1,2),[])';
         ResultPD.worm_bc_smoothed   = worm_master;
         ResultPD.textPos            = textPos;      
         ResultPD.BoundBoxMontage    = BoundBoxMontage;
         %-------------------------------------------------------------------------
         wdth_montage              = size(montage,2);
         hght_montage              = size(montage,1);
         NumRowShowAnalyze         = ceil(Layout.axesImageSeven.Position(4)*wdth_montage/(Layout.axesImageSeven.Position(3)*ImageUnitSZ));
         if MontageRowNumer>NumRowShowAnalyze, NumRowShowAnalyze = MontageRowNumer;end
         ResultPD.MaxMontageSplit  = ceil(hght_montage/ (NumRowShowAnalyze*ImageUnitSZ));
         %-------------------------------------------------------------------------
         for i=1:ResultPD.MaxMontageSplit
             YboundImageW              = NumRowShowAnalyze*ImageUnitSZ;
             if mod(hght_montage,NumRowShowAnalyze*ImageUnitSZ)~=0
                     YboundImageL              = hght_montage - ((i-1  )*NumRowShowAnalyze*ImageUnitSZ)-mod(hght_montage,NumRowShowAnalyze*ImageUnitSZ);
                     YboundImageH              = hght_montage - ((i-2)*NumRowShowAnalyze*ImageUnitSZ)-mod(hght_montage,NumRowShowAnalyze*ImageUnitSZ);
             else
                     YboundImageL              = hght_montage - ((i  )*NumRowShowAnalyze*ImageUnitSZ);
                     YboundImageH              = hght_montage - ((i-1)*NumRowShowAnalyze*ImageUnitSZ);
             end
             ResultPD.LittleMontage{i} = imcrop(montage,[1,YboundImageL,wdth_montage,YboundImageW]);

             MontageBound{i}(1)    = 0;
             MontageBound{i}(2)    = wdth_montage;
             MontageBound{i}(3)    = YboundImageL;
             MontageBound{i}(4)    = YboundImageH;
         end
         ResultPD.MontageBound = MontageBound;
         info.montageShownID= 1;
        %%-----------------------------------------------------------------
end