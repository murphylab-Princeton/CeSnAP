function [Layout,ResultPD] = analyze_Segments(Layout,info,filePD, ResultPD)
%--------------------------------------------- Accessing default parameters  
 MontageRowNumer     = str2double(info.MontageRowNumber); 
 ImageUnitSZ         = str2double(info.ImageUnitSZ);
 AreaFilterValue     = str2double(info.areaBsFilter);
 AreaFilterValueH    = str2double(info.areaBsFilterH);
 AreaFilterValueL    = str2double(info.areaBsFilterL );
 PeriFilterValue     = str2double(info.periBsdFilter);
 PeriFilterValueH    = str2double(info.periBsdFilterH);
 PeriFilterValueL    = str2double(info.periBsdFilterL);
 DimFilterValue      = str2double(info.dimBsdFilter);
 CurlCriteria        = str2double(info.CurlCriteria);
 NearCurlCriteria    = str2double(info.NearCurlCriteria);
 MagCriteria         = str2double(info.MagCriteria);

 %------------------------------------------------------------------------- 
if isempty(ResultPD)
    OLDImageUnitSize          = 0;
else
    OLDImageUnitSize    = ResultPD.BoundBoxMontage{1}{1}{1}{1}(1)+ResultPD.BoundBoxMontage{1}{1}{1}{1}(2);
    
    rmfield(ResultPD,'tagAreaBased');
    rmfield(ResultPD,'tagPeriBased');
    rmfield(ResultPD,'tagDimBased');
    rmfield(ResultPD,'CurlCrit');
    rmfield(ResultPD,'tagNearCurlState');

    rmfield(ResultPD,'tagAreaNum');
    rmfield(ResultPD,'tagPeriNum');
    rmfield(ResultPD,'tagDimNum');
    rmfield(ResultPD,'totalNum');
end
 %-------------------------------------------------------------------------
 %-------------------------------------------------------------------------
