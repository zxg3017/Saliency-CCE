function finalSalMap=edgeDetection(img,edgeMethod)
% Edge Detection

% Code Author: Xiaogen Zhou
% Email: xiaogenzhou@126.com
% Date: 25/07/2019


[row,wid,Z]=size(img);
if Z>1
img=rgb2gray(img);
end

edgeImg = edge(img, edgeMethod); % edge detection
edgeImg1 = edge(img, 'sobel'); % edge detection

maxBw=maxLianTongYu(edgeImg,1);       %obtain the maximum connected region
finalSalMap=imfill(maxBw,'hole');              %obtain the final saliency map by image filling


 subplot(3,5,6);imshow(uint8(img));title('grayimg');
 subplot(3,5,7);imshow(edgeImg);title('canny edgeImg');
 subplot(3,5,8);imshow(edgeImg1);title('sobel');
 subplot(3,5,9);imshow(maxBw);title('maxBw');
 subplot(3,5,10);imshow(finalSalMap);title('finalSalMap');
end