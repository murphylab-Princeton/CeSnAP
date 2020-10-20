function Layout = plotAreaLengthFigure(Layout, info, filePD)
if ~isfield(filePD, 'my_imds')
if isfield(filePD(1).worms{1}{1}, 'WormCat')
%% ----------------------------------------------------------------------   
    Letters = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O'];    
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
                                        primeterWorms{aa}{bb}{c_w}    = filePD(CaseID).worms{RoundID}{SnapID}.area_worm{ww};
                                        areaWorms{aa}{bb}{c_w}        = filePD(CaseID).worms{RoundID}{SnapID}.perimeter_worm{ww};
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
    %----------------------------------------------------------------------
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
    %----------------------------------------------------------------------
    for aa=1:length(info.mConditionName)
        lengthCategory{aa}     = info.mConditionName{aa};             
        areaCategory{aa}       = info.mConditionName{aa};
    end
    %----------------------------------------------------------------------
    val_max =0;
    for aa = 1:length(info.mConditionName)
       mLength(aa)        = mean(m_lengthWorms{aa}./mean(m_lengthWorms{1}));
       mArea(aa)          = mean(m_areaWorms{aa}./mean(m_areaWorms{1}));
       ErrorLength(aa)    = std(m_lengthWorms{aa}./mean(m_lengthWorms{1}))/sqrt(length(m_lengthWorms{aa}));
       ErrorArea(aa)      = std(m_areaWorms{aa}./mean(m_areaWorms{1}))/sqrt(length(m_areaWorms{aa}));
    end
    %----------------------------------------------------------------------
    cla(Layout.axesImageFive,'reset');   
    cla(Layout.axesImageSix,'reset');
    
    ImageFive = histogram('Categories',lengthCategory      ,'BinCounts', mLength    ,'parent', Layout.axesImageFive, 'BarWidth', 0.6, 'LineWidth', 2, 'FaceColor','r', 'EdgeColor',[0.25, 0.25, 0.25]); 
    ylabel_Five = ylabel('normalized worm length','parent', Layout.axesImageFive);      
    hold(Layout.axesImageFive, 'on');
    
    Er_Five = errorbar( mLength     , ErrorLength      , '.r','parent', Layout.axesImageFive, 'LineWidth', 3, 'CapSize', 20, 'Color', 'k') ;   
    ImageSix = histogram('Categories',areaCategory  ,'BinCounts', mArea,'parent', Layout.axesImageSix, 'BarWidth', 0.6, 'LineWidth', 2, 'FaceColor','g', 'EdgeColor',[0.25, 0.25, 0.25]);   
    ylabel_Six = ylabel('normalized worm area','parent', Layout.axesImageSix); 
    hold(Layout.axesImageSix, 'on');
    Er_Six = errorbar( mArea , ErrorArea  , '.r','parent', Layout.axesImageSix, 'LineWidth', 3, 'CapSize', 20, 'Color', 'k');
    Layout.axesImageSix.FontSize = 13;
    Layout.axesImageFive.FontSize = 13;
    
    Layout.axesImageFive.FontWeight = 'bold';
    Layout.axesImageSix.FontWeight = 'bold';
    
    ylabel_Six.FontSize = 15;
    ylabel_Five.FontSize = 15;
%      ylabel_Five.Position(1) = [0.405 4.0000 -1];
%      ylabel_Six.Position(1)  = [0.405 4.0000 -1];
    
    yy= Layout.axesImageFive.YLim;
    ss= Layout.axesImageSix.YLim;
    
    Layout.axesImageFive.YLim = max(ss,yy);
    Layout.axesImageSix.YLim  = max(ss,yy);

    txt3 = strtrim(cellstr(num2str(cellfun(@length,m_lengthWorms)'))');
   
    text(get(Layout.axesImageFive, 'XTick'), mLength+ErrorLength   , txt3, 'HorizontalAlignment','center', 'VerticalAlignment','bottom','parent', Layout.axesImageFive, 'FontSize', 12, 'FontWeight','bold', 'Color','b');
    text(get(Layout.axesImageSix, 'XTick'), mArea+ErrorArea        , txt3, 'HorizontalAlignment','center', 'VerticalAlignment','bottom','parent', Layout.axesImageSix,   'FontSize', 12, 'FontWeight','bold', 'Color','b');
    
    Layout.axesImageFive.LineWidth  = 2;
    Layout.axesImageSix.LineWidth   = 2;
    %%---------------------------------------------------------------------  
    
    
    
    
    
    
    
    
end
end
end
