function [initSalLabels, cent_csv_img] = EstimateBgLikelihoodWeights(idxImg,csv_img,colDistM, adjcMatrix, bdIds, clipVal, geoSigma)
% Estimate the background likelihood weights using boundary connectivity and
% centroid distance weights

% Code Author: Wangjiang Zhu and Xiaogen Zhou
% Email: wangjiang88119@gmail.com/xiaogenzhou@126.com
% Date: 3/24/2014 update: 25/07/2019

initSalLabels=idxImg;% initial saliency maps
bdCon = BoundaryConnectivity(adjcMatrix, colDistM, bdIds, clipVal, geoSigma, true);% boundary connectivity computing
%% find the initial saliency maps
highThresh = 0.1;  % [0.01 0.15]
labels=unique(idxImg);
numlabels=length(labels);
cent_csv_img=csv_img;
%% Centroid distance weights computing
centDisW=regionsCentroidDis(idxImg,numlabels);
mybdCon=bdCon.*centDisW; % the Background Likelihood Weights Computing
while 1  % avoid Over Estimation 
    if length(find(mybdCon < highThresh))<=4
        highThresh=highThresh+0.1;
    else
        break;
    end
end
%% Initial Salient Map Extraction
for i=1:numlabels
    if mybdCon(i) >= highThresh % boundary patches
        initSalLabels(find(idxImg==i))=0;
        cent_csv_img(find(idxImg==i))=0;
    end
end