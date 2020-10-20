function Layout = plotFiguresMachine(Layout, info, filePD)
if ~isfield(filePD, 'my_imds')
if isfield(filePD(1).worms{1}{1}, 'WormCat')
%% ----------------------------------------------------------------------  
    Letters = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O'];    
    for aa=1:length(info.mConditionName)
        for CaseID=1:length(filePD)
                if (strcmp(filePD(CaseID).Exp(1),Letters(aa))==1  && info.AnalayzeTheseWells{CaseID}==true) 
                    bb                       = str2num(filePD(CaseID).Exp(2));
                    tmpCurl{aa}(bb)        = 0; 
                    tmpHalfCurl{aa}(bb)    = 0;
                    tmpNearCurl{aa}(bb)    = 0; 
                    tmpStraight{aa}(bb)    = 0;
                    tmpTotal{aa}(bb)       = 0;
                     for RoundID = 1:length(filePD(CaseID).worms)  
                     if info.AnalayzeTheseRounds{RoundID} == true
                     for SnapID = 1:length(filePD(CaseID).worms{RoundID})
                            for k  = 1:length(filePD(CaseID).worms{RoundID}{SnapID}.worm_bc)
                                    %%-------------------------------------
                                    if     strcmp(filePD(CaseID).worms{RoundID}{SnapID}.WormCat{k},'Curled')    , tmpCurl{aa}(bb)    = tmpCurl{aa}(bb)+1; 
                                    elseif strcmp(filePD(CaseID).worms{RoundID}{SnapID}.WormCat{k},'HalfCurled'), tmpHalfCurl{aa}(bb)=tmpHalfCurl{aa}(bb)+1;
                                    elseif strcmp(filePD(CaseID).worms{RoundID}{SnapID}.WormCat{k},'NearCurled'), tmpNearCurl{aa}(bb)=tmpNearCurl{aa}(bb)+1;
                                    elseif strcmp(filePD(CaseID).worms{RoundID}{SnapID}.WormCat{k},'Straight')  , tmpStraight{aa}(bb)=tmpStraight{aa}(bb)+1; 
                                    end 
                                    %%-------------------------------------
                                    if    ~strcmp(filePD(CaseID).worms{RoundID}{SnapID}.WormCat{k},'Censored')  , tmpTotal{aa}(bb)=tmpTotal{aa}(bb)+1;
                                    end
                                    %%-------------------------------------
                            end
                     end
                     end
                     end
                end
        end
    end
    %----------------------------------------------------------------------
    for aa=1:length(info.mConditionName)
    k=0;
    for bb=1:length(tmpTotal{aa})
        if tmpTotal{aa}(bb)~=0
            k=k+1;
            FilteredTotal{aa}(k)      =  tmpTotal{aa}(bb);
            FilteredCurl{aa}(k)       =  tmpCurl{aa}(bb)+tmpHalfCurl{aa}(bb);
            FilteredNearCurl{aa}(k)   =  tmpNearCurl{aa}(bb);
            %FilteredCurl{aa}(k)       =  tmpCurl{aa}(bb);
            %FilteredNearCurl{aa}(k)   =  tmpHalfCurl{aa}(bb);
        end
    end
    end
    %----------------------------------------------------------------------
    for aa=1:length(info.mConditionName)
        CurlCategory{aa}     = info.mConditionName{aa};             
        NearCurlCategory{aa} = info.mConditionName{aa};
    end
    val_max =0;
    for aa = 1:length(info.mConditionName)
       Curliii(aa)             = 100*mean(FilteredCurl{aa}./FilteredTotal{aa});
       NearCurliii(aa)         = 100*mean(FilteredNearCurl{aa}./FilteredTotal{aa});
       ErrorCurliii(aa)        = 100*std(FilteredCurl{aa}./FilteredTotal{aa})/sqrt(length(tmpCurl{aa}));
       ErrorNearCurliii(aa)    = 100*std(FilteredNearCurl{aa}./FilteredTotal{aa})/sqrt(length(tmpCurl{aa}));
       val_max                 = max(max(max(FilteredCurl{aa}./FilteredTotal{aa}),max(FilteredNearCurl{aa}./FilteredTotal{aa})),val_max);
    end
    cla(Layout.axesImageFive,'reset');   
    cla(Layout.axesImageSix,'reset');
    
    ImageFive = histogram('Categories',CurlCategory      ,'BinCounts', Curliii    ,'parent', Layout.axesImageFive, 'BarWidth', 0.6, 'LineWidth', 2, 'FaceColor','r', 'EdgeColor',[0.25, 0.25, 0.25]); 
    ylabel_Five = ylabel('% worms in curled position','parent', Layout.axesImageFive);      
    hold(Layout.axesImageFive, 'on');
    
    Er_Five = errorbar( Curliii     , ErrorCurliii      , '.r','parent', Layout.axesImageFive, 'LineWidth', 3, 'CapSize', 20, 'Color', 'k') ;   
    ImageSix = histogram('Categories',NearCurlCategory  ,'BinCounts', NearCurliii,'parent', Layout.axesImageSix, 'BarWidth', 0.6, 'LineWidth', 2, 'FaceColor','g', 'EdgeColor',[0.25, 0.25, 0.25]);   
    ylabel_Six = ylabel('% worms in near-curled position','parent', Layout.axesImageSix); 
    hold(Layout.axesImageSix, 'on');
    Er_Six = errorbar( NearCurliii , ErrorNearCurliii  , '.r','parent', Layout.axesImageSix, 'LineWidth', 3, 'CapSize', 20, 'Color', 'k');
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

    txt1 = strtrim(cellstr(num2str(cellfun(@sum,tmpCurl)'))');
    txt2 = strtrim(cellstr(num2str(cellfun(@sum,tmpNearCurl)'))');
    txt3 = strtrim(cellstr(num2str(cellfun(@sum,tmpTotal)'))');

    for i=1:length(txt1), txt6{i} = [txt1{i},'/',txt3{i}]; txt7{i} = [txt2{i},'/',txt3{i}];end
    
    for aa=1:length(info.mConditionName)
        division_sign{aa} = '____';
    end
    
    Font_y1 = 1.55*251/Layout.axesImageSix.Position(4);
    Font_y2 = 1.55*251/Layout.axesImageSix.Position(4);
    
    text(get(Layout.axesImageFive, 'XTick'), Curliii+ErrorCurliii                 , txt3, 'HorizontalAlignment','center', 'VerticalAlignment','bottom','parent', Layout.axesImageFive, 'FontSize', 12, 'FontWeight','bold', 'Color','b');
    text(get(Layout.axesImageSix, 'XTick'), NearCurliii+ErrorNearCurliii          , txt3, 'HorizontalAlignment','center', 'VerticalAlignment','bottom','parent', Layout.axesImageSix,   'FontSize', 12, 'FontWeight','bold', 'Color','b');
    
    text(get(Layout.axesImageFive, 'XTick'), Curliii+ErrorCurliii+Font_y1         , division_sign, 'HorizontalAlignment','center', 'VerticalAlignment','bottom','parent', Layout.axesImageFive, 'FontSize', 12, 'FontWeight','bold', 'Color','b', 'Interpreter', 'none');
    text(get(Layout.axesImageSix, 'XTick'), NearCurliii+ErrorNearCurliii+Font_y1  , division_sign, 'HorizontalAlignment','center', 'VerticalAlignment','bottom','parent', Layout.axesImageSix,   'FontSize', 12, 'FontWeight','bold', 'Color','b', 'Interpreter', 'none');
    
    text(get(Layout.axesImageFive, 'XTick'), Curliii+ErrorCurliii+Font_y2         , txt1, 'HorizontalAlignment','center', 'VerticalAlignment','bottom','parent', Layout.axesImageFive, 'FontSize', 12, 'FontWeight','bold', 'Color','b');
    text(get(Layout.axesImageSix, 'XTick'), NearCurliii+ErrorNearCurliii+Font_y2  , txt2, 'HorizontalAlignment','center', 'VerticalAlignment','bottom','parent', Layout.axesImageSix,   'FontSize', 12, 'FontWeight','bold', 'Color','b');
   
    
    Layout.axesImageFive.LineWidth  = 2;
    Layout.axesImageSix.LineWidth   = 2;
    %%---------------------------------------------------------------------  
end
end
end