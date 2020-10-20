
function [Layout, info] = WellRoundSelection(roundNUM, Layout, info, filePD)
    for well_ID = 1:length(filePD) 
    Letters = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O'];
        if        strcmp(info.format,'nd2')==1
        %%-----------------------------------------------------------------
                for ss=1:length(Letters)
                    if strcmp(filePD(well_ID).Exp(1),Letters(ss))==1
                        row(well_ID)=ss;
                        col(well_ID)= str2num(filePD(well_ID).Exp(2));
                    end
                end
        %%-----------------------------------------------------------------
        elseif    strcmp(info.format,'vid')==1
                NameSplit       = strsplit(filePD(well_ID).Exp,'_');
                for ss=1:length(Letters)
                    if strcmp(NameSplit{1}(1),Letters(ss))==1
                        row(well_ID)= ss;
                        col(well_ID)= str2num(NameSplit{1}(2:end));
                    end
                end
                condition_well_ID{well_ID} = NameSplit{1};
                condition_name_vid{row(well_ID)}     = NameSplit{2};
                
        end
        %%-----------------------------------------------------------------
    end
    %%---------------------------------------------------------------------   
    for well_ID = 1:length(filePD)
        if    strcmp(info.format,'vid')==1
                if col(well_ID)>9
                    set(Layout.WellButton{well_ID},'String',condition_well_ID{well_ID},'position',[65+40*(col(well_ID)-1)+10*(col(well_ID)-10),5+17*(max(row)-row(well_ID)),45,13],'visible','on');
                else
                    set(Layout.WellButton{well_ID},'String',condition_well_ID{well_ID},'position',[65+40*(col(well_ID)-1),5+17*(max(row)-row(well_ID)),35,13],'visible','on');
                end
        else
            if col(well_ID)>9
                set(Layout.WellButton{well_ID},'String',filePD(well_ID).Exp,'position',[65+40*(col(well_ID)-1)+10*(col(well_ID)-10),5+17*(max(row)-row(well_ID)),45,13],'visible','on');
            else
                set(Layout.WellButton{well_ID},'String',filePD(well_ID).Exp,'Position',[65+40*(col(well_ID)-1),5+17*(max(row)-row(well_ID)),35,13],'visible','on');
            end
        end        
    end
    %%-----------------------------------------
    if ~isfield(info, 'AnalayzeTheseWells')
        for well_ID = 1:length(filePD)
            info.AnalayzeTheseWells{well_ID} = true;
            set(Layout.WellButton{well_ID},'Value',1);
        end
    else
        for well_ID = 1:length(filePD)
            set(Layout.WellButton{well_ID},'Value',info.AnalayzeTheseWells{well_ID});
        end
    end
    %%-----------------------------------------
    if ~isfield(info,'mConditionName')
            if    strcmp(info.format,'vid')==1
                for condition_num =1:max(row)
                    set(Layout.ConditionName{condition_num},'string', condition_name_vid{condition_num},'position', [4,5+17*(max(row)-condition_num),59,15],'visible','on');
                    info.mConditionName{condition_num} = condition_name_vid{condition_num};
                end
            else
                for condition_num =1:max(row)
                    set(Layout.ConditionName{condition_num},'string', ['Condition',num2str(condition_num)],'position', [4,5+17*(max(row)-condition_num),59,15],'visible','on');
                    info.mConditionName{condition_num} =  ['Condition',num2str(condition_num)]; 
                end
            end
    else 
            for condition_num =1:max(row)
                set(Layout.ConditionName{condition_num},'string',info.mConditionName{condition_num},'position',[4,5+17*(max(row)-condition_num),59,15],'visible','on');
            end
    end
    %%---------------------------------------------------------------------
    if isfield(info,'AnalayzeTheseRounds')
        for k=1:roundNUM
            set(Layout.RoundButton{k},'String',['Ro',num2str(k)],'Value',info.AnalayzeTheseRounds{k},'position',[5+50*(k-1),5,45,15],'visible','on');
        end
    else
        for k=1:roundNUM
            info.AnalayzeTheseRounds{k} = true;
        end
    end
    %%---------------------------------------------------------------------
    if max(col)>9
        xx  = 65+40*(max(col))+(max(col)-9)*10;
    else
        xx  = 65+40*(max(col));
    end
        yy  = 17*(max(row));
        xx2 = 5+50*(roundNUM);

    Layout.Wells_CheckBox.Position = [Layout.figTwoDim(1)+Layout.defaultImSize(1)-xx, Layout.mainPanel_dim(4)-Layout.defaultImSize(2)-10-yy, xx, yy+5];
    Layout.Round_CheckBox.Position = [Layout.figOneDim(1)+Layout.defaultImSize(1)-xx2, Layout.mainPanel_dim(4)-Layout.defaultImSize(2)-75,xx2,25];
%%-------------------------------------------------------------------------
%%-------------------------------------------------------------------------
end