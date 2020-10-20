function eBinerized = findBinaryWorm(m_greyScaleTile,m_maskTile)
%Sworm=9;
%m_greyScaleTile = greyScaleTile{myFinalWinnerList(Sworm)};
%m_maskTile = maskTileMatrix{myFinalWinnerList(Sworm)};
% cc=19;
% m_greyScaleTile=greyScaleTile{winnerIDs(cc)};
% m_maskTile=maskTileMatrix{winnerIDs(cc)};

coefCensor = 1.5;
flagArray = false;
%%-------------------------------------------------------------------------
for jj=1:3
    LowThresh  = multithresh(m_greyScaleTile(m_maskTile),jj);
    eBinerizedTMP = imbinarize(m_greyScaleTile,LowThresh(1));
    tmpX       = bwconncomp(eBinerizedTMP,8);
    [~,maxIDX]  = max(cellfun(@numel,tmpX.PixelIdxList) );
    eBinerizedCellArray{jj}    = m_maskTile; eBinerizedCellArray{jj}(:)=false;
    eBinerizedCellArray{jj}(tmpX.PixelIdxList{maxIDX}) = true;
end

for iii=3:-1:1
    eBinerized = eBinerizedCellArray{iii};
    %------------------------------
    myStr1      = strel('disk',4,0);
    myStr2      = strel('disk',15,0);
    m_erod      = imerode(eBinerized,myStr1);
    tmp2       = bwconncomp(m_erod,8);
    if ~isempty(tmp2.PixelIdxList)
        [~,maxID]  = max(cellfun(@numel,tmp2.PixelIdxList) );
        newMaskTMP    = m_maskTile; newMaskTMP(:)=false;
        newMaskTMP(tmp2.PixelIdxList{maxID}) = true;
        newMask    = imdilate(newMaskTMP,myStr2);
        if isempty(intersect(find(newMask==false),find(eBinerized==true)))  &&   (length(find(eBinerized))<(coefCensor*length(find(eBinerizedCellArray{1}))))
            flagArray = true;
            break
        end
    end
end
%%-------------------------------------------------------------------------
if (flagArray==false)
    for kk=2:-1:1
        myStr3         = strel('disk',3,4);
        LowThresh      = multithresh(m_greyScaleTile(m_maskTile),kk);
        erodeBinerized = imerode(imbinarize(m_greyScaleTile,LowThresh(1)),myStr3);
        tmp22           = bwconncomp(erodeBinerized,8);
        if ~isempty(tmp22.PixelIdxList)
                [~,maxAreaID2] = max(cellfun(@numel,tmp22.PixelIdxList) );
                erodeWorm      = m_maskTile;      erodeWorm(:)   = false;
                erodeWorm(tmp22.PixelIdxList{maxAreaID2})=true;
                dilatWormT     = imdilate(erodeWorm,myStr3);
                tmp3           = bwconncomp(dilatWormT,8);
                [~,maxAreaID3] = max(cellfun(@numel,tmp3.PixelIdxList) );
                eBinerized     = m_maskTile; eBinerized(:)=false;
                eBinerized(tmp3.PixelIdxList{maxAreaID3}) = true;    
                if (length(find(eBinerized))<(coefCensor*length(find(eBinerizedCellArray{1}))))
                    flagArray = true;
                    break
                end
        end
    end
end
%%-------------------------------------------------------------------------



end



    