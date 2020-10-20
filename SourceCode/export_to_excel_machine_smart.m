function export_to_excel_machine_smart(info, filePD)
if isfield(filePD(1).worms{1}{1}, 'WormCat')
%% ------------------------------------------------------------------------
    Letters = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O'];
    for aa=1:length(info.mConditionName)
            for CaseID=1:length(filePD)
                    if strcmp(filePD(CaseID).Exp(1),Letters(aa))==1  
                        bb                       = str2num(filePD(CaseID).Exp(2));
                        
                        for RoundID = 1:length(filePD(CaseID).worms) 
                            SplitRoundCoil{aa}{RoundID}(bb)        = 0;
                            SplitRoundCurl{aa}{RoundID}(bb)        = 0; 
                            SplitRoundTotal{aa}{RoundID}(bb)       = 0; 
                            SplitRoundNearCurl{aa}{RoundID}(bb)    = 0;
                            
                         for SnapID = 1:length(filePD(CaseID).worms{RoundID})
                                for k  = 1:length(filePD(CaseID).worms{RoundID}{SnapID}.worm_bc)
                                    %%-------------------------------------
                                    if     (strcmp(filePD(CaseID).worms{RoundID}{SnapID}.WormCat{k},'Curled')) 
                                        SplitRoundCoil{aa}{RoundID}(bb)= SplitRoundCoil{aa}{RoundID}(bb)+1; 
                                        
                                    elseif (strcmp(filePD(CaseID).worms{RoundID}{SnapID}.WormCat{k},'HalfCurled'))
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
    %%---------------------------------------------------------------------
    %%---------------------------------------------------------------------
    for aa=1:length(info.mConditionName)
        for CaseID=1:length(filePD)
                if (strcmp(filePD(CaseID).Exp(1),Letters(aa))==1  && info.AnalayzeTheseWells{CaseID}==true) 
                    bb                     = str2num(filePD(CaseID).Exp(2));
                    tmpNumberOfWorms{aa}{bb}        = 0; 
                     for RoundID = 1:length(filePD(CaseID).worms)  
                     if info.AnalayzeTheseRounds{RoundID} == true
                     for SnapID = 1:length(filePD(CaseID).worms{RoundID})
                         %%------------------------------------------------
                         counts_Near_Straight=0;
                         for ww =1:length(filePD(CaseID).worms{RoundID}{SnapID}.WormCat)
                             if strcmp(filePD(CaseID).worms{RoundID}{SnapID}.WormCat{ww},'NearCurled') || strcmp(filePD(CaseID).worms{RoundID}{SnapID}.WormCat{ww},'Straight')  
                                counts_Near_Straight=counts_Near_Straight+1;
                             end   
                         end
                         %%------------------------------------------------
                         if (counts_Near_Straight>tmpNumberOfWorms{aa}{bb})
                             c_w=0;
                             for ww =1:length(filePD(CaseID).worms{RoundID}{SnapID}.WormCat) 
                                 if strcmp(filePD(CaseID).worms{RoundID}{SnapID}.WormCat{ww},'NearCurled') || strcmp(filePD(CaseID).worms{RoundID}{SnapID}.WormCat{ww},'Straight')  
                                        c_w=c_w+1;
                                        primeterWorms{aa}{bb}{c_w}    = filePD(CaseID).worms{RoundID}{SnapID}.perimeter_worm{ww};
                                        areaWorms{aa}{bb}{c_w}        = filePD(CaseID).worms{RoundID}{SnapID}.area_worm{ww};
                                 end
                             end
                             tmpNumberOfWorms{aa}{bb} = counts_Near_Straight;
                         end
                         %%------------------------------------------------
                     end
                     end
                     end
                end
        end
    end
    for aa=1:length(info.mConditionName)
    k=0;
    for bb=1:length(areaWorms{aa})
        for cc=1:length(areaWorms{aa}{bb})
            k=k+1;
            m_lengthWorms{aa}(k)       =  primeterWorms{aa}{bb}{cc}/2;
            m_areaWorms{aa}(k)           =  areaWorms{aa}{bb}{cc};
        end
    end
    end
    %%---------------------------------------------------------------------
    %%---------------------------------------------------------------------    
    myMatrix(1:12,1:43)       = {''};
    roundMatrix(1:12,1:43)    = {''};
    L_matrix(1:12,1:494)     = {''};
    A_matrix(1:12,1:494)     = {''};
    xlswrite('SmartData.xlsx',myMatrix      ,'Sheet1', 'A2:AR13' );
    xlswrite('SmartData.xlsx',roundMatrix   ,'Sheet1', 'A16:AO27' );
    xlswrite('SmartData.xlsx',L_matrix    ,'Sheet1', 'A30:AS41' );
    xlswrite('SmartData.xlsx',A_matrix    ,'Sheet1', 'A44:AS55' );
    %%------------------------------------------------------------- 
    %%------------------------------------------------------------- 
    for aa = 1:length(SplitRoundTotal)          
    for bb = 1:length(SplitRoundTotal{aa}{1})
        
        if        strcmp(info.format,'nd2')==1
            
            myMatrix(aa,1)       =  {info.mConditionName{aa}};
            myMatrix(aa,bb+1)    =  {num2str(SplitRoundCoil{aa}{1}(bb)    +SplitRoundCoil{aa}{2}(bb)    +SplitRoundCoil{aa}{3}(bb))}; 
            myMatrix(aa,bb+11)   =  {num2str(SplitRoundCurl{aa}{1}(bb)    +SplitRoundCurl{aa}{2}(bb)    +SplitRoundCurl{aa}{3}(bb))};
            myMatrix(aa,bb+21)   =  {num2str(SplitRoundNearCurl{aa}{1}(bb)+SplitRoundNearCurl{aa}{2}(bb)+SplitRoundNearCurl{aa}{3}(bb))}; 
            myMatrix(aa,bb+31)   =  {num2str(SplitRoundTotal{aa}{1}(bb)   +SplitRoundTotal{aa}{2}(bb)   +SplitRoundTotal{aa}{3}(bb))};

            myMatrix(aa,43)      = {num2str(mean(m_lengthWorms{aa}))};
            myMatrix(aa,44)      = {num2str(mean(m_areaWorms{aa}))};
            
        elseif    strcmp(info.format,'vid')==1
            
            myMatrix(aa,1)       =  {info.mConditionName{aa}};
            myMatrix(aa,bb+1)    =  {num2str(SplitRoundCoil{aa}{1}(bb))}; 
            myMatrix(aa,bb+11)   =  {num2str(SplitRoundCurl{aa}{1}(bb))};
            myMatrix(aa,bb+21)   =  {num2str(SplitRoundNearCurl{aa}{1}(bb))}; 
            myMatrix(aa,bb+31)   =  {num2str(SplitRoundTotal{aa}{1}(bb))};

            myMatrix(aa,43)      = {num2str(mean(m_lengthWorms{aa}))};
            myMatrix(aa,44)      = {num2str(mean(m_areaWorms{aa}))};
            
            
        end
    end
    end
    xlswrite('SmartData.xlsx',myMatrix      ,'Sheet1', 'A2:AR13' );
    %%-------------------------------------------------------------  
    %%------------------------------------------------------------- 
    for aa = 1:length(SplitRoundTotal)    
        L_matrix(aa,1)       =  {info.mConditionName{aa}};
        for kk=1:length(m_lengthWorms{aa})
            L_matrix(aa,kk+1)   = {num2str(m_lengthWorms{aa}(kk))};
        end
        A_matrix(aa,1)       =  {info.mConditionName{aa}};
        for kk=1:length(m_areaWorms{aa})
            A_matrix(aa,kk+1)   = {num2str(m_areaWorms{aa}(kk))};
        end
    end
    xlswrite('SmartData.xlsx',L_matrix    ,'Sheet1', 'A30:AS41' );
    xlswrite('SmartData.xlsx',A_matrix    ,'Sheet1', 'A44:AS55' );
    %%-------------------------------------------------------------  
    %%------------------------------------------------------------- 
    for aa = 1:length(SplitRoundTotal)  
    for round = 1:length(SplitRoundTotal{aa})  
        
        roundMatrix(aa,1)          =  {info.mConditionName{aa}};
        roundMatrix(aa,round+1)    =  {num2str(sum(SplitRoundCoil{aa}{round}))}; 
        roundMatrix(aa,round+11)   =  {num2str(sum(SplitRoundCurl{aa}{round}))};
        roundMatrix(aa,round+21)   =  {num2str(sum(SplitRoundNearCurl{aa}{round}))}; 
        roundMatrix(aa,round+31)   =  {num2str(sum(SplitRoundTotal{aa}{round}))};
    end
    end
    xlswrite('SmartData.xlsx',roundMatrix  ,'Sheet1', 'A16:AO27' );
    %%-------------------------------------------------------------  
    %%------------------------------------------------------------- 
%%-------------------------------------------------------------------------
end
end