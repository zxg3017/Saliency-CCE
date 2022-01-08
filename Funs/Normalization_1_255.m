function OutImg=Normalization_1_255(IMG,flag)
% Normalized a grayscale image in the range [0 1] or [0 255].
% flag=1: in the range [0 255]; flag=2: in the range [0 1]

% Code Author: Xiaogen Zhou
% Email: xiaogenzhou@126.com
% Date: 25/07/2019

[row,col,Z]=size(IMG);
if Z>1
    IMG = rgb2gray(IMG);
end
originalMinValue = double(min(min(IMG)));
originalMaxValue = double(max(max(IMG)));
originalRange = originalMaxValue - originalMinValue;
if flag==1    %  Get a double image in the range [0 255]
    desiredMin = 0;
    desiredMax = 255;
    desiredRange = desiredMax - desiredMin;
    OutImg = desiredRange * (double(IMG) - originalMinValue) / originalRange + desiredMin;
elseif flag==2 % Get a double image in the range [0 1]
    
    desiredMin = 0;
    desiredMax = 1;
    desiredRange = desiredMax - desiredMin;
    OutImg = desiredRange * (double(IMG) - originalMinValue) / originalRange + desiredMin;
end
end