if  ImageUnitSZ~=OLDImageUnitSize %||  MontageRowNumer~=OLDMontageRowNumer
if ~isempty(ResultPD)
rmfield(ResultPD,'worm_bc_smoothed');
rmfield(ResultPD,'wormSmoothed');
rmfield(ResultPD,'textPos');
rmfield(ResultPD,'BoundBoxMontage');
rmfield(ResultPD,'MaxMontageSplit');
rmfield(ResultPD,'LittleMontage');
rmfield(ResultPD,'MontageBound');
rmfield(ResultPD,'MTG');
end 
for aa=1:length(filePD)
set(Layout.command_line,'string',['>> Analyzing #',num2str(aa),'/',num2str(length(filePD))]);drawnow; 
for bb=1:length(filePD(aa).worms)   
            %-------------------------------------------------------------
            filepath = pwd;
            if        strcmp(info.format,'nd2')==1
                 load(fullfile(filepath,[info.filename,'_nd2Folder'],[filePD(aa).Exp,'_','r',num2str(bb),'.mat']),'WellSnapshot');
            elseif    strcmp(info.format,'vid')==1
                 load(fullfile(filepath,[info.filename,'_MOVfolder'],[filePD(aa).Exp,'_','r',num2str(bb),'.mat']),'WellSnapshot');
            end
            for cc=1:length(filePD(aa).worms{bb})
                
             iter = find(ismember(info.ID2ind_list,[aa,bb,cc],'rows'));
             clear tmp_master0 
             wormData= filePD(aa).worms{bb}{cc};
             %-------------------------------------------------------------
             for j=1:length(wormData.perimeter_worm)
                                     clear dim_worm1 dim_worm3 dim_worm4
                                    %--------------------------------------------------------------------------
                                     tmp0           = im2double(imcrop(WellSnapshot{cc},wormData.W_BoundingBox{j}));
                                     tmp1           = imadjust(wormData.Worm_Mask{j}.*tmp0, stretchlim(tmp0(find(wormData.Worm_Mask{j}==1)),[0.01 0.99]));
                                     tmp1           = im2uint8(tmp1);
                                     listPoint      = wormData.worm_bc{j}(1:end-1,:);
                                     lngth          = length(listPoint);
                                     Point_rep_worm = 40;
                                     smoothLevel    = floor(lngth/Point_rep_worm);                      
                                     [wormSmoothed{aa}{bb}{cc}{j}] = CSTSmooth_Parkinson(listPoint, lngth, smoothLevel);
                                     %dim_worm0      = worm_bc_smoothed{i}{j};
                                     dim_worm0      = wormData.worm_bc{j};
                                     dim_worm1(:,1) = dim_worm0(:,1) - wormData.W_BoundingBox{j}(2);
                                     dim_worm1(:,2) = dim_worm0(:,2) - wormData.W_BoundingBox{j}(1);
                                     tmp2 = 0;
                                     trash = 0;
                                     while max(size(tmp2)) ~= ImageUnitSZ
                                         scale = ImageUnitSZ/(max(size(tmp1))+trash);
                                         dim_worm2 = dim_worm1*scale;
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
                                     tmp_master0(:,:,1,j) = tmp3;
                                     dim_worm4(:,1) = dim_worm3(:,1)+((iter-1)*ImageUnitSZ);
                                     dim_worm4(:,2) = dim_worm3(:,2)+((j-1)*ImageUnitSZ);
                                     worm_master{aa}{bb}{cc}{j} = dim_worm4;
                                     textPos{aa}{bb}{cc}{j}(1) =  20  +((iter-1)*ImageUnitSZ);
                                     textPos{aa}{bb}{cc}{j}(2) =  20  +(j-1)*ImageUnitSZ;
                                     
                                     BoundBoxMontage{aa}{bb}{cc}{j}(3) = ((iter-1)*ImageUnitSZ)+1;
                                     BoundBoxMontage{aa}{bb}{cc}{j}(4) = (iter*ImageUnitSZ)-1;
                                     BoundBoxMontage{aa}{bb}{cc}{j}(1) = ((j-1)*ImageUnitSZ)+1;
                                     BoundBoxMontage{aa}{bb}{cc}{j}(2) = (j*ImageUnitSZ)-1;
                                     
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
 ResultPD.wormSmoothed       = wormSmoothed;
 ResultPD.textPos            = textPos;      
 ResultPD.BoundBoxMontage    = BoundBoxMontage;
 %-------------------------------------------------------------------------
 wdth_montage              = size(montage,2);
 hght_montage              = size(montage,1);
 NumRowShowAnalyze         = ceil(Layout.axesImageThree.Position(4)*wdth_montage/(Layout.axesImageThree.Position(3)*ImageUnitSZ));
 if MontageRowNumer>NumRowShowAnalyze
     NumRowShowAnalyze = MontageRowNumer;
 end
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
end
 %-------------------------------------------------------------------------
 kk=0;
 for aa = 1:length(filePD)
 for bb = 1:length(filePD(aa).worms)
 for cc = 1:length(filePD(aa).worms{bb})
 for j=1:1:length(filePD(aa).worms{bb}{cc}.worm_bc)
                 kk=kk+1;
                 perimeter_list(kk) = filePD(aa).worms{bb}{cc}.perimeter_worm{j};
                 area_list(kk)      = filePD(aa).worms{bb}{cc}.area_worm{j};
                 Dim_list(kk)       = filePD(aa).worms{bb}{cc}.dimensionless{j};
 end
 end
 end
 end
 %-------------------------------------------------------------------------     
 if  AreaFilterValue~=0,      AreaBased  =  multithresh(area_list,AreaFilterValue); end
 %-------------------------------------------------------------------------
 if  PeriFilterValue ~= 0,   PeriBased  =  multithresh(perimeter_list,PeriFilterValue); end
 %-------------------------------------------------------------------------
 tagAreaNum  = 0;
 tagPeriNum  = 0;
 tagDimNum   = 0;
 totalNum    = 0;
 for aa = 1:length(filePD)
 for bb = 1:length(filePD(aa).worms)
 for cc = 1:length(filePD(aa).worms{bb})
 for j=1:1:length(filePD(aa).worms{bb}{cc}.worm_bc)
         %-----------------------------------------------------------------
         totalNum=totalNum+1;
         tagAreaBased{aa}{bb}{cc}{j} = 1;  
         if  AreaFilterValue~=0   &&    AreaFilterValueH~=0
                if filePD(aa).worms{bb}{cc}.area_worm{j}>AreaBased(AreaFilterValueH),      tagAreaBased{aa}{bb}{cc}{j} = 0; tagAreaNum=tagAreaNum+1;end
         end
         if AreaFilterValue~=0   &&    AreaFilterValueL~=0
                if filePD(aa).worms{bb}{cc}.area_worm{j}<AreaBased(AreaFilterValueL),      tagAreaBased{aa}{bb}{cc}{j} = 0; tagAreaNum=tagAreaNum+1;end
         end    
         %-----------------------------------------------------------------
         tagPeriBased{aa}{bb}{cc}{j} = 1;  
         if  PeriFilterValue~=0   &&    PeriFilterValueH~=0
                if filePD(aa).worms{bb}{cc}.perimeter_worm{j}>PeriBased(PeriFilterValueH),      tagPeriBased{aa}{bb}{cc}{j} = 0; tagPeriNum=tagPeriNum+1;end
         end
         if PeriFilterValue~=0   &&    PeriFilterValueL~=0
                if filePD(aa).worms{bb}{cc}.perimeter_worm{j}<PeriBased(PeriFilterValueL),      tagPeriBased{aa}{bb}{cc}{j} = 0; tagPeriNum=tagPeriNum+1;end
         end
         %-----------------------------------------------------------------
         if filePD(aa).worms{bb}{cc}.dimensionless{j}> DimFilterValue
                tagDimBased{aa}{bb}{cc}{j} = 1;      
         else
                tagDimBased{aa}{bb}{cc}{j} = 0;         tagDimNum=tagDimNum+1;
         end
         %-----------------------------------------------------------------
 end
 end
 end
 end
 %-------------------------------------------------------------------------
  for aa = 1:length(filePD)
  for bb = 1:length(filePD(aa).worms)
  for cc = 1:length(filePD(aa).worms{bb})
  for j  = 1:length(filePD(aa).worms{bb}{cc}.worm_bc)
        periOrig              = sum(sqrt(sum(diff(ResultPD.wormSmoothed{aa}{bb}{cc}{j}).^2,2)));
        areaOrig              = abs(f_closed_area(ResultPD.wormSmoothed{aa}{bb}{cc}{j}));
        DimOrig{aa}{bb}{cc}{j}    = 4*pi*areaOrig/((periOrig^2));   
  end
  end
  end
  end
 %------------------------------------------------------------------------- 
 for aa = 1:length(filePD)
 for bb = 1:length(filePD(aa).worms)
 for cc = 1:length(filePD(aa).worms{bb})
 for j  = 1:length(filePD(aa).worms{bb}{cc}.worm_bc)
            if tagAreaBased{aa}{bb}{cc}{j}==0  ||  tagPeriBased{aa}{bb}{cc}{j}==0  || tagDimBased{aa}{bb}{cc}{j}==0   
             tagCurlState{aa}{bb}{cc}{j} = 2; 
            else
                if DimOrig{aa}{bb}{cc}{j} >= CurlCriteria
                    tagCurlState{aa}{bb}{cc}{j} = 1;
                elseif DimOrig{aa}{bb}{cc}{j} < CurlCriteria
                    tagCurlState{aa}{bb}{cc}{j} = 0;   
                end  
            end           
 end
 end
 end
 end
 %-------------------------------------------------------------------------
 for aa = 1:length(filePD)
 for bb = 1:length(filePD(aa).worms)
 for cc = 1:length(filePD(aa).worms{bb})
 for j  = 1:length(filePD(aa).worms{bb}{cc}.worm_bc)
         
        idBC = boundary (ResultPD.wormSmoothed{aa}{bb}{cc}{j}(:,1),ResultPD.wormSmoothed{aa}{bb}{cc}{j}(:,2),NearCurlCriteria);
        nearCurlState{aa}{bb}{cc}{j}(:,1)  = ResultPD.wormSmoothed{aa}{bb}{cc}{j}(idBC,1);
        nearCurlState{aa}{bb}{cc}{j}(:,2)  = ResultPD.wormSmoothed{aa}{bb}{cc}{j}(idBC,2);
        
        periCurlState              = sum(sqrt(sum(diff(nearCurlState{aa}{bb}{cc}{j}).^2,2)));
        areaCurlState              = abs(f_closed_area(nearCurlState{aa}{bb}{cc}{j}));
        DimCurlState{aa}{bb}{cc}{j}    = 4*pi*areaCurlState/((periCurlState^2));     
 end
 end
 end
 end
 %------------------------------------------------------------------------- 
 for aa = 1:length(filePD)
 counter(aa) = 0;
 for bb = 1:length(filePD(aa).worms)
 for cc = 1:length(filePD(aa).worms{bb})
 for j      = 1:length(filePD(aa).worms{bb}{cc}.worm_bc)
         if tagAreaBased{aa}{bb}{cc}{j}==0  ||  tagPeriBased{aa}{bb}{cc}{j}==0  || tagDimBased{aa}{bb}{cc}{j}==0 
             tagNearCurlState{aa}{bb}{cc}{j} = 2; 
         else
             if  DimCurlState{aa}{bb}{cc}{j} > (MagCriteria*DimOrig{aa}{bb}{cc}{j})  &&  tagCurlState{aa}{bb}{cc}{j}==0
                    tagNearCurlState{aa}{bb}{cc}{j} = 1;
             else
                    tagNearCurlState{aa}{bb}{cc}{j} = 0;
             end
         end
 end
 end    
 end
 end
 %------------------------------------------------------------------------- 
 ResultPD.tagAreaBased       = tagAreaBased;
 ResultPD.tagPeriBased       = tagPeriBased;
 ResultPD.tagDimBased        = tagDimBased;
 ResultPD.CurlCrit           = tagCurlState;
 ResultPD.tagNearCurlState   = tagNearCurlState;
 
 ResultPD.tagAreaNum  = tagAreaNum;
 ResultPD.tagPeriNum  = tagPeriNum;
 ResultPD.tagDimNum   = tagDimNum;
 ResultPD.totalNum    = totalNum;
end