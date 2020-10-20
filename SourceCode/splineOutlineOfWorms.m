function final_wBound=splineOutlineOfWorms(mBinary, mgrey)

mSkel = bwskel(imfill(mBinary,'holes'));
tmpLocalBC = bwboundaries(mSkel);
%--------------------------------------------------------------------------
m_ox = tmpLocalBC{1};
[~,~,m_ic]=unique(m_ox,'rows','stable');
turnPoints = find(abs(diff(diff(m_ic)))==2)+1;   turnPoints=turnPoints(turnPoints>4);    turnPoints=turnPoints(turnPoints<(length(m_ox)-4));
forkPoints = find(abs(diff(m_ic))~=1);           forkPoints=forkPoints(forkPoints>7);    forkPoints=forkPoints(forkPoints<(length(m_ox)-7));
breakPoints= sort(cat(1,turnPoints,forkPoints),'ascend');

if length(breakPoints)>1
        mSections1{1} = m_ox(1:breakPoints(1),:);
        for iu=2:length(breakPoints)
            mSections1{iu}= m_ox(breakPoints(iu-1):breakPoints(iu),:); 
        end
        mSections1{iu+1} = m_ox(breakPoints(iu):end,:);
        for i=1:length(turnPoints), ListOfTurnPoints1(i,:) = m_ox(turnPoints(i),:);end
        %--------------------------------------------------------------------------
        m_ox2 = flip(m_ox,1);
        [~,~,m_ic2] = unique(m_ox2,'rows','stable');
        turnPoints2 = find(abs(diff(diff(m_ic2)))==2)+1;    turnPoints2=turnPoints2(turnPoints2>4);    turnPoints2=turnPoints2(turnPoints2<(length(m_ox)-4));
        forkPoints2 = find(abs(diff(m_ic2))~=1);            forkPoints2=forkPoints2(forkPoints2>7);    forkPoints2=forkPoints2(forkPoints2<(length(m_ox)-7));
        breakPoints2= sort(cat(1,turnPoints2,forkPoints2),'ascend');
        mSections2{1} = m_ox2(1:breakPoints2(1),:);
        for iu=2:length(breakPoints2)
            mSections2{iu}= m_ox2(breakPoints2(iu-1):breakPoints2(iu),:); 
        end
        mSections2{iu+1} = m_ox2(breakPoints2(iu):end,:);
        for i=1:length(turnPoints2), ListOfTurnPoints2(i,:) = m_ox2(turnPoints2(i),:);end
        %--------------------------------------------------------------------------
        mSections = [mSections1,mSections2];
        nS = 1;
        newSections{nS}=mSections{1};
        for io=2:length(mSections)
            trigger=false;
            for kk=1:length(newSections)
                if(length(intersect(mSections{io},newSections{kk},'rows'))>3)
                    trigger=true;
                    if (length(mSections{io})<length(newSections{kk}))
                       newSections{kk}=mSections{io}; 
                    end
                end   
            end
            if trigger==false, nS=nS+1;newSections{nS}=mSections{io};end
        end
        %--------------------------------------------------------------------------
        count=0;
        for ii=1:length(newSections)
            if length(newSections{ii})>2
                count=count+1;
                mfSec{count}=newSections{ii};
            end
        end
        %--------------------------------------------------------------------------
        L_tips = unique(cat(1,ListOfTurnPoints1,ListOfTurnPoints2),'rows','stable');
        for ii=1:length(mfSec)
            if ismember(mfSec{ii}(end,:),L_tips,'rows')
                mfSec{ii} = flip(mfSec{ii},1);
            end
        end
        %--------------------------------------------------------------------------
        connMAT = zeros(length(mfSec),length(mfSec))+2;
        for m1=1:length(mfSec)
            for m2=1:length(mfSec)
                if m1~=m2
                    dis1=sqrt(  (mfSec{m1}(1,1)-mfSec{m2}(1,1))^2       +    (mfSec{m1}(1,2)-mfSec{m2}(1,2))^2  );    
                    dis2=sqrt(  (mfSec{m1}(1,1)-mfSec{m2}(end,1))^2     +    (mfSec{m1}(1,2)-mfSec{m2}(end,2))^2  );
                    dis3=sqrt(  (mfSec{m1}(end,1)-mfSec{m2}(1,1))^2     +    (mfSec{m1}(end,2)-mfSec{m2}(1,2))^2  );
                    dis4=sqrt(  (mfSec{m1}(end,1)-mfSec{m2}(end,1))^2   +    (mfSec{m1}(end,2)-mfSec{m2}(end,2))^2  );

                    if     dis1<3, connMAT(m1,m2)=1; connMAT(m2,m1)=1;
                    elseif dis2<3, connMAT(m1,m2)=1; connMAT(m2,m1)=-1;
                    elseif dis3<3, connMAT(m1,m2)=-1;connMAT(m2,m1)=1;
                    elseif dis4<3, connMAT(m1,m2)=-1;connMAT(m2,m1)=-1;
                    end
                end
            end
        end
        %--------------------------------------------------------------------------
        clear mProfile
        count=0;
        for i=1:size(connMAT,1)
            for j=1:size(connMAT,1)
                if i~=j && ismember(mfSec{i}(1,:),L_tips,'rows') && ismember(mfSec{j}(1,:),L_tips,'rows')
                %------------------------------------------------------------------
                    if ((connMAT(i,j)+connMAT(j,i))==-2),count=count+1; mProfile{count}=cat(1,mfSec{i},flip(mfSec{j},1)); end
                    %---------------------------------------------------
                    for m1=1:size(connMAT,1)
                         if i~=m1 && j~=m1 && ((connMAT(i,m1)+connMAT(j,m1))==-2) && (connMAT(m1,i)+connMAT(m1,j)==0)
                             count=count+1; 
                             if connMAT(m1,i)==1,mMiddle=mfSec{m1};else,mMiddle=flip(mfSec{m1},1);end
                             mProfile{count}=cat(1,mfSec{i},mMiddle,flip(mfSec{j},1)); 
                         end
                         %----------------------------------
                         for m2=1:size(connMAT,1)
                             if i~=m1 && j~=m1 && i~=m2 && j~=m2 && m1~=m2 
                                 if ((connMAT(i,m1)+connMAT(j,m2))==-2) && (connMAT(m1,i)+connMAT(m1,m2)==0) && (connMAT(m2,m1)+connMAT(m2,j)==0)
                                    count=count+1;
                                    if connMAT(m1,i)==1,mMiddle1=mfSec{m1};else,mMiddle1=flip(mfSec{m1},1);end 
                                    if connMAT(m2,j)==-1,mMiddle2=mfSec{m2};else,mMiddle2=flip(mfSec{m2},1);end
                                    mProfile{count}=cat(1,mfSec{i},mMiddle1,mMiddle2,flip(mfSec{j},1)); 
                                 end
                             end
                             %------------------ 
                             for m3=1:size(connMAT,1)
                                if i~=m1 && j~=m1 && i~=m2 && j~=m2 && m1~=m2 && i~=m3 && j~=m3 && m1~=m3 && m2~=m3
                                     if ((connMAT(i,m2)+connMAT(j,m3))==-2) && (connMAT(m2,i)+connMAT(m2,m1)==0) && (connMAT(m1,m2)+connMAT(m1,m3)==0) && (connMAT(m3,m1)+connMAT(m3,j)==0)
                                        count=count+1;
                                        if connMAT(m2,i)==1 ,mMiddle1=mfSec{m2};else,mMiddle1=flip(mfSec{m2},1);end 
                                        if connMAT(m1,m2)==1,mMiddle2=mfSec{m1};else,mMiddle2=flip(mfSec{m1},1);end
                                        if connMAT(m3,j)==-1,mMiddle3=mfSec{m3};else,mMiddle3=flip(mfSec{m3},1);end
                                        mProfile{count}=cat(1,mfSec{i},mMiddle1,mMiddle2,mMiddle3,flip(mfSec{j},1)); 
                                     end
                                     if ((connMAT(i,m1)+connMAT(j,m3))==-2) && (connMAT(m1,i)+connMAT(m1,m2)==0) && (connMAT(m2,m1)+connMAT(m2,m3)==0) && (connMAT(m3,m2)+connMAT(m3,j)==0)
                                         count=count+1;
                                        if connMAT(m1,i)==1 ,mMiddle1=mfSec{m1};else,mMiddle1=flip(mfSec{m1},1);end 
                                        if connMAT(m2,m1)==1,mMiddle2=mfSec{m2};else,mMiddle2=flip(mfSec{m2},1);end
                                        if connMAT(m3,j)==-1,mMiddle3=mfSec{m3};else,mMiddle3=flip(mfSec{m3},1);end
                                        mProfile{count}=cat(1,mfSec{i},mMiddle1,mMiddle2,mMiddle3,flip(mfSec{j},1)); 
                                     end
                                     if ((connMAT(i,m1)+connMAT(j,m2))==-2) && (connMAT(m1,i)+connMAT(m1,m3)==0) && (connMAT(m3,m1)+connMAT(m3,m2)==0) && (connMAT(m2,m3)+connMAT(m2,j)==0)
                                         count=count+1;
                                        if connMAT(m1,i)==1 ,mMiddle1=mfSec{m1};else,mMiddle1=flip(mfSec{m1},1);end 
                                        if connMAT(m3,m1)==1,mMiddle2=mfSec{m3};else,mMiddle2=flip(mfSec{m3},1);end
                                        if connMAT(m2,j)==-1,mMiddle3=mfSec{m2};else,mMiddle3=flip(mfSec{m2},1);end
                                        mProfile{count}=cat(1,mfSec{i},mMiddle1,mMiddle2,mMiddle3,flip(mfSec{j},1)); 
                                     end
                                end
                             end
                             %--------------------
                         end
                         %----------------------------------
                    end 
                    %---------------------------------------------------
                end
            end
        end
        %--------------------------------------------------------------------------
        nS = 1;
        newProfiles{nS}=mProfile{1};
        for io=2:length(mProfile)
            trigger=false;
            for kk=1:length(newProfiles)
                if (length(intersect(mProfile{io},newProfiles{kk},'rows'))>(0.95*length(newProfiles{kk})))
                    trigger=true;
                    break
                end   
            end
            if trigger==false, nS=nS+1;newProfiles{nS}=mProfile{io};end
        end
        
