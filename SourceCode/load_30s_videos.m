function [Layout,info, filePD, ResultPD] = load_30s_videos(Layout, info, filePD, ResultPD)
%% ---------------------------------------------------------------------
        vid_directory  = uigetdir;
        dirSplit       = strsplit(vid_directory,'\');
        filepath       = fullfile(dirSplit{1:(end-1)});
        info.filename  = dirSplit{end};
        info.format    = 'vid';
        set(Layout.command_line ,'string','>> Extracting stills');drawnow;
        set(Layout.TargetFileN, 'string',info.filename);
        tmpFolders                          = dir(vid_directory);
        tmpFolders(~[tmpFolders.isdir])     = []; k=1;
        for ii=1:length(tmpFolders)
            if strcmp(tmpFolders(ii).name,'.')==false && strcmp(tmpFolders(ii).name,'..')==false
                 conditions{k} = tmpFolders(ii).name; k = k+1;
            end
        end
        %%-----------------------------------------------------------------
        mkdir([info.filename,'_MOVfolder']);
        %%-----------------------------------------------------------------
        conditionNum = 1;
        well_num     = 1;
        for ss=1:length(conditions)
        clear VidNameList
        videoNum = 1;
                for m=1:length(info.listOfExtensions)
                    VidNameList{m} = dir(fullfile(filepath,info.filename,conditions{conditionNum},['*.',info.listOfExtensions{m}]));
                end
                for i=1:length(VidNameList)
                    if ~isempty(VidNameList{i})
                        for j=1:length(VidNameList{i})
                            tmp = VidNameList{i};
                            clear vFILE
                            vFILE = VideoReader(fullfile(tmp(j).folder,tmp(j).name));
                            FrameSec = floor(1:round(floor(vFILE.Duration)-1));
                            frameNum = 1;
                            for k=1:length(FrameSec)
                                vFILE.CurrentTime=FrameSec(k);
                                tmpImages=readFrame(vFILE); 
                                if length(size(tmpImages)) ==3, tmpImages = rgb2gray(tmpImages);end
                                myImageMatrix{frameNum} = tmpImages;
                                snapshotsFinder{well_num}{1}{frameNum} = 1;
                                frameNum = frameNum+1;
                            end
                            Letters = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O'];
                            filePD(well_num).Exp = [Letters(conditionNum),num2str(videoNum),'_',conditions{conditionNum}];
                            %%---------------------------------------------
                            WellSnapshot                  = myImageMatrix;
                            save(fullfile(filepath,[info.filename,'_MOVfolder'],[filePD(well_num).Exp,'_r',num2str(1),'.mat']),'WellSnapshot','-v7.3');
                            %%---------------------------------------------
                            videoNum = videoNum+1;
                            well_num = well_num+1;
                        end
                    end
                end
        conditionNum = conditionNum+1;
        end
        %%-----------------------------------------------------------------
        %%-----------------------------------------------------------------
        imagesc(myImageMatrix{1},'parent', Layout.axesImageOne); set(Layout.axesImageOne  , 'XTick'   ,[],'YTick',[]);
        imHeight                 = size(myImageMatrix{1},1);
        imWidth                  = size(myImageMatrix{1},2);   
        info.worm_criteria       = (1*0.08) *((min(imHeight,imWidth) /7).^2);
        hold(Layout.axesImageOne, 'on');axis(Layout.axesImageOne,'equal');
        set(Layout.command_line, 'string', '>> Click Process');
        %%-----------------------------------------------------------------
        [Layout, info] = WellRoundSelection(length(snapshotsFinder{1}), Layout, info, filePD);
        %%-----------------------------------------------------------------
        ss=0;
        clear tmp
        for i=1:length(snapshotsFinder)
        for j=1:length(snapshotsFinder{i})
        for k=1:length(snapshotsFinder{i}{j})
                ss=ss+1;
                tmp(ss,3)= i;
                tmp(ss,2)= j;
                tmp(ss,1)= k;
        end
        end
        end
        tmp = sortrows(tmp);
        info.ID2ind_list(:,1)= tmp(:,3);
        info.ID2ind_list(:,2)= tmp(:,2);
        info.ID2ind_list(:,3)= tmp(:,1);
end