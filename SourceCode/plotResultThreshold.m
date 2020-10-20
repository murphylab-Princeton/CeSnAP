function Layout = plotResultThreshold(Layout, info,filePD, ResultPD)
if ~isfield(filePD, 'my_imds')
if isfield(filePD(1).worms{1}{1}, 'worm_bc_trash')
%% ----------------------------------------------------------------
         imagesc(ResultPD.LittleMontage{info.montageShownID},'parent',Layout.axesImageThree);colormap('Gray');axis equal; hold(Layout.axesImageThree, 'on');
         yy = ResultPD.MontageBound{info.montageShownID}(3);
         for i = 1:length(filePD)
         for j = 1:length(filePD(i).worms)
         for s = 1:length(filePD(i).worms{j})
         if ResultPD.textPos{i}{j}{s}{1}(1)<ResultPD.MontageBound{info.montageShownID}(4)  &&  ResultPD.textPos{i}{j}{s}{1}(1)>ResultPD.MontageBound{info.montageShownID}(3) 
         for k = 1:length(filePD(i).worms{j}{s}.worm_bc)
             
                    if     ResultPD.tagAreaBased{i}{j}{s}{k}==1  &&  ResultPD.tagPeriBased{i}{j}{s}{k}==1  &&  ResultPD.tagDimBased{i}{j}{s}{k}==1
                        plot(ResultPD.worm_bc_smoothed{i}{j}{s}{k}(:,2), ResultPD.worm_bc_smoothed{i}{j}{s}{k}(:,1)-yy, 'r-', 'LineWidth', 1,'parent', Layout.axesImageThree);
                    elseif ResultPD.tagAreaBased{i}{j}{s}{k}==0  &&  ResultPD.tagPeriBased{i}{j}{s}{k}==1  &&  ResultPD.tagDimBased{i}{j}{s}{k}==1 
                        plot(ResultPD.worm_bc_smoothed{i}{j}{s}{k}(:,2), ResultPD.worm_bc_smoothed{i}{j}{s}{k}(:,1)-yy, 'y-', 'LineWidth', 3,'parent', Layout.axesImageThree);
                    elseif ResultPD.tagAreaBased{i}{j}{s}{k}==1  &&  ResultPD.tagPeriBased{i}{j}{s}{k}==0  &&  ResultPD.tagDimBased{i}{j}{s}{k}==1
                        plot(ResultPD.worm_bc_smoothed{i}{j}{s}{k}(:,2), ResultPD.worm_bc_smoothed{i}{j}{s}{k}(:,1)-yy, 'c-', 'LineWidth', 3,'parent', Layout.axesImageThree);
                    elseif ResultPD.tagAreaBased{i}{j}{s}{k}==0  &&  ResultPD.tagPeriBased{i}{j}{s}{k}==0  &&  ResultPD.tagDimBased{i}{j}{s}{k}==1
                        plot(ResultPD.worm_bc_smoothed{i}{j}{s}{k}(:,2), ResultPD.worm_bc_smoothed{i}{j}{s}{k}(:,1)-yy, 'g-', 'LineWidth', 3,'parent', Layout.axesImageThree);
                    elseif ResultPD.tagDimBased{i}{j}{s}{k}==0
                        plot(ResultPD.worm_bc_smoothed{i}{j}{s}{k}(:,2), ResultPD.worm_bc_smoothed{i}{j}{s}{k}(:,1)-yy, 'm-', 'LineWidth', 3,'parent', Layout.axesImageThree);
                    end       
         end
         end
         end
         end
         end
         %%----------------------------------------------------------------
         sally_1=0;
         imagesc(ResultPD.LittleMontage{info.montageShownID},'parent',Layout.axesImageFour);colormap('Gray');axis equal; hold(Layout.axesImageFour, 'on');
         for i = 1:length(filePD)
         for j = 1:length(filePD(i).worms)
         for s = 1:length(filePD(i).worms{j})
         if ResultPD.textPos{i}{j}{s}{1}(1)<ResultPD.MontageBound{info.montageShownID}(4)   &&  ResultPD.textPos{i}{j}{s}{1}(1)>ResultPD.MontageBound{info.montageShownID}(3)
         for k = 1:length(filePD(i).worms{j}{s}.worm_bc)    
              %%----------------------------------------------------------------
              if sally_1==0 
                  sally_1 = i;
                  sally_2 = j;
                  sally_3 = s;
              end
              %%----------------------------------------------------------------
              ii = num2str(i); jj = num2str(j); ss = num2str(s); kk = num2str(k);
              plot_name = ['h',ii,'_',jj,'_',ss,'_',kk]; 
                    if     ResultPD.CurlCrit{i}{j}{s}{k}==1
                            ResultPD.MTG.tmp = plot(ResultPD.worm_bc_smoothed{i}{j}{s}{k}(:,2), ResultPD.worm_bc_smoothed{i}{j}{s}{k}(:,1)-yy, 'r-', 'LineWidth', 1,'parent', Layout.axesImageFour);
                            ResultPD.MTG.(plot_name) = ResultPD.MTG.tmp;
                    elseif ResultPD.CurlCrit{i}{j}{s}{k}==0
                        if ResultPD.tagNearCurlState{i}{j}{s}{k}==1
                            ResultPD.MTG.tmp = plot(ResultPD.worm_bc_smoothed{i}{j}{s}{k}(:,2), ResultPD.worm_bc_smoothed{i}{j}{s}{k}(:,1)-yy, 'g-', 'LineWidth', 1,'parent', Layout.axesImageFour);
                            ResultPD.MTG.(plot_name) = ResultPD.MTG.tmp;
                        else
                            ResultPD.MTG.tmp = plot(ResultPD.worm_bc_smoothed{i}{j}{s}{k}(:,2), ResultPD.worm_bc_smoothed{i}{j}{s}{k}(:,1)-yy, 'b-', 'LineWidth', 1,'parent', Layout.axesImageFour);
                            ResultPD.MTG.(plot_name) = ResultPD.MTG.tmp;
                        end
                    elseif ResultPD.CurlCrit{i}{j}{s}{k}==2
                            ResultPD.MTG.tmp         = plot(ResultPD.worm_bc_smoothed{i}{j}{s}{k}(:,2), ResultPD.worm_bc_smoothed{i}{j}{s}{k}(:,1)-yy, 'w-', 'LineWidth', 1,'parent', Layout.axesImageFour);
                            ResultPD.MTG.tmp.Visible = 'off';
                            ResultPD.MTG.(plot_name) = ResultPD.MTG.tmp;
                    end
                    
         end
         info.CurrentProcessID = find(ismember(info.ID2ind_list,[sally_1,sally_2,sally_3],'rows'));
         end
         end
         end
         end
         ResultPD.MTG.tmp = 0;
         %%-------------------------------------------------------------------------
         for i=1:length(filePD)
             for j=1:length(filePD(i).worms)
                 for s=1:length(filePD(i).worms{j}) 
                     if ResultPD.textPos{i}{j}{s}{1}(1)<ResultPD.MontageBound{info.montageShownID}(4)   &&  ResultPD.textPos{i}{j}{s}{1}(1)>ResultPD.MontageBound{info.montageShownID}(3)
                     for k=1:length(filePD(i).worms{j}{s}.worm_bc)           
                     a1= text(ResultPD.textPos{i}{j}{s}{k}(2),ResultPD.textPos{i}{j}{s}{k}(1)-yy,num2str(k),'FontWeight','bold','FontSize', 12, 'color','y','parent', Layout.axesImageThree);a1.Clipping = 'on'; 
                     a2= text(ResultPD.textPos{i}{j}{s}{k}(2),ResultPD.textPos{i}{j}{s}{k}(1)-yy,num2str(k),'FontWeight','bold','FontSize', 12, 'color','y','parent', Layout.axesImageFour);a2.Clipping = 'on'; 
                     end
                     a3=text(ResultPD.MontageBound{info.montageShownID}(2)+ResultPD.textPos{i}{j}{s}{1}(2)-120,ResultPD.textPos{i}{j}{s}{1}(1)-yy,[filePD(i).Exp(1),filePD(i).Exp(2),'-r',num2str(j),'-s',num2str(s)],'FontWeight','bold','FontSize', 14, 'color','r','parent', Layout.axesImageSeven);a3.Clipping = 'on';
                     a4=text(ResultPD.MontageBound{info.montageShownID}(2)+ResultPD.textPos{i}{j}{s}{1}(2)-120,ResultPD.textPos{i}{j}{s}{1}(1)-yy,[filePD(i).Exp(1),filePD(i).Exp(2),'-r',num2str(j),'-s',num2str(s)],'FontWeight','bold','FontSize', 14, 'color','r','parent', Layout.axesImageSeven);a4.Clipping = 'on'; 
                     end
                 end
             end
         end 
         axis(Layout.axesImageThree,'equal');set(Layout.axesImageThree  , 'XTick'   ,[],'YTick',[]);
         axis(Layout.axesImageFour,'equal');set(Layout.axesImageFour   , 'XTick'   ,[],'YTick',[]);
         
        set(Layout.curlReport1      , 'string',['#AreaFiltered/#Total= ',num2str(ResultPD.tagAreaNum),' / ',num2str(ResultPD.totalNum)]); 
        set(Layout.curlReport2      , 'string',['#PeriFiltered/#Total= ',num2str(ResultPD.tagPeriNum),' / ',num2str(ResultPD.totalNum)]);
        set(Layout.curlReport3      , 'string',['#DimFiltered/#Total= ' ,num2str(ResultPD.tagDimNum) ,' / ',num2str(ResultPD.totalNum)]);
end
end
end