else
  newProfiles{1}= m_ox(1:breakPoints(1),:);
end
%---------------------------------
for ijk=1:length(newProfiles)
    [wormB1,wormB2] = findWormUsingSkel(newProfiles{ijk}(:,2),newProfiles{ijk}(:,1), mBinary, mgrey);
    if ~isempty(wormB1)
        wBounds{ijk} = cat(1,wormB1,flip(wormB2,1));
        my_BW = poly2mask(wBounds{ijk}(:,1),wBounds{ijk}(:,2),size(mBinary,1),size(mBinary,2));
        list_org_mask = find(mBinary);
        list_spline_mask = find(my_BW);
        intersectArea(ijk) = length(intersect(list_org_mask,list_spline_mask));
    else
        intersectArea(ijk)=0;
    end
end
if max(intersectArea)~=0
    [maxIntersect,indMAX] = max(intersectArea);
    if (maxIntersect>(0.75*length(list_org_mask))) && (maxIntersect<(1.2*length(list_org_mask)))
        final_wBound = wBounds{indMAX};
    else
        final_wBound =[];
    end
else
    final_wBound =[];
end
%---------------------------------
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%[wormBoundary1,wormBoundary2,pp_teta,pp_thickness,wormCenter] = findWormUsingSkel(X_org,Y_org, mBinary) 
function [wormBoundary1,wormBoundary2] = findWormUsingSkel(X_org,Y_org, mBinary, mgrey)  
X1    = X_org;
Y1    = Y_org;
for iii=1:10
    r_sqr(1,1)    = 0;
    r_sqr(2:length(X1),1) = sqrt(diff(Y1).^2+diff(X1).^2);
    r1    = cumsum(r_sqr);
    X1    = smooth(r1,X1);
    Y1    = smooth(r1,Y1);
