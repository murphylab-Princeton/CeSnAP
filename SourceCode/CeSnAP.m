%% -CeSnAP- C. elegans Snapshot Analysis Platform
% Copyright (c) 2020 Princeton 
 
% Murphy, C. T., Sohrabi, S., Mor, D. E., Kaletsky, R., Keyes, W., (2019). 
% Novel high-throughput screening method for Parkinson's phenotypes using C. elegans. US Provisional Patent Application No. 62929166, filed 01/11/2019.
 
% Permission is hereby granted to any person obtaining a copy of this software and associated documentation files,
% including the rights to use, copy, modify, and merge the Software, and to permit persons to whom the Software is 
% furnished to do so, only for non-profit academic research purposes and subject to the following conditions:

% Use for Commercial Purposes is expressly prohibited, including the sale, lease, license, or other transfer of the
% software to a for-profit organization. COMMERCIAL PURPOSES shall also include uses of the software by any organization,
% to perform contract research, to screen compound libraries, to produce or manufacture products for general sale, or
% to conduct research activities that result in any sale, lease, license, or transfer of the Software to a for-profit.
% For use for Commercial Purposes please contact the Office of Technology Licensing, Princeton University at tzodikov@princeton.edu

% This copyright notice and permission does NOT grant any rights or licenses, express or implied, in any patents rights
% of any party, including the copyright holder.
% Neither the name of the copyright holder nor the names of its contributors may be used for promotional purposes, or 
% to imply affiliation or endorsement, without prior written permission. The above copyright notice and this permission
% notice shall be included in all copies or substantial portions of the Software.
 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
% WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
% COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
% CeSnAP uses Bio-Formats MATLAB scripts for reading *.nd2 files. User can download Bio-Formats from following link:
% https://docs.openmicroscopy.org/bio-formats/5.3.4/users/matlab/index.html. 


function CeSnAP
clear
Layout   = [];
info     = [];
filePD   = [];
ResultPD = [];
%%-------------------------------------------------------------------------
%%----------------------------------------------------------- initial Setup
info                          = initInfo(info);
[Layout,info,filePD,ResultPD] = initLayout(Layout,info, filePD, ResultPD);
[Layout, info]                = switch_to_old_method(Layout,info);
set(Layout.btnAddND2       , 'callback', @load_ND2s);
set(Layout.addImageSeq     , 'callback', @Load30Vid);
set(Layout.btnExport       , 'callback', @exportexcel);
set(Layout.btnClose        , 'callback', @closeWindow);
set(Layout.Savebtn         , 'callback', @SaveProcessed);
set(Layout.OpenDatabtn     , 'callback', @OpenSaved);
set(Layout.btnProcess      , 'callback', @processParkinson);
set(Layout.ProcessAgn      , 'callback', @processParkinson);
set(Layout.Processall      , 'callback', @processParkinson);
set(Layout.AnalyzeAll      , 'callback', @AnalyzeParkinson);
set(Layout.runMachine      , 'callback', @StartNeuralMachine);
set(Layout.runMachineAgn   , 'callback', @StartNeuralMachine);
set(Layout.runMachineall   , 'callback', @StartNeuralMachine);
set(Layout.RadioMain       , 'SelectionChangedFcn',@MethodSelection);
set(Layout.RadioB          , 'SelectionChangedFcn',@RadioBSelection);
set(Layout.RadioC          , 'SelectionChangedFcn',@ModeSelection);
set(Layout.previousDemoShow, 'callback', @preprocess);
set(Layout.nextDemoShow    , 'callback', @nxtprocess);
set(Layout.previousmontage , 'callback', @premontage);
set(Layout.nextmontage     , 'callback', @nxtmontage);
set(Layout.lengthArea      , 'callback', @plotArea);
set(Layout.loadTrain       , 'callback', @uploadBlobs);
set(Layout.loadNet         , 'callback', @loadNetwork);
set(Layout.AnalyzeNet      , 'callback', @analyzeMnet);
set(Layout.startTrain      , 'callback', @startTraining);
set(Layout.saveSnapOld     , 'callback', @saveSegmentSnaps);
set(Layout.saveSnapSmart   , 'callback', @saveMLsnaps);
set(Layout.CNN_Machine     , 'callback', @loadCNN_snapMachine);
for im=1:8, for jm=1:8, set(Layout.confButton{im}{jm},'Callback',{@ConfusionButtonCallback,im,jm});end;end
for well_ID=1:96, set(Layout.WellButton{well_ID},'Callback',{@WellButtonCallback,well_ID}); end
for k=1:15,       set(Layout.RoundButton{k},'Callback',{@RoundButtonCallback,k});end 
%%-------------------------------------------------------------------------
set(Layout.RadioMain       , 'SelectedObject',Layout.OldMethod); 
set(Layout.RadioB          , 'SelectedObject',Layout.BlackBackG);
set(Layout.RadioC          , 'SelectedObject',Layout.Prcss); 
%%-------------------------------------------------------------------------
set(Layout.mainFigure      , 'visible' , 'on', 'WindowButtonDownFcn', @downMouse);
%%-------------------------------------------------------------------------
%%-------------------------------------------------------- loading nd2 file
function load_ND2s(hObject,eventdata) %#ok<INUSD> 
    filePD = []; ResultPD = [];
    [Layout, info, filePD, ResultPD] = load_nd2_files(Layout, info, filePD, ResultPD);
    save([info.filename '.mat'],'info','filePD','ResultPD','-v7.3');
