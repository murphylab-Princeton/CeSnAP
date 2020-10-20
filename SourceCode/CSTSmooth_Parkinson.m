function [worm_bc_smoothed] = CSTSmooth_Parkinson(listPoint, lngth, smoothLevel)
     idList = smoothLevel+1;
     while mod(length(idList),smoothLevel)~=0
         idList    = sort(setdiff(1:lngth,randi([2 lngth-2],mod(lngth,smoothLevel),1)));
     end
     tmpX1     = mean(reshape(listPoint(idList,1),smoothLevel,[]),1);
     tmpY1     = mean(reshape(listPoint(idList,2),smoothLevel,[]),1);
     myRand2   = floor(randi([1 smoothLevel],1,1)-(smoothLevel/2));
     tmpX2     = mean(reshape(circshift(listPoint(idList,1),myRand2),smoothLevel,[]),1);
     tmpY2     = mean(reshape(circshift(listPoint(idList,2),myRand2),smoothLevel,[]),1);
    %%---------------------------------------------------------------------
     idList = smoothLevel+1;
     while mod(length(idList),smoothLevel)~=0
         idList    = sort(setdiff(1:lngth,randi([2 lngth-2],mod(lngth,smoothLevel),1)));
     end
     myRand3   = floor(randi([1 smoothLevel],1,1)-(smoothLevel/2));
     tmpX3     = mean(reshape(circshift(listPoint(idList,1),myRand3),smoothLevel,[]),1);
     tmpY3     = mean(reshape(circshift(listPoint(idList,2),myRand3),smoothLevel,[]),1);
     myRand4   = floor(randi([1 smoothLevel],1,1)-(smoothLevel/2));
     tmpX4     = mean(reshape(circshift(listPoint(idList,1),myRand4),smoothLevel,[]),1);
     tmpY4     = mean(reshape(circshift(listPoint(idList,2),myRand4),smoothLevel,[]),1);
    %%---------------------------------------------------------------------
     clear newList1
     newList1(:,1) = mean([tmpX1;tmpX2;tmpX3;tmpX4],1)';
     newList1(:,2) = mean([tmpY1;tmpY2;tmpY3;tmpY4],1)';
     newList1(end+1,:) =  newList1(1,:);
     worm_bc_smoothed = newList1;

end