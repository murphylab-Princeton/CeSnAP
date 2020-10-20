function tmp3=rescaleToMachineSize(machinePicSize, refinedTile)


     if (max(size(refinedTile)) > machinePicSize)
             %-------------------------------------- 
             tmp2 = 0;
             trash = 0;
             while max(size(tmp2))~= machinePicSize
                 scale = machinePicSize/(max(size(refinedTile))+trash);
                 tmp2  = imresize(refinedTile,scale);
                 trash = trash+0.1;
             end
             tmp3  = zeros(machinePicSize,machinePicSize);
             ind1 = floor((     max(size(tmp2))-min(size(tmp2))   )/2);
             if size(tmp2,1)>size(tmp2,2)
                 tmp3(:,(ind1+1):(ind1+size(tmp2,2))) =  tmp2;
             else
                 tmp3((ind1+1):(ind1+size(tmp2,1)),:) =  tmp2;
             end
             %-------------------------------------- 
     else
             %--------------------------------------
             tmp3  = zeros(machinePicSize,machinePicSize);
             indXX = floor((     machinePicSize-size(refinedTile,1)   )/2);
             indYY = floor((     machinePicSize-size(refinedTile,2)   )/2);
             tmp3((indXX+1):(indXX+size(refinedTile,1)),(indYY+1):(indYY+size(refinedTile,2))) =  refinedTile;
             %--------------------------------------
     end
end