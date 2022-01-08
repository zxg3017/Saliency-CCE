function finalSalMap=SaliencyMapsOptimization(img,initSalLabels,cent_csv_img,idxImg)
% the Final Saliency Map Extraction

% Code Author: Xiaogen Zhou
% Email: xiaogenzhou@126.com
% Date: 25/07/2019

%% Multimodal Histogram Thresholding Computing
seg_result=MHT_main(cent_csv_img);
result=seg_result;

%% Final Saliency Map Extraction
labels=idxImg;
saliency_label=labels(find((cent_csv_img.*result)>0));
[labels_sal num]=unique(saliency_label);
if length(labels_sal)==1
    meanSeeds=0;
else
    meanSeeds=1;
end
for i=1:length(labels_sal)
    if num(i)<meanSeeds
        labels_sal(i)=-1;
    end
end
labels_sal(find(labels_sal==-1))=[];%remove the label of non-salient region
final_cent_csv_img=zeros(size(img,1),size(img,2));
final_SalLabels=zeros(size(img,1),size(img,2));
final_seg_result=zeros(size(img,1),size(img,2));
bw_cent_csv_img=zeros(size(img,1),size(img,2));
for i=1:length(labels_sal)
    final_cent_csv_img(find(labels==labels_sal(i)))=cent_csv_img(find(labels==labels_sal(i)));
    final_SalLabels(find(labels==labels_sal(i)))=labels(find(labels==labels_sal(i)));
    final_seg_result(find(labels==labels_sal(i)))=1;
end
bw_cent_csv_img(find(initSalLabels>0))=1;
[L1,num]=bwlabel(final_seg_result,8);
[L2,num]=bwlabel(bw_cent_csv_img,8);

stats_L1 = regionprops(L1,'Area');    % find the area of the maximum connected region
stats_L2 = regionprops(L2,'Area');     % find the area of the maximum connected region
if isempty(stats_L1) || isempty(stats_L2)
    final_seg_result=bw_cent_csv_img;
elseif (stats_L1(1).Area<100) || (stats_L2(1).Area<100)
    final_seg_result=bw_cent_csv_img;
else
    S_final=stats_L1(1).Area;
    S_center=stats_L2(1).Area;
    if fix(S_center/S_final)>=3
        final_seg_result=bw_cent_csv_img;
    end
end
maxBw=maxLianTongYu(final_seg_result,1);   %obtain the maximum connected region
finalSalMap=imfill(maxBw,'hole');              %obtain the final saliency map by image filling
end