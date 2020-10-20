function [Layout,info,filePD, ResultPD] = click_action_Machine(Layout,info, filePD, ResultPD, hObject)
%% ------------------------------------------------------------------------
if strcmp(get(hObject,'SelectionType'),'normal')
    %%------------ left click ---------------------------------------------
    %%---------------------------------------------------------------------
    PointMouse = get(Layout.axesImageSeven, 'CurrentPoint');   
    x1 = ResultPD.MontageBound{info.montageShownID}(1);
    x2 = ResultPD.MontageBound{info.montageShownID}(2);
    y1 = ResultPD.MontageBound{info.montageShownID}(3);
    y2 = ResultPD.MontageBound{info.montageShownID}(4);
    PointMouse(1,2) = (ResultPD.MaxMontageSplit-info.montageShownID)*(y2-y1)+PointMouse(1,2);

    if PointMouse(1,1)>x1 &&  PointMouse(1,2)>y1 && PointMouse(1,1)<x2 &&  PointMouse(1,2)<y2   
            for i=1:length(filePD)
            for j=1:length(filePD(i).worms)
            for s=1:length(filePD(i).worms{j}) 
                    if  PointMouse(1,2)>ResultPD.BoundBoxMontage{i}{j}{s}{1}(3)  &&  PointMouse(1,2)<ResultPD.BoundBoxMontage{i}{j}{s}{1}(4)
                    for k=1:length(filePD(i).worms{j}{s}.worm_bc)   
                        if PointMouse(1,1)>ResultPD.BoundBoxMontage{i}{j}{s}{k}(1) &&  PointMouse(1,1)<ResultPD.BoundBoxMontage{i}{j}{s}{k}(2)

                                ii = num2str(i); jj = num2str(j); ss = num2str(s); kk = num2str(k);
                                plot_name = ['h',ii,'_',jj,'_',ss,'_',kk]; 
                                %%----------------------------------------    
                                if ~strcmp(filePD(i).worms{j}{s}.WormCat{k},'Censored')  
                                    filePD(i).worms{j}{s}.WormCat{k} ='Censored';
                                    for ik=1:length(ResultPD.MTG.(plot_name)),ResultPD.MTG.(plot_name){ik}.Color = 'yellow';end
                                elseif strcmp(filePD(i).worms{j}{s}.WormCat{k},'Censored') 
                                    [~,mI] = max(filePD(i).worms{j}{s}.WormProb{k});
                                    if mI==2,Cat='Curled'; CS='red'; elseif mI==3,Cat='HalfCurled';CS='magenta';elseif mI==4,Cat='NearCurled';CS='green';elseif mI==5,Cat='Straight';CS='blue';end 
                                    filePD(i).worms{j}{s}.WormCat{k} =Cat;
                                    for ik=1:length(ResultPD.MTG.(plot_name)),ResultPD.MTG.(plot_name){ik}.Color = CS;end
                                end
                                %%----------------------------------------
                                break
                        end
                    end
                    break
                    end
            end
            end
            end
    end
    
else
    %%------------ right click --------------------------------------------
    %%---------------------------------------------------------------------
    PointMouse = get(Layout.axesImageSeven, 'CurrentPoint');   
    x1 = ResultPD.MontageBound{info.montageShownID}(1);
    x2 = ResultPD.MontageBound{info.montageShownID}(2);
    y1 = ResultPD.MontageBound{info.montageShownID}(3);
    y2 = ResultPD.MontageBound{info.montageShownID}(4);
    PointMouse(1,2) = (ResultPD.MaxMontageSplit-info.montageShownID)*(y2-y1)+PointMouse(1,2);

    if PointMouse(1,1)>x1 &&  PointMouse(1,2)>y1 && PointMouse(1,1)<x2 &&  PointMouse(1,2)<y2   
            for i=1:length(filePD) 
            for j=1:length(filePD(i).worms) 
            for s=1:length(filePD(i).worms{j}) 

                    if  PointMouse(1,2)>ResultPD.BoundBoxMontage{i}{j}{s}{1}(3)  &&  PointMouse(1,2)<ResultPD.BoundBoxMontage{i}{j}{s}{1}(4) 
                    for k=1:length(filePD(i).worms{j}{s}.worm_bc)   
                        if PointMouse(1,1)>ResultPD.BoundBoxMontage{i}{j}{s}{k}(1) &&  PointMouse(1,1)<ResultPD.BoundBoxMontage{i}{j}{s}{k}(2) 

                                ii = num2str(i); jj = num2str(j); ss = num2str(s); kk = num2str(k);
                                plot_name = ['h',ii,'_',jj,'_',ss,'_',kk]; 
                                %%----------------------------------------
                                if strcmp(filePD(i).worms{j}{s}.WormCat{k},'Curled')  
                                    filePD(i).worms{j}{s}.WormCat{k} ='HalfCurled';
                                    for ik=1:length(ResultPD.MTG.(plot_name)),ResultPD.MTG.(plot_name){ik}.Color = 'magenta';end
                                elseif strcmp(filePD(i).worms{j}{s}.WormCat{k},'HalfCurled') 
                                    filePD(i).worms{j}{s}.WormCat{k} ='NearCurled';
                                    for ik=1:length(ResultPD.MTG.(plot_name)),ResultPD.MTG.(plot_name){ik}.Color = 'green';end
                                elseif strcmp(filePD(i).worms{j}{s}.WormCat{k},'NearCurled') 
                                    filePD(i).worms{j}{s}.WormCat{k} ='Straight';
                                    for ik=1:length(ResultPD.MTG.(plot_name)),ResultPD.MTG.(plot_name){ik}.Color = 'blue';end
                                elseif strcmp(filePD(i).worms{j}{s}.WormCat{k},'Straight') 
                                    filePD(i).worms{j}{s}.WormCat{k} ='Curled';
                                    for ik=1:length(ResultPD.MTG.(plot_name)),ResultPD.MTG.(plot_name){ik}.Color = 'red';end
                                end
                                %%----------------------------------------
                                break    
                        end
                    end
                    break
                    end
            end
            end
            end
    end
end
end
