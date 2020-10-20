function [Layout,info,filePD, ResultPD] = click_action_wellFinder(Layout,info, filePD, ResultPD, hObject)
%% ------------------------------------------------------------------------
            if strcmp(get(hObject,'SelectionType'),'normal')
            %%------------ left click: add a point-------------------------
            %%-------------------------------------------------------------
            filepath = pwd;
            newPoint = get(Layout.axesImageOne, 'CurrentPoint'); 
            if        strcmp(info.format,'nd2')==1
                load(fullfile(filepath,[info.filename,'_nd2Folder'],[filePD(1).Exp,'_','r',num2str(1),'.mat']),'WellSnapshot');
            elseif    strcmp(info.format,'vid')==1
                load(fullfile(filepath,[info.filename,'_MOVfolder'],[filePD(1).Exp,'_','r',num2str(1),'.mat']),'WellSnapshot');
            end
            if newPoint(1,1)>0 &&  newPoint(1,2)>0 && newPoint(1,1)<size(WellSnapshot{1},1) &&  newPoint(1,2)<size(WellSnapshot{1},2)  
                        info.Well{5}(:,end+1) = [newPoint(1,1) ; newPoint(1,2)];
                        info.Well{6}(end+1) = plot(info.Well{5}(1,:), info.Well{5}(2,:), '*r');
                        if size(info.Well{5},2) >= 3
                            [omega,radius] = getCenterFromManyPoints(info.Well{5});
                            omega = fix(omega);
                            radius = fix(radius);
                            if ~isempty(info.Well{7}) && ishandle(info.Well{7})
                                delete(info.Well{7});
                                info.Well{7} = [];
                            end
                            info.Well{7} = plot(omega(1) + radius*cos(2*pi*(0:200)/200), omega(2) + radius*sin(2*pi*(0:200)/200), '-r', 'linewidth', 2);
                            
                            info.Well{2} = radius;
                            info.Well{3} = omega(1);
                            info.Well{4} = omega(2);
                        end
            end
            %%------------ right click: remove a point---------------------
            %%-------------------------------------------------------------
            else
                    if ~isempty(info.Well{5})
                        info.Well{5}(:,end) = [];
                        delete(info.Well{6}(end));
                        info.Well{6}(end) = [];
                        info.Well{2} = [];
                        info.Well{3} = [];
                        info.Well{4} = [];
                        if ~isempty(info.Well{7}) && ishandle(info.Well{7})
                            delete(info.Well{7});
                            info.Well{7} = [];
                        end
                        if size(info.Well{5},2) >= 3
                            [omega,radius] = getCenterFromManyPoints(info.Well{5});
                            omega = fix(omega);
                            radius = fix(radius);
                            info.Well{7} = plot(omega(1) + radius*cos(2*pi*(0:200)/200), omega(2) + radius*sin(2*pi*(0:200)/200), '-r', 'linewidth', 2);
                            info.Well{2} = radius;
                            info.Well{3} = omega(1);
                            info.Well{4} = omega(2);
                        else
                        end
                    end
            end
%%-------------------------------------------------------------------------
end


%%-------------------- Center of the circumscribed circle from three points
function omega = getCenterFrom3Points(p1, p2, p3)
    delta = ( p2(1)-p3(1) ) * ( p2(2)-p1(2) ) - ( p2(2)-p3(2) ) * ( p2(1)-p1(1) );
    len = ( p2(1)^2 + p2(2)^2 ) - ( p3(1)^2 + p3(2)^2 ) - ( p1(1)+p2(1) )*( p2(1)-p3(1) ) - ( p1(2)+p2(2) )*( p2(2)-p3(2) );
    lambda = len / delta;
    omega(1) = p1(1) + p2(1) +  lambda * ( p2(2) - p1(2) );
    omega(2) = p1(2) + p2(2) -  lambda * ( p2(1) - p1(1) );
    omega = omega / 2;
end
%%--Center of the averaged circumscribed circle from more than three points
function [omega,radius] = getCenterFromManyPoints(p)
    nbPoints = size(p,2);
    omegaAll = zeros(2,nchoosek(nbPoints,3));
    radiiAll = zeros(1,nchoosek(nbPoints,3));
    it = 0;
    for firstPoint = 1:nbPoints-2
        p1 = p(:, firstPoint);
    for secondPoint = firstPoint+1:nbPoints-1
        p2 = p(:, secondPoint);
    for thirdPoint = secondPoint+1:nbPoints
        p3 = p(:, thirdPoint);
        it = it+1;
        omegaAll(:,it) = getCenterFrom3Points(p1, p2, p3);
        radiiAll(it) = realsqrt((omegaAll(1,it)-p1(1))^2 + (omegaAll(2,it)-p1(2))^2);
    end
    end
    end
    omega = mean(omegaAll,2);
    radius = mean(radiiAll);
end