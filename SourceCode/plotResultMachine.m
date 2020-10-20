function [Layout,info,ResultPD]=plotResultMachine(Layout,info,filePD, ResultPD)
if ~isfield(filePD, 'my_imds')
if isfield(filePD(1).worms{1}{1}, 'WormCat')
%% ----------------------------------------------------------------
         yy = ResultPD.MontageBound{info.montageShownID}(3);
         sally_1=0;
         imagesc(ResultPD.LittleMontage{info.montageShownID},'parent',Layout.axesImageSeven);colormap('Gray');axis equal; hold(Layout.axesImageSeven, 'on');
         for i = 1:length(filePD)
         for j = 1:length(filePD(i).worms)
         for s = 1:length(filePD(i).worms{j})
         if ResultPD.textPos{i}{j}{s}{1}(1)<ResultPD.MontageBound{info.montageShownID}(4)   &&  ResultPD.textPos{i}{j}{s}{1}(1)>ResultPD.MontageBound{info.montageShownID}(3)
         
             if sally_1==0, sally_1=i; sally_2=j; sally_3=s;end
             for k = 1:length(filePD(i).worms{j}{s}.worm_bc)    
                  %%----------------------------------------------------------------
                  ii = num2str(i); jj = num2str(j); ss = num2str(s); kk = num2str(k);
                  plot_name = ['h',ii,'_',jj,'_',ss,'_',kk]; 
                        S_AVGclassCat = filePD(i).worms{j}{s}.WormCat{k};
                        if     strcmp(S_AVGclassCat,'Curled')        , colorStr='r-';
                        elseif strcmp(S_AVGclassCat,'HalfCurled')    , colorStr='m-';
                        elseif strcmp(S_AVGclassCat,'NearCurled')    , colorStr='g-';
                        elseif strcmp(S_AVGclassCat,'Straight')      , colorStr='b-';
                        elseif strcmp(S_AVGclassCat,'Censored')      , colorStr='y-';
                        end
                        for iK=1:length(ResultPD.worm_bc_smoothed{i}{j}{s}{k})
                            ResultPD.MTG.tmp = plot(ResultPD.worm_bc_smoothed{i}{j}{s}{k}{iK}(:,2), ResultPD.worm_bc_smoothed{i}{j}{s}{k}{iK}(:,1)-yy, colorStr, 'LineWidth', 1,'parent', Layout.axesImageSeven);
                            ResultPD.MTG.(plot_name){iK} = ResultPD.MTG.tmp;
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
                     text(ResultPD.textPos{i}{j}{s}{k}(2),ResultPD.textPos{i}{j}{s}{k}(1)-yy,num2str(k),'FontWeight','bold','FontSize', 12, 'color','y','parent', Layout.axesImageSeven); 
                     text(ResultPD.textPos{i}{j}{s}{k}(2),ResultPD.textPos{i}{j}{s}{k}(1)-yy,num2str(k),'FontWeight','bold','FontSize', 12, 'color','y','parent', Layout.axesImageSeven); 
                     end
                     text(ResultPD.MontageBound{info.montageShownID}(2)+ResultPD.textPos{i}{j}{s}{1}(2)-120,ResultPD.textPos{i}{j}{s}{1}(1)-yy,[filePD(i).Exp(1),filePD(i).Exp(2),'-r',num2str(j),'-s',num2str(s)],'FontWeight','bold','FontSize', 14, 'color','r','parent', Layout.axesImageSeven);
                     text(ResultPD.MontageBound{info.montageShownID}(2)+ResultPD.textPos{i}{j}{s}{1}(2)-120,ResultPD.textPos{i}{j}{s}{1}(1)-yy,[filePD(i).Exp(1),filePD(i).Exp(2),'-r',num2str(j),'-s',num2str(s)],'FontWeight','bold','FontSize', 14, 'color','r','parent', Layout.axesImageSeven); 
                     end
                 end
             end
         end 
         axis(Layout.axesImageSeven,'equal');set(Layout.axesImageSeven  , 'XTick'   ,[],'YTick',[]);
         axis(Layout.axesImageSeven,'equal');set(Layout.axesImageSeven   , 'XTick'   ,[],'YTick',[]);  
end
end
end