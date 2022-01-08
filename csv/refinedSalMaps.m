function [optSalW_img,imfConImg,refinedSalMap]=refinedSalMaps(gt_img,noFrameImg,csv_img,optSalW_img,ite)
% obtain the refined saliency map via removing the small objects and
% morphology operation
% Code Author: Xiaogen Zhou
% Email: xiaogenzhou@126.com
% Date: 25/07/2019

%% remove the small areas of the saliency map by using otsu method
%OutImg=Normalization_1_255(optSalW_img,1);
%seg_result=MHT_main(OutImg);
% sal=optSalW_img(:);
% sal(sal==0)=[];

img = double(img)/255;
level=graythresh(img);     %确定灰度阈值
BW=im2bw(img,level);

% level=0.98;
% if level==0
%     finalLevel=level;
% else
%     level3=graythresh(optSalW_img);     %确定灰度阈值
%     level_srt=num2str(level3);
%     level_srt_cut=level_srt(1:3);
%     level3=str2num(level_srt_cut);
%     finalLevel=level-level3;
% end
%finalLevel=level;
finalLevel=level;
% if finalLevel<=0
%    finalLevel=level-0.3;
% end

BW=im2bw(optSalW_img,finalLevel);

maxConImg=maxLianTongYu(BW,1); %obtain the maximum connected region
sel=strel('disk',5);
morh_img=imopen(maxConImg,sel);
maxConImg2=maxLianTongYu(morh_img,1); %obtain the maximum connected region
imfConImg=imfill(maxConImg2,'hole'); %obtain the maximum connected region
refinedSalMap=imfConImg.*optSalW_img;

end