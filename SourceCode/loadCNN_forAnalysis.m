function [Layout,info,filePD,ResultPD] = loadCNN_forAnalysis(Layout, info, filePD, ResultPD)
if isfield(filePD, 'my_imds')
%% ------------------------------------------------------------------------ 
    %%--------------------------------------------------------------------- 
    [ResultPD.myClassifyResults, ResultPD.mProbScore]= classify(filePD.neuralNet,transform(filePD.my_imds,@(x) imresize(x,[128 128])));
    ResultPD.CNN_labels = categorical(categories(ResultPD.myClassifyResults));
    %%---------------------------------------------------------------------
    checkBoxDim = 15;
    percWidth   = 25;
    mYincrement   = (Layout.confusionBox.Position(4)-2*Layout.textHight)    /length(filePD.mLabelArray);
    mXincrement   = (Layout.confusionBox.Position(3)-Layout.mLabelWidth-checkBoxDim)  /length(ResultPD.CNN_labels);
    for i=1:length(filePD.mLabelArray)
        mStext = char(filePD.mLabelArray(i));
        set(Layout.mLabelTag{i}, 'string',mStext(1:3),'position',[1,mYincrement*(i-0.5),Layout.mLabelWidth,Layout.textHight],'visible','on');      
    end
    for j=1:length(ResultPD.CNN_labels)
        mStext = char(ResultPD.CNN_labels(j));
        set(Layout.mCNNTag{j}, 'string',mStext(1:3),'position',[Layout.mLabelWidth+mXincrement*(j-0.5),Layout.confusionBox.Position(4)-Layout.textHight,Layout.CNNlabelWidth,Layout.textHight],'visible','on');      
    end
    Y_increment = (Layout.confMatrixPanel.Position(4)-checkBoxDim)/(length(filePD.mLabelArray));
    X_increment = (Layout.confMatrixPanel.Position(3)-checkBoxDim)/(length(ResultPD.CNN_labels));
    for i=1:length(filePD.mLabelArray)
        for j=1:length(ResultPD.CNN_labels)
            set(Layout.confButton{i}{j},'Value',0               ,'position',[X_increment*(j-0.5),Y_increment*(i-0.5)            ,checkBoxDim,checkBoxDim],'visible','on');
            set(Layout.confPercent{i}{j},'position',[X_increment*(j-0.5),Y_increment*(i-0.5)-checkBoxDim,percWidth,checkBoxDim],'visible','on'); 
        end
    end
%%-------------------------------------------------------------------------
%%-------------------------------------------------------------------------
%%-------------------------------------------------------------------------
for fL=1:length(filePD.mLabelArray)
    onesMatchedThisTarget = find(filePD.my_imds.Labels==filePD.mLabelArray(fL));
    for sL=1:length(ResultPD.CNN_labels)
        OnesMatchedThisOutput = find(ResultPD.myClassifyResults==ResultPD.CNN_labels(sL));
        ResultPD.posInDatabase{fL}{sL}  = intersect(onesMatchedThisTarget,OnesMatchedThisOutput);
    end
end
%%-------------------------------------------------------------------------
for fL=1:length(filePD.mLabelArray)
    for sL=1:length(ResultPD.CNN_labels)
        percentageDiagnosis(fL,sL) = round(length(ResultPD.posInDatabase{fL}{sL})*1000/length(filePD.my_imds.Labels))/10;
    end
end
for fL=1:length(filePD.mLabelArray)
    for sL=1:length(ResultPD.CNN_labels)
        set(Layout.confPercent{fL}{sL}, 'string',num2str(percentageDiagnosis(fL,sL))); 
    end
end
%%-------------------------------------------------------------------------   
%%-------------------------------------------------------------------------     
end
end



