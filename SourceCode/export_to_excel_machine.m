function export_to_excel_machine(info, filePD)
if isfield(filePD(1).worms{1}{1}, 'WormCat')
%% ------------------------------------------------------------------------
    [file,path]     = uigetfile('*.xlsx','open template excel file');
    copyfile(fullfile(path,file),'DataOutput.xlsx');
    %%---------------------------------------------------------------------
    Letters = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O'];
    for aa=1:length(info.ConditionName)
            for CaseID=1:length(filePD)
                    if strcmp(filePD(CaseID).Exp(1),Letters(aa))==1  
                        bb                       = str2num(filePD(CaseID).Exp(2));
                        
                        for RoundID = 1:length(filePD(CaseID).worms) 
                            SplitRoundCurl{aa}{RoundID}(bb)        = 0; 
                            SplitRoundTotal{aa}{RoundID}(bb)       = 0; 
                            SplitRoundNearCurl{aa}{RoundID}(bb)    = 0;
                            
                         for SnapID = 1:length(filePD(CaseID).worms{RoundID})
                                for k  = 1:length(filePD(CaseID).worms{RoundID}{SnapID}.worm_bc)
                                    %%-------------------------------------
                                    if     (strcmp(filePD(CaseID).worms{RoundID}{SnapID}.WormCat{k},'Curled')) || (strcmp(filePD(CaseID).worms{RoundID}{SnapID}.WormCat{k},'HalfCurled'))
                                        SplitRoundCurl{aa}{RoundID}(bb)= SplitRoundCurl{aa}{RoundID}(bb)+1; 
                                        
                                    elseif strcmp(filePD(CaseID).worms{RoundID}{SnapID}.WormCat{k},'NearCurled')
                                        SplitRoundNearCurl{aa}{RoundID}(bb)=SplitRoundNearCurl{aa}{RoundID}(bb)+1; 
                                    end
                                    %%-------------------------------------
                                    if    ~strcmp(filePD(CaseID).worms{RoundID}{SnapID}.WormCat{k},'Censored')  , SplitRoundTotal{aa}{RoundID}(bb)=SplitRoundTotal{aa}{RoundID}(bb)+1;end
                                    %%-------------------------------------
                                end
                         end
                         end
                    end

            end
    end
    %%-------------------------------------------------------------
    colList       = [2,5,8,11,14,17,20,23,26,29,32,35];
    curlRowList   = {'C','D','E','F','G','H','I','J','K','L'};
    NcurlRowList  = {'AD','AE','AF','AG','AH','AI','AJ','AK','AL','AM'};
    %%-------------------------------------------------------------
    CurlMatrix(1:476,1:10)       = {''};
    NearCurlMatrix(1:476,1:10)   = {''};

    for aa    = 1:12    
    for round = 1:12      
    for bb    = 1:10

        CurlMatrix((40*(aa-1))+1,bb)                      =  {strcat('W',num2str(bb))};
        CurlMatrix((40*(aa-1))+colList(round),bb)         =  {''}; 
        CurlMatrix(1+(40*(aa-1))+colList(round),bb)       =  {''}; 

        NearCurlMatrix((40*(aa-1))+1,bb)                  =  {strcat('W',num2str(bb))};
        NearCurlMatrix((40*(aa-1))+colList(round),bb)     =  {''}; 
        NearCurlMatrix(1+(40*(aa-1))+colList(round),bb)   =  {''}; 
    end
    end
    end
    xlswrite('DataOutput.xlsx',CurlMatrix      ,'Sheet1', 'C1:L476' );
    xlswrite('DataOutput.xlsx',NearCurlMatrix  ,'Sheet1', 'AD1:AM476' );
    
    %%-------------------------------------------------------------
    NameCellMatrix(1:476,1)       = {''};
    xlswrite('DataOutput.xlsx',NameCellMatrix      ,'Sheet1', 'A1:A476' );
    %%-------------------------------------------------------------
    clear CurlMatrix NearCurlMatrix
    CurlMatrix(1:476,1:10)       = {''};
    NearCurlMatrix(1:476,1:10)   = {''};

    for aa = 1:length(SplitRoundTotal)     
    for round = 1:length(SplitRoundTotal{aa})      
    for bb = 1:length(SplitRoundTotal{aa}{round})

        CurlMatrix((40*(aa-1))+1,bb)                      =  {strcat('W',num2str(bb))};
        CurlMatrix((40*(aa-1))+colList(round),bb)         =  {num2str(SplitRoundCurl{aa}{round}(bb))}; 
        CurlMatrix(1+(40*(aa-1))+colList(round),bb)       =  {num2str(SplitRoundTotal{aa}{round}(bb))}; 

        NearCurlMatrix((40*(aa-1))+1,bb)                  =  {strcat('W',num2str(bb))};
        NearCurlMatrix((40*(aa-1))+colList(round),bb)     =  {num2str(SplitRoundNearCurl{aa}{round}(bb))}; 
        NearCurlMatrix(1+(40*(aa-1))+colList(round),bb)   =  {num2str(SplitRoundTotal{aa}{round}(bb))}; 

    end
    end
    end
    xlswrite('DataOutput.xlsx',CurlMatrix      ,'Sheet1', 'C1:L476' );
    xlswrite('DataOutput.xlsx',NearCurlMatrix  ,'Sheet1', 'AD1:AM476' );
    %%-------------------------------------------------------------  
    NameCellMatrix(1:476,1)       = {''};
    for aa=1:length(info.ConditionName)
        NameCellMatrix((40*(aa-1))+1,1)                      =  {info.ConditionName{aa}.String};
    end
    xlswrite('DataOutput.xlsx',NameCellMatrix      ,'Sheet1', 'A1:A476' );
%%-------------------------------------------------------------------------
end
end