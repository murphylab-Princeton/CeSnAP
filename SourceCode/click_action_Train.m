function [Layout,info,filePD, ResultPD] = click_action_Train(Layout,info, filePD, ResultPD, hObject)
if isfield(filePD, 'my_imds')
%% ------------------------------------------------------------------------
mHeadFolder = fullfile(pwd, 'tr_Images'); 
if ~exist(mHeadFolder, 'dir'),mkdir(mHeadFolder);end
for ik=1:length(filePD.mLabelArray)
    mFolder{ik}     = fullfile(pwd, 'tr_Images', char(filePD.mLabelArray(ik)));
    if ~exist(mFolder{ik}, 'dir'),mkdir(mFolder{ik});end
end
%%-------------------------------------------------------------------------
if strcmp(get(hObject,'SelectionType'),'normal')
%%------------ left click -------------------------------------------------
%%-------------------------------------------------------------------------
    PointMouse = get(Layout.axesImageSeven, 'CurrentPoint');   
    
    for iii=1:filePD.MontageRowNumer
    for jjj=1:filePD.MontageColNumer
        
        if (iii<=length(ResultPD.BoundBoxMontage))
        if (jjj<=length(ResultPD.BoundBoxMontage{iii}))
        
            if (PointMouse(1,2)>ResultPD.BoundBoxMontage{iii}{jjj}(3))  &&  (PointMouse(1,2)<ResultPD.BoundBoxMontage{iii}{jjj}(4)) 
            if (PointMouse(1,1)>ResultPD.BoundBoxMontage{iii}{jjj}(1))   &&  (PointMouse(1,1)<ResultPD.BoundBoxMontage{iii}{jjj}(2)) 

                                locationInDatabase = (info.montageShownID-1)*filePD.MontageRowNumer*filePD.MontageColNumer;            
                                mInd = sub2ind([filePD.MontageColNumer,filePD.MontageRowNumer],jjj,iii)+locationInDatabase;
                                ii = num2str(iii); jj = num2str(jjj);
                                plot_name = ['h',ii,'_',jj]; 
                                %%-----------------------------------------
                                id_label = find(filePD.mLabelArray==filePD.my_imds.Labels(mInd));
                                if (id_label~=1)
                                    filePD.my_imds.Labels(mInd) = filePD.mLabelArray(id_label-1);
                                    ResultPD.MTG.(plot_name).EdgeColor = Layout.mStrColor{id_label-1};
                                    filePD = moveMyFile(filePD, mInd,mFolder{id_label-1});
                                else
                                    filePD.my_imds.Labels(mInd) = filePD.mLabelArray(length(filePD.mLabelArray));
                                    ResultPD.MTG.(plot_name).EdgeColor = Layout.mStrColor{length(filePD.mLabelArray)};
                                    filePD = moveMyFile(filePD, mInd,mFolder{length(filePD.mLabelArray)});
                                end
                                %%----------------------------------------
                                break    
            end
            end
        end
        end
    end             
    end
else
%%------------ right click ------------------------------------------------
%%-------------------------------------------------------------------------
    PointMouse = get(Layout.axesImageSeven, 'CurrentPoint');   

    for iii=1:filePD.MontageRowNumer
    for jjj=1:filePD.MontageColNumer
        
        if (iii<=length(ResultPD.BoundBoxMontage))
        if (jjj<=length(ResultPD.BoundBoxMontage{iii}))

            if PointMouse(1,2)>ResultPD.BoundBoxMontage{iii}{jjj}(3)  &&  PointMouse(1,2)<ResultPD.BoundBoxMontage{iii}{jjj}(4) 
            if PointMouse(1,1)>ResultPD.BoundBoxMontage{iii}{jjj}(1)   &&  PointMouse(1,1)<ResultPD.BoundBoxMontage{iii}{jjj}(2)
                                
                                locationInDatabase    = (info.montageShownID-1)*filePD.MontageRowNumer*filePD.MontageColNumer;            
                                mInd = sub2ind([filePD.MontageColNumer,filePD.MontageRowNumer],jjj,iii)+locationInDatabase;
                                ii = num2str(iii); jj = num2str(jjj); 
                                plot_name = ['h',ii,'_',jj]; 
                                %%----------------------------------------
                                id_label = find(filePD.mLabelArray==filePD.my_imds.Labels(mInd));
                                if (id_label~=length(filePD.mLabelArray))
                                    filePD.my_imds.Labels(mInd) = filePD.mLabelArray(id_label+1);
                                    ResultPD.MTG.(plot_name).EdgeColor = Layout.mStrColor{id_label+1};
                                    filePD = moveMyFile(filePD, mInd,mFolder{id_label+1});
                                else
                                    filePD.my_imds.Labels(mInd) = filePD.mLabelArray(1);
                                    ResultPD.MTG.(plot_name).EdgeColor = Layout.mStrColor{1};
                                    filePD = moveMyFile(filePD, mInd,mFolder{1});
                                end
                                %%----------------------------------------
                                break       
            end
            end
        end
        end
    end
    end
%%-------------------------------------------------------------------------
%%-------------------------------------------------------------------------
end
end
end

function filePD = moveMyFile(filePD, mInd, destination)
    dirSplit       = strsplit(filePD.my_imds.Files{mInd},'\');
    FileToMove = filePD.my_imds.Files{mInd};
    movefile(FileToMove,destination);
    filePD.my_imds.Files{mInd} = fullfile(destination,dirSplit{end});
end

