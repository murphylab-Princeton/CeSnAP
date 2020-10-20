function [Layout, info, filePD, ResultPD]=load_nd2_files(Layout, info, filePD, ResultPD)
    %% ---------------------------------------------------------------------
    nd2Folder           = uigetdir;
    [Layout, info]      = switch_to_Process_layout(Layout, info);
    dirSplit            = strsplit(nd2Folder,'\');
    filepath            = fullfile(dirSplit{1:(end-1)});
    info.filename       = dirSplit{end};
    info.format         = 'nd2';
    set(Layout.TargetFileN, 'string',info.filename);
    set(Layout.command_line ,'string','>> Converting images');drawnow;
    nd2NameList = dir(fullfile(filepath,info.filename,'*.nd2'));
    for round=1:length(nd2NameList)
        RoundName{round} = nd2NameList(round).name;
    end
    %%---------------------------------------------------------------------
    mkdir([info.filename,'_nd2Folder'])
    for roundID=1:length(RoundName)
        addpath(genpath('bfmatlab/'));
        clear tmpImages WellName
        [tmpImages,WellName] = bfopen_CeSnAP(fullfile(filepath,info.filename,RoundName{roundID}));
        
            for caseID=1:length(tmpImages)
                    for snapshotID = 1:length(tmpImages{caseID})
                            if length(size(tmpImages{caseID}{snapshotID}))==3, tmpImages{caseID}{snapshotID} = rgb2gray(tmpImages{caseID}{snapshotID});end
                            if roundID==1 && caseID==1 && snapshotID==1
                                first_snapshots = tmpImages{caseID}{snapshotID};  
                            end  
                            snapshotsFinder{caseID}{roundID}{snapshotID} = true;
                    end
                    clear WellSnapshot
                    filePD(caseID).Exp  = WellName{caseID};
                    WellSnapshot        = tmpImages{caseID};
                    save(fullfile(filepath,[info.filename,'_nd2Folder'],[filePD(caseID).Exp,'_','r',num2str(roundID),'.mat']),'WellSnapshot','-v7.3');   
            end
    end
    clear WellSnapshot
    %%---------------------------------------------------------------------
    imagesc(first_snapshots,'parent', Layout.axesImageOne);set(Layout.axesImageOne  , 'XTick'   ,[],'YTick',[]);
    imHeight                 = size(first_snapshots,1);
    imWidth                  = size(first_snapshots,2);   
    info.worm_criteria       = (1*0.08) *((min(imHeight,imWidth) /7).^2);
    hold(Layout.axesImageOne, 'on');  axis(Layout.axesImageOne,'equal');
    set(Layout.command_line, 'string', '>> locate well');
    %%---------------------------------------------------------------------
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
    %%---------------------------------------------------------------------
    [Layout, info] = WellRoundSelection(length(snapshotsFinder{1}), Layout, info, filePD);
    %%---------------------------------------------------------------------
end