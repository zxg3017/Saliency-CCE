function [adjCtr,imfConImg,refinedSalMap,refinedSalMap_adj]=refinedSalMap(img,csv_img,noFrameImg)
% obtain the refined saliency map via removing the small objects and
% morphology operation
% Code Author: Xiaogen Zhou
% Email: xiaogenzhou@126.com
% Date: 25/07/2019

%% remove the small areas of the saliency map by using otsu method
seg_result=MHT_main(IMG)
adjCtr=adjustContrast(img); % enhance the contrast of img;
level=graythresh(adjCtr);     %确定灰度阈值
BW=im2bw(adjCtr,level);
maxConImg=maxLianTongYu(BW,1); %obtain the maximum connected region
sel=strel('disk',5);
morh_img=imopen(maxConImg,sel);
maxConImg2=maxLianTongYu(morh_img,1); %obtain the maximum connected region
imfConImg=imfill(maxConImg2,'hole'); %obtain the maximum connected region
refinedSalMap=imfConImg.*img;
refinedSalMap_adj=imfConImg.*adjCtr;
% 
% subplot(3, 5, 1); imshow(noFrameImg); title('noFrameImg');
% subplot(3, 5, 2); imshow(uint8(csv_img)); title('csv_img');
% subplot(3, 5, 3); imshow(img); title('img');
% subplot(3, 5, 4); imshow(adjCtr); title('adjCtr adjustContrast');
% subplot(3, 5, 5); imshow(maxConImg2); title('maxConImg2');
% subplot(3, 5, 6); imshow(refinedSalMap); title('refinedSalMap img');
% subplot(3, 5, 7); imshow(refinedSalMap_adj); title('initialSalMap1 result');

end