function [Layout,info,filePD, ResultPD] = click_action_threshold(Layout,info, filePD, ResultPD, hObject)
%% ------------------------------------------------------------------------
    if strcmp(get(hObject,'SelectionType'),'normal')
            %%------------ left click: add a point-------------------------
            %%-------------------------------------------------------------
            PointMouse = get(Layout.axesImageFour, 'CurrentPoint');   
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
                                            if ResultPD.CurlCrit{i}{j}{s}{k}==0
                                                ResultPD.CurlCrit{i}{j}{s}{k}=1;
                                                ResultPD.tagNearCurlState{i}{j}{s}{k}=0; 
                                                ResultPD.MTG.(plot_name).Color = 'red';

                                            elseif ResultPD.CurlCrit{i}{j}{s}{k}==1
                                                ResultPD.CurlCrit{i}{j}{s}{k}=2;
                                                ResultPD.tagNearCurlState{i}{j}{s}{k}=2;
                                                ResultPD.MTG.(plot_name).Color    = 'white';
                                                ResultPD.MTG.(plot_name).Visible  = 'off';

                                            elseif ResultPD.CurlCrit{i}{j}{s}{k}==2
                                                ResultPD.CurlCrit{i}{j}{s}{k}=0;
                                                ResultPD.tagNearCurlState{i}{j}{s}{k}=0;
                                                ResultPD.MTG.(plot_name).Color    = 'blue';
                                                ResultPD.MTG.(plot_name).Visible  = 'on';
                                            end
                                            break
                                    end
                                end
                                break
                                end
                        end;end;end
                end
    %%------------ right click: remove a point-----------------------------
    %%---------------------------------------------------------------------
    else
            PointMouse = get(Layout.axesImageFour, 'CurrentPoint');   
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
                                            if ResultPD.tagNearCurlState{i}{j}{s}{k}==0
                                                ResultPD.tagNearCurlState{i}{j}{s}{k}=1;
                                                ResultPD.CurlCrit{i}{j}{s}{k}=0;
                                                ResultPD.MTG.(plot_name).Color = 'green';

                                            elseif ResultPD.tagNearCurlState{i}{j}{s}{k}==1
                                                ResultPD.tagNearCurlState{i}{j}{s}{k}=2;
                                                ResultPD.CurlCrit{i}{j}{s}{k}=2;
                                                ResultPD.MTG.(plot_name).Color    = 'white';
                                                ResultPD.MTG.(plot_name).Visible  = 'off';

                                            elseif ResultPD.tagNearCurlState{i}{j}{s}{k}==2
                                                ResultPD.tagNearCurlState{i}{j}{s}{k}=0;
                                                ResultPD.CurlCrit{i}{j}{s}{k}=0;
                                                ResultPD.MTG.(plot_name).Color    = 'blue';
                                                ResultPD.MTG.(plot_name).Visible  = 'on';
                                            end
                                            break    
                                    end
                                end
                                break
                                end
                        end;end;end
                end
    end
end


