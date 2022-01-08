function [result,spValues]= normalized(img,idxImg,pixelList)
% A image normalized to [0 1]
% Code Author: Xiaogen Zhou
% Email: xiaogenzhou@126.com
% Date: 25/07/2019
doNormalize=true;

minVal = min(img);
maxVal = max(img);
if doNormalize
    spValues = (img - minVal) / (maxVal - minVal + eps);
else
    if minVal < -1e-6 || maxVal > 1 + 1e-6
        error('feature values do not range from 0 to 1');
    end
end

result = zeros(size(idxImg,1),size(idxImg,2));
for i=1:length(pixelList)
    result(pixelList{i}) = spValues(i);
end



end