end
Xgrad = gradient(X1);
Ygrad = gradient(Y1);
teta1 = atan(Ygrad./Xgrad);
c_teta = teta1;
while find(sqrt(diff(r_sqr).^2+diff(c_teta).^2)>2)
    mleak = (find(sqrt(diff(r_sqr).^2+diff(c_teta).^2)>2));
    if       c_teta(mleak(1))>c_teta(mleak(1)+1),     c_teta(mleak(1)+1:end) = c_teta(mleak(1)+1:end)+pi;
    elseif   c_teta(mleak(1))<c_teta(mleak(1)+1),     c_teta(mleak(1)+1:end) = c_teta(mleak(1)+1:end)-pi;
    end
end
if Xgrad(1)<0, c_teta = c_teta+pi; end

breaks = linspace(min(r1),max(r1),8);
pp     = splinefit(r1,c_teta,breaks,3);

r_line      = linspace(min(r1),max(r1),101);
r_low       = linspace(-0.2*max(r1),min(r1),21);
r_high      = linspace(max(r1),1.2*max(r1),21);
r_lineSpace = [r_low(1:20),r_line,r_high(2:21)];
pp_teta       = ppval(pp,r_lineSpace);
cos_mteta = cos(pp_teta);
sin_mteta = sin(pp_teta);
delta_r = (max(r1)-min(r1))/(100-1);
mCumX = cumsum(delta_r.*cos_mteta);
mCumY = cumsum(delta_r.*sin_mteta);
X_result = mCumX-mCumX(21)+X_org(1);
Y_result = mCumY-mCumY(21)+Y_org(1);
%%-------------------------------------------------------------------------
tmpBound = bwboundaries(mBinary);
wB_X = tmpBound{1}(:,2);
wB_Y = tmpBound{1}(:,1);

