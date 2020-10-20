function [imageList,WellName] = bfopen_CeSnAP(id, varargin)

stitchFiles = 0;
bfInitLogging();
rSource = bfGetReader(id, stitchFiles);

numSeries      = rSource.getSeriesCount();
imageList      = cell(numSeries,1);
CameraCoor     = zeros(numSeries,2);

for sWell = 1:numSeries
    rSource.setSeries(sWell - 1);
    numImages       = rSource.getImageCount();
    imagetmp        = cell(numImages,1);
    
    for iLoop = 1:numImages
        imagetmp{iLoop} = bfGetPlane(rSource, iLoop, varargin{:});
    end
    CameraCoor(sWell,1)   =  rSource.getMetadataStore.getPlanePositionX(sWell-1,0).value();
    CameraCoor(sWell,2)   =  rSource.getMetadataStore.getPlanePositionY(sWell-1,0).value();
    imageList{sWell}      =  imagetmp;
end


[CXX,iaXX,icXX] = unique(ceil(CameraCoor(:,1)/10));
[CYY,iaYY,icYY] = unique(ceil(CameraCoor(:,2)/10)); 
WellName        = cell(numSeries,1);
%WellID          = cell(numSeries,1);
for sWell = 1:numSeries
        if     icXX(sWell)==1,name1 = 'A';
        elseif icXX(sWell)==2,name1 = 'B';  
        elseif icXX(sWell)==3,name1 = 'C'; 
        elseif icXX(sWell)==4,name1 = 'D'; 
        elseif icXX(sWell)==5,name1 = 'E'; 
        elseif icXX(sWell)==6,name1 = 'F';     
        elseif icXX(sWell)==7,name1 = 'G'; 
        elseif icXX(sWell)==8,name1 = 'H';end

        name2 = num2str(max(icYY)-icYY(sWell)+1);
        WellName{sWell} = [name1,name2];
        %WellID{sWell}   = [icXX(sWell),max(icYY)-icYY(sWell)+1];
end
rSource.close();
end








