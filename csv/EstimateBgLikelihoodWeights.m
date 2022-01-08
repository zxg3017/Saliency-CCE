function [bgProb, mybdCon, bdCon,bgWeight,fgProb] = EstimateBgLikelihoodWeights(idxImg,colDistM, adjcMatrix, bdIds, clipVal, geoSigma,ite)
% obtain the background likelihood weigths
% Code Author: Xiaogen Zhou
% Email: xiaogenzhou@126.com
% Date: 25/07/2019

bdCon = BoundaryConnectivity(adjcMatrix, colDistM, bdIds, clipVal, geoSigma, true);

%% Centroid distance weights computing
centDisW=regionsCentroidDis(idxImg);
mybdCon=bdCon.*centDisW; % the Background Likelihood Weights Computing

bdConSigma =1; %sigma for converting bdCon value to background probability

fgProb = exp(-mybdCon.^2 / (2 * bdConSigma * bdConSigma)); %Estimate bg probability
bgProb = 1 - fgProb;
%bdCon=mybdCon;
bgWeight = bgProb;
% Give a very large weight for very confident bg sps can get slightly
% better saliency maps, you can turn it off.
fixHighBdConSP = true;
minVal = min(bdCon);
maxVal = max(bdCon);
spValues = (bdCon - minVal) / (maxVal - minVal + eps);
level=graythresh(spValues);     %determine the threshold
%level=0.10;
if fixHighBdConSP
    bgWeight(spValues > (level+0.1)) = 1000;
    %bgWeight(spValues <= (level+0.1)) = bgWeight(spValues <= (level+0.1))+0.1;
end
end
