function [bgProb, mybdCon, bdCon,bgWeight,fgProb2] = EstimateBgLikelihoodWeights_bak(noFrameImg,csv_img,idxImg,colDistM, adjcMatrix, bdIds, clipVal, geoSigma,pixelList,brightnessW)
% Estimate background probability using boundary connectivity

% Code Author: Wangjiang Zhu
% Email: wangjiang88119@gmail.com
% Date: 3/24/2014

bdCon = BoundaryConnectivity(adjcMatrix, colDistM, bdIds, clipVal, geoSigma, true);

%% Centroid distance weights computing
centDisW=regionsCentroidDis(idxImg);
mybdCon=bdCon.*centDisW; % the Background Likelihood Weights Computing

bdConSigma =1; %sigma for converting bdCon value to background probability

bdSigma = mean(centDisW); %sigma for converting bdCon value to background probability
fgProb = exp(-mybdCon.^2 / (2 * bdConSigma * bdConSigma)); %Estimate bg probability
bgProb = 1 - fgProb;

fgProb1 = exp(-bdCon.^2 / (2 * bdSigma * bdSigma)); %Estimate bg probability
bgProb1 = 1 - fgProb1;

bgWeight = bgProb;
% Give a very large weight for very confident bg sps can get slightly
% better saliency maps, you can turn it off.
fixHighBdConSP = true;
% normalized
%bdCon=mybdCon;
minVal = min(bdCon);
maxVal = max(bdCon);
spValues = (bdCon - minVal) / (maxVal - minVal + eps);
level=graythresh(spValues);     %确定灰度阈值
highThresh = 2.5;
if fixHighBdConSP
    bgWeight(spValues > (level+0.1)) = 100;
    %bgWeight(spValues <= (level+0.1)) = bgWeight(spValues <= (level+0.1))+0.1;
end

sal_sigma=1;
brightnessW=(brightnessW - min(brightnessW)) / (max(brightnessW) - min(brightnessW) + eps); % the background ones are smaller,but the saliency objects are the larger.
salW=exp(-(1.*(1-brightnessW)).^2/2*sal_sigma*sal_sigma);
minVal = min(salW);
maxVal = max(salW);
salW_norn = (salW - minVal) / (maxVal - minVal + eps);

fgProb2 = exp(-(bgWeight).^2 / (2 * bdConSigma * bdConSigma)); %Estimate bg probability

minVal = min(fgProb2);
maxVal = max(fgProb2);
fgProb2_norn = (fgProb2 - minVal) / (maxVal - minVal + eps);
salWeight=fgProb2.*salW;


salWeight_norn=salW_norn.*fgProb2_norn;
salWeight_1=fgProb2.*brightnessW;


fgProb3=fgProb2+0.1;

[result1,spValues1]= normalized(fgProb,idxImg,pixelList);
[result2,spValues2]= normalized(fgProb1,idxImg,pixelList);
[result3,spValues3]= normalized(fgProb2,idxImg,pixelList);
[result4,spValues4]= normalized(salWeight,idxImg,pixelList);
[result5,spValues4]= normalized(bgWeight,idxImg,pixelList);
[result6,spValues4]= normalized(fgProb3,idxImg,pixelList);
[result7,spValues4]= normalized(salWeight_norn,idxImg,pixelList);
[result8,spValues4]= normalized(salW,idxImg,pixelList);
[result9,spValues4]= normalized(salW_norn,idxImg,pixelList);
[result10,spValues4]= normalized(brightnessW,idxImg,pixelList);
[result11,spValues4]= normalized(salWeight_1,idxImg,pixelList);
[result12,spValues4]= normalized(fgProb2_norn,idxImg,pixelList);

OutImg=Normalization_1_255(result1,1);
OutImg_result6=Normalization_1_255(result6,1);
csv_bg=csv_img.*result5;


subplot(3, 5, 1); imshow(noFrameImg); title('noFrameImg');
subplot(3, 5, 2); imshow(uint8(csv_img)); title('csv_img');
subplot(3, 5, 3); imshow(result1); title('result1');
subplot(3, 5, 4); imshow(result2); title('result2');
subplot(3, 5, 5); imshow(result3); title('result3 fgProb2');
subplot(3, 5, 6); imshow(result4); title('result4');
subplot(3, 5, 7); imshow(uint8(csv_bg)); title('csv_bg');
subplot(3, 5, 8); imshow(result7); title('result7 salWeight_norn');
subplot(3, 5, 9); imshow(result8); title('result8 salW');
subplot(3, 5, 10); imshow(result8); title('result8 salW');
subplot(3, 5, 11); imshow(result9); title('salW_norn');
subplot(3, 5, 12); imshow(result10); title('brightnessW');
subplot(3, 5, 13); imshow(result11); title('salWeight_1 fgProb2.*brightnessW');
subplot(3, 5, 14); imshow(result12); title('salWeight_1 fgProb2_norn');

end
