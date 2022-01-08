function result=maxLianTongYu(I,flag)
% obtain the maximum connected region

% Code Author: Xiaogen Zhou
% Email: xiaogenzhou@126.com
% Date: 25/07/2019

if flag==1 % obtain the maximum single connected region
    [imLabel,num] = bwlabel(I,8);                % bwlabel Label connected components in 2-D binary image.
    stats_S = regionprops(imLabel,'Area');       % compute the area of each regions
    area = cat(1,stats_S.Area);
    index = find(area>=max(area));        % obtain the index of the maximum connected region
    result = ismember(imLabel,index);           % obtain the image of the maximum connected region
elseif flag==2 % obtain the first several connected regions
    [L,num] = bwlabel(I,8);                     %    bwlabel Label connected components in 2-D binary image.
    STATS_S = regionprops(L,'Area','boundingbox');% obtain the area of each regions
    allArea = [STATS_S.Area];
    % show the largest connected region
    meanArea=mean(allArea);% find the mean value
    idx0 = find([STATS_S.Area] >= meanArea | [STATS_S.Area]/meanArea<=2);
    medianAllArea=allArea(idx0);
    medianArea=mean(medianAllArea);
    while ~isempty(find(medianAllArea<=medianArea & medianArea./medianAllArea>=3))
        idxLast=find(medianAllArea<=medianArea & medianArea./medianAllArea>=3);
        medianAllArea(idxLast)=[];
        idx0(idxLast)=[];
        medianAllArea=allArea(idx0);
        medianArea=mean(medianAllArea);
    end
    result = ismember(L,idx0);               %obtain the image of the maximum connected region
elseif flag==3 % obtain the first several connected regions
    [imLabel,num] = bwlabel(I,8);
    stats_S = regionprops(imLabel,'Area');
    area = cat(1,stats_S.Area);
    if length(area)>=10
        index = find(area>=mean(area));        % obtain the index of the maximum connected region
        result = ismember(imLabel,index);      %obtain the image of the maximum connected region
    else
        result = I;          %obtain the image of the maximum connected region
    end
end