end
%%-------------------------------------------------------------------------
%%---------------------------------------------------- loading Image Folder
function Load30Vid(hObject,eventdata) %#ok<INUSD>
     filePD = []; ResultPD = [];
    [Layout,info, filePD, ResultPD] = load_30s_videos(Layout, info, filePD, ResultPD);
     save([info.filename '.mat'],'info','filePD','ResultPD','-v7.3');
end
%%-------------------------------------------------------------------------
%%---------------------------------------------- upload images for training
function uploadBlobs(hObject,eventdata) %#ok<INUSD>
    filePD = []; ResultPD = [];
    info.montageShownID = 1;
    [Layout,info, filePD, ResultPD] = uploadImageDatabase(Layout, info, filePD, ResultPD);
    [Layout,info, ResultPD] = plotTrainMontage(Layout, info, filePD, ResultPD);  
end
%%-------------------------------------------------------------------------
%%------------------------------------------------ load CNN for snapMachine
function loadCNN_snapMachine(hObject,eventdata) %#ok<INUSD>
    
    [mDir,~]     = uigetfile('*.mat','open *.mat file');
    set(Layout.command_line ,'string','>> Loading Network');drawnow;
    CNN =load(mDir);
    dirSplit = strsplit(mDir,'\');
    set(Layout.command_line ,'string',['Network:',dirSplit{end},'>>Start!']);drawnow;
    info.neuralNet = CNN.salmanNet;
end
%%-------------------------------------------------------------------------
%%---------------------------------------------------------------- load CNN
function loadNetwork(hObject,eventdata) %#ok<INUSD>
    [Layout,filePD] = openCNN_file(Layout, filePD);
    [Layout,info,filePD,ResultPD] = loadCNN_forAnalysis(Layout, info, filePD, ResultPD);
    [Layout,info, ResultPD] = plotTrainMontage(Layout, info, filePD, ResultPD); 
end
%%-------------------------------------------------------------------------
%%------------------------------------------------- analyze blobs using CNN
function analyzeMnet(hObject,eventdata) %#ok<INUSD>
    info.montageShownID = 1;
    [Layout,info,filePD, ResultPD] = useCNN_to_analyzeBlobs(Layout, info, filePD, ResultPD);
    [Layout,info, ResultPD] = plotTrainMontage(Layout, info, filePD, ResultPD); 
end
%%-------------------------------------------------------------------------
%%------------------------------------------------------- strat ML training
function startTraining(hObject,eventdata) %#ok<INUSD>
    [Layout,info, filePD, ResultPD] = initiateTrainingNewCNN(Layout, info, filePD, ResultPD);
    filePD.neuralNet = ResultPD.salmanNet;
    salmanNet = ResultPD.salmanNet;
    save([info.filename '.mat'],'salmanNet','-v7.3');
    %%---------------------
    [Layout,info,filePD,ResultPD] = loadCNN_forAnalysis(Layout, info, filePD, ResultPD);
    plotconfusion(filePD.my_imds.Labels,ResultPD.myClassifyResults);
    info.montageShownID = 1;
    [Layout,info, ResultPD] = plotTrainMontage(Layout, info, filePD, ResultPD); 
    set(Layout.command_line ,'string','>> Training Complete & Saved!');drawnow;
end
%%-------------------------------------------------------------------------
%%--------------------------------------------------- strat segmented blobs
function saveSegmentSnaps(hObject,eventdata) %#ok<INUSD>
   saveSegmented_snapTiles(Layout, info, filePD, ResultPD)
end
%%-------------------------------------------------------------------------
%%---------------------------------------------------------- strat ML blobs
function saveMLsnaps(hObject,eventdata) %#ok<INUSD>
   saveML_snapTiles(Layout, info, filePD)
end
%%-------------------------------------------------------------------------
%%--------------------------------------------------------- Open saved data
function OpenSaved(hObject,eventdata) %#ok<INUSD>
    info = []; filePD=[]; ResultPD=[];
    [Layout,info,filePD,ResultPD] = load_saved_mat(Layout, info, filePD, ResultPD);
end
%%-------------------------------------------------------------------------
%%-------------------------------------------------------- save data to mat
function SaveProcessed(hObject,eventdata) %#ok<INUSD>
    for ii=1:length(info.mConditionName),info.mConditionName{ii} =Layout.ConditionName{ii}.String; end
    save([info.filename '.mat'],'info','filePD','ResultPD','-v7.3');
end
%%-------------------------------------------------------------------------
%%----------------------------------------------- black or white background
function RadioBSelection(~,eventdata)
    info.background = eventdata.NewValue.String;
end
%%-------------------------------------------------------------------------
%%---------------------------------------- detecting objects from snapshots
function processParkinson(hObject,eventdata)%#ok<INUSD>
    info = update_info_whenRunning(Layout, info);
    Layout = switch_to_Startprocessing_Layout(Layout);
    if       strcmp(hObject.String,'Process Again'), info.CurrentProcessID = info.CurrentProcessID-1;  nbOfFrames=1;
    elseif   strcmp(hObject.String,'Process Next'),  nbOfFrames=1; 
    elseif   strcmp(hObject.String,'Process All')   
                nbOfFrames=length(info.ID2ind_list(:,1)); 
                info.CurrentProcessID=0;                     ResultPD = [];
                sally = fieldnames(filePD);                trigger = false;
                for i=1:length(sally), if strcmp(sally{i},'worms')==1, trigger = true; end;end
                if trigger==true, filePD=rmfield(filePD,'worms');end
    end
    %%---------------------------------------------------------------------          
    for iter = 1:nbOfFrames   
        info.CurrentProcessID = info.CurrentProcessID +1;
        CaseID = info.ID2ind_list(info.CurrentProcessID,1);
        RoundID = info.ID2ind_list(info.CurrentProcessID,2);
        SnapID = info.ID2ind_list(info.CurrentProcessID,3);
        set(Layout.command_line,'string',['>> Processing #',num2str(iter),'/',num2str(nbOfFrames)]);drawnow;
        [Layout,filePD] = Segment_Image(CaseID,RoundID,SnapID,Layout,info,filePD);
    end
    set(Layout.command_line,'string','>>> ... Done ');
    %%---------------------------------------------------------------------
    if strcmp(hObject.String,'Process All') 
        set(Layout.AnalyzeAll  , 'enable'  , 'on');
        save([info.filename '.mat'],'info','filePD','ResultPD','-v7.3');
    end
    set(Layout.command_line ,'string','>>> ... Analyze');
    Layout = switch_to_Endprocessing_Layout(Layout);
end
%%-------------------------------------------------------------------------
%%--------------------------------------------------- start the SnapMachine
function StartNeuralMachine(hObject,eventdata)%#ok<INUSD>
    info = update_info_whenRunning(Layout, info);
    Layout = switch_to_Startprocessing_Layout(Layout);
    if       strcmp(hObject.String,'Run Again'), info.CurrentProcessID = info.CurrentProcessID-1;  nbOfFrames=1;
    elseif   strcmp(hObject.String,'Run Next'),  nbOfFrames=1; 
    elseif   strcmp(hObject.String,'Run All')   
                nbOfFrames=length(info.ID2ind_list(:,1)); 
                info.CurrentProcessID=0;                     ResultPD = [];
                sally = fieldnames(filePD);                trigger = false;
                for i=1:length(sally), if strcmp(sally{i},'worms')==1, trigger = true; end;end
                if trigger==true, filePD=rmfield(filePD,'worms');end
    end
    %%---------------------------------------------------------------------        
    for iter = 1:nbOfFrames   
        info.CurrentProcessID = info.CurrentProcessID +1;
        CaseID = info.ID2ind_list(info.CurrentProcessID,1);
        RoundID = info.ID2ind_list(info.CurrentProcessID,2);
        SnapID = info.ID2ind_list(info.CurrentProcessID,3);
        set(Layout.command_line,'string',['>> Running #',num2str(iter),'/',num2str(nbOfFrames)]);drawnow;
        [Layout,info,filePD] = StartSnapMachine(CaseID,RoundID,SnapID,Layout,info,filePD,info.neuralNet);
    end
    set(Layout.command_line,'string','>>> ... Done ');
    %%---------------------------------------------------------------------
    if strcmp(hObject.String,'Run All') 
        [info,ResultPD] = createResultMontageForMachine(Layout,info, filePD);
        [Layout, info] = switch_to_Analyze_layout(Layout, info, ResultPD);
        [Layout, info, ResultPD] = plotResult(Layout, info, filePD, ResultPD);
        save([info.filename '.mat'],'filePD','info','ResultPD','-v7.3');
    end
    set(Layout.command_line   ,'string','>>> ...Plot');
    Layout = switch_to_Endprocessing_Layout(Layout);
end
%%-------------------------------------------------------------------------
%%---------------------------------------------- analyzing detected objects
function AnalyzeParkinson(hObject,eventdata) %#ok<INUSD>       try
        info = update_info_whenRunning(Layout, info);   
        set(Layout.command_line,'string','>> Analyzing ');drawnow;
        info.montageShownID = 1;
        [Layout,ResultPD] = analyze_Segments(Layout,info,filePD,ResultPD);
        set(Layout.command_line,'string','>>> Done Analyzing ');   
        [Layout, info, ResultPD]  = plotResult(Layout, info, filePD, ResultPD);  
end
%%-------------------------------------------------------------------------
%%--------------------------------------------- Save all Data in excel file
function exportexcel(hObject,eventdata)%#ok<INUSD>
   
    if strcmp(info.analyzeMethod,'OldMethod')
         export_to_excel_threshold(info, filePD, ResultPD)
    elseif strcmp(info.analyzeMethod,'SnapMachine')
        export_to_excel_machine_header(info, filePD)
    end
    set(Layout.command_line,'string','>>> Saved_to_XLSX'); 
end
%%-------------------------------------------------------------------------
%%----------------------------------------------------------- Close program
function closeWindow(hObject,eventdata)%#ok<INUSD>
    set(Layout.mainFigure,'Visible','off');
    delete(Layout.mainFigure);
end
%%-------------------------------------------------------------------------
%%----------------------------------------------------------- Close program
function plotArea(hObject,eventdata)%#ok<INUSD>
    [Layout, info] = switch_to_Plot_layout(Layout, info);
    Layout = plotAreaLengthFigure(Layout, info, filePD);
end
%%-------------------------------------------------------------------------
%%----------------------------------------- Changing the automated decision
function downMouse(hObject,eventdata)%#ok<INUSD>
    
    if strcmp(Layout.axesImageOne.Visible,'on')  &&  get(Layout.Well, 'Value')==1
        [Layout,info,filePD, ResultPD] = click_action_wellFinder(Layout,info, filePD, ResultPD, hObject);
    elseif ( strcmp (Layout.axesImageFour.Visible,'on')  &&  strcmp(info.analyzeMethod,'OldMethod'))
        [Layout,info,filePD, ResultPD] = click_action_threshold(Layout,info, filePD, ResultPD, hObject);
    elseif (strcmp(Layout.axesImageSeven.Visible,'on') &&  strcmp(info.analyzeMethod,'SnapMachine'))
        [Layout,info,filePD, ResultPD] = click_action_Machine(Layout,info, filePD, ResultPD, hObject);
    elseif strcmp(info.analyzeMethod,'train')
        [Layout,info,filePD, ResultPD] = click_action_Train(Layout,info, filePD, ResultPD, hObject);
    end
end
%%-------------------------------------------------------------------------
%%-------------------------------- toggle between process, analyze and plot
function ModeSelection(~,eventdata) 
    modeSelction = eventdata.NewValue.String;
    if strcmp(modeSelction,'Prcss')
             [Layout, info] = switch_to_Process_layout(Layout, info);
             if ~isempty(filePD), Layout = plotProcess(Layout, info, filePD, ResultPD); end     
    elseif strcmp(modeSelction,'Anlyz')
             [Layout, info] = switch_to_Analyze_layout(Layout, info, ResultPD);
             if ~isempty(ResultPD), [Layout, info, ResultPD]  = plotResult(Layout, info, filePD, ResultPD); end     
    elseif strcmp(modeSelction,'Plot')
             [Layout, info] = switch_to_Plot_layout(Layout, info);
             if ~isempty(ResultPD), Layout = plotFigures(Layout, info, filePD, ResultPD) ; end   
    end
end
%%-------------------------------------------------------------------------
%%--------------------------------------------------- Method Mode of CeSnAP
function MethodSelection(~,eventdata) 
    
    if     strcmp(eventdata.NewValue.String,'Sgmnt'), info.analyzeMethod='OldMethod';
    elseif strcmp(eventdata.NewValue.String,'Train'), info.analyzeMethod='train';
    elseif strcmp(eventdata.NewValue.String,'Qntfy'), info.analyzeMethod='SnapMachine'; 
    end

    if strcmp(info.analyzeMethod,'SnapMachine')
        [Layout, info] = switch_to_ML_method(Layout,info);      
    elseif strcmp(info.analyzeMethod,'OldMethod')
        [Layout, info] = switch_to_old_method(Layout,info);   
    elseif strcmp(info.analyzeMethod,'train')
        [Layout, info] = switch_to_training(Layout, info);
        [Layout, info] = switch_to_train_layout(Layout, info, ResultPD);
    end
end
%%-------------------------------------------------------------------------
%%---------------------------------- Moving to next/previous montage images
function nxtmontage(hObject,eventdata)%#ok<INUSD>
    if info.montageShownID~=ResultPD.MaxMontageSplit
        info.montageShownID = info.montageShownID + 1;
        [Layout, info, ResultPD]  = plotResult(Layout, info, filePD, ResultPD); 
    else
        info.montageShownID = 1;
        [Layout, info, ResultPD]  = plotResult(Layout, info, filePD, ResultPD); 
    end  
end
function premontage(hObject,eventdata)%#ok<INUSD>
    if info.montageShownID~=1
        info.montageShownID = info.montageShownID - 1;
        [Layout, info, ResultPD]  = plotResult(Layout, info, filePD, ResultPD); 
    else
        info.montageShownID = ResultPD.MaxMontageSplit;
        [Layout, info, ResultPD]  = plotResult(Layout, info, filePD, ResultPD); 
    end  
end
%%-------------------------------------------------------------------------
%%---------------------------------------- Moving to next/previous snapshot
function nxtprocess(hObject,eventdata)%#ok<INUSD>
    if info.CurrentProcessID ~=length(info.ID2ind_list(:,1))
        info.CurrentProcessID = info.CurrentProcessID + 1;
        Layout = plotProcess(Layout, info, filePD, ResultPD);
    else
        info.CurrentProcessID = 1;
        Layout = plotProcess(Layout, info, filePD, ResultPD);
    end  
end
function preprocess(hObject,eventdata)%#ok<INUSD>
    if info.CurrentProcessID ~=1
        info.CurrentProcessID = info.CurrentProcessID - 1;
        Layout = plotProcess(Layout, info, filePD, ResultPD);
    else
        info.CurrentProcessID = length(info.ID2ind_list(:,1));
        Layout = plotProcess(Layout, info, filePD, ResultPD);
    end 
end
%%-------------------------------------------------------------------------
%%-------------------------------------------------------------------------
function ConfusionButtonCallback(hObject,~, iii,jjj) 
    if hObject.Value==0
        info.confusionCheckMatrix(iii,jjj)=false;
    else
        info.confusionCheckMatrix(iii,jjj)=true;
    end
end
%%-------------------------------------------------------------------------
%%-------------------------------------------------------------------------
function RoundButtonCallback(hObject,~, RoundNum) 
    if hObject.Value==0
        info.AnalayzeTheseRounds{RoundNum} = false;
    else
        info.AnalayzeTheseRounds{RoundNum} = true;
    end
end
function WellButtonCallback(hObject,~, WellNum)
    if hObject.Value==0
        info.AnalayzeTheseWells{WellNum} = false;
    else
        info.AnalayzeTheseWells{WellNum} = true;
    end
end
%%-------------------------------------------------------------------------
waitfor(Layout.mainFigure  , 'BeingDeleted','on');
%%-------------------------------------------------------------------------
end