for ik=1:length(r_lineSpace)
    thickW_tmp(ik) = min(sqrt((X_result(ik)-wB_X).^2+(Y_result(ik)-wB_Y).^2));   
end
[~, ind1] = min(thickW_tmp); thickW_tmp(ind1)=max(thickW_tmp);
[~, ind2] = min(thickW_tmp); thickW_tmp(ind2)=max(thickW_tmp);
if (abs(ind1-ind2))>20
    if ind1<ind2, thickW=thickW_tmp(ind1+1:ind2-1); thickR=r_lineSpace(ind1+1:ind2-1); indexOfStart=ind1+1; indexOfEnd=ind2-1;
    else,         thickW=thickW_tmp(ind2+1:ind1-1); thickR=r_lineSpace(ind2+1:ind1-1); indexOfStart=ind2+1; indexOfEnd=ind1-1; end
    new_breaks = linspace(min(thickR),max(thickR),8);
    pp_thickness = splinefit(thickR,thickW,new_breaks,3);
    m_thick       = ppval(pp_thickness,r_lineSpace);
    %%---------------------------------------------------------------------
    XB1_result = X_result -(m_thick.*sin_mteta);
    YB1_result = Y_result +(m_thick.*cos_mteta);
    XB2_result = X_result +(m_thick.*sin_mteta);
    YB2_result = Y_result -(m_thick.*cos_mteta);

    wormBoundary1(:,1) = XB1_result(indexOfStart:indexOfEnd);
    wormBoundary1(:,2) = YB1_result(indexOfStart:indexOfEnd);
    wormBoundary2(:,1) = XB2_result(indexOfStart:indexOfEnd);
    wormBoundary2(:,2) = YB2_result(indexOfStart:indexOfEnd);
    %%---------------------------------------------------------------------
    wormCenter(:,1)    = X_result(indexOfStart:indexOfEnd);
    wormCenter(:,2)    = Y_result(indexOfStart:indexOfEnd);
    
%     u_thick = (-1.2*max(m_thick)):((r_lineSpace(6)-r_lineSpace(5))/2):(1.2*max(m_thick));
%     Xmatrix = repmat(X_result',[1,length(u_thick)]) -(repmat(u_thick,[length(r_lineSpace),1]).*repmat(sin_mteta',[1,length(u_thick)]));
%     Ymatrix = repmat(Y_result',[1,length(u_thick)]) +(repmat(u_thick,[length(r_lineSpace),1]).*repmat(cos_mteta',[1,length(u_thick)]));
%     [mX,mY] = meshgrid(1:size(mBinary,2),1:size(mBinary,1));
%     Vq = interp2(mX,mY,mgrey,Ymatrix,Xmatrix);
    
    
else
    wormBoundary1=[];
    wormBoundary2=[];
end

end












