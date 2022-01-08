function result=padarrayMap(seg_img, frameRecord,img)
% Fill back super-pixel values to image pixels and save into .png images

% Code Author: Wangjiang Zhu
% Email: wangjiang88119@gmail.com
% Date: 3/24/2014



h = frameRecord(1);
w = frameRecord(2);

top = frameRecord(3);
bot = frameRecord(4);
left = frameRecord(5);
right = frameRecord(6);

partialH = bot - top + 1;
partialW = right - left + 1;
partialImg = seg_img;

if partialH ~= h || partialW ~= w
    result = zeros(h, w) ;
    result(top:bot, left:right) = partialImg;
else
    result=partialImg;
end