function quaData=ROC(groundTruth,segImage)
%this programme is developed to calculate quantitative measure values of a segmentation result to its ground truth (mannual ideal segmentation result) 
%references:
% ME(Misclassification Error)
% FPR(False Positive Rate),FNR (False Negative Rate)ㄛTPR(True Positive Rate, Sensitivity), TNR(true negative rate, Specificity)
% 1. Fleiss JL, Cohen J, Everitt BS (1969) Large sample standard errors of kappa and weighted kappa. Psychol Bull 72(5):323每327
% 2. http://en.wikipedia.org/wiki/Sensitivity_and_specificity

% TPF(True-positive fraction), FPF(false positive fraction), TNF(true negative fraction), FNF(false negative fraction)
% 3. Loizou C, Pattichis C, Pantziaris M, Nicolaides A (2007) An integrated system for the segmentation of atherosclerotic carotid
% plaque. IEEE Trans Inform Tech Biomed 11(5):661每667
% KI(similarity kappa index) 
% 4. Fleiss JL, Cohen J, Everitt BS (1969) Large sample standard errors of kappa and weighted kappa. Psychol Bull 72(5):323每327
% Overlap index
% 5. G. H. Rosenfield and K. Fitzpatrick Lins, ※A coefficient of agreement as a measure of thematic classification accuracy,§ Photogramm. Eng. Remote
% Sens., vol. 52, no. 2, pp. 223每227, 1986.

%--------------------------------------------------------------------------
[Gx Gy]=size(groundTruth);
[Sx Sy]=size(segImage);
if Gx~=Sx | Gy~=Sy
    disp(['Sizes of two input images must be the same!']);return;
end


if length(unique(groundTruth))~=2 | length(unique(segImage))~=2
    disp('There exist input image, which is not a binary image.Two input images are must be binary images!');return;
end

%------convert a binary image to another binary image with 0 and 1---------
groundTruth(groundTruth==min(groundTruth(:)))=0;
groundTruth(groundTruth==max(groundTruth(:)))=1;  
segImage(segImage==min(segImage(:)))=0;
segImage(segImage==max(segImage(:)))=1;  

quaData.me=sum(sum(xor(groundTruth,segImage)))/(Gx*Gy);
%quaData.fpr=(sum(segImage(:))-sum(sum(groundTruth.*segImage)))/sum(sum(~groundTruth));
%quaData.fnr=(sum(groundTruth(:))-sum(sum(groundTruth.*segImage)))/sum(sum(groundTruth));
quaData.tpr=sum(sum(groundTruth.*segImage))/sum(sum(groundTruth));
quaData.tnr=sum(sum(~(groundTruth+segImage)))/sum(sum(~groundTruth));

% quaData.tpf=quaData.tpr;
% quaData.fpf=(sum(segImage(:))-sum(sum(groundTruth.*segImage)))/sum(sum(groundTruth));    %fpr and fpf have the same numerator but different denominator

% quaData.tnf=0; I think there is error for the definition in reference 3,so i give up the calculation
% quaData.fnf=0; I think there is error for the definition in reference 3,so i give up the calculation

quaData.ki=2*sum(sum(groundTruth.*segImage))/(sum(groundTruth(:))+sum(segImage(:)));  %which is also called dice ratio
quaData.overlap=sum(sum(groundTruth.*segImage))/(Gx*Gy-sum(sum(~(groundTruth+segImage)))); 

%------------------------update the code-----------------------------------
Fp=segImage;       % object foreground of segmentation result
Fg=groundTruth;    % foreground of groundtruth
Bp=~segImage;      % none-object (background) of segmentation result
Bg=~groundTruth;   % none-object (background) of groundtruth

quaData.Precision=sum(sum(Fg&Fp))/sum(sum(Fp));
quaData.FPR=sum(sum(Bg & Fp))/sum(sum(Bg));
quaData.FNR=sum(sum(Fg & Bp))/sum(sum(Fg));
quaData.Recall=sum(sum(Fg&Fp))/sum(sum(Fg));

quaData.ME_1=1- (sum(sum(Bg & Bp)+sum(sum(Fg & Fp))))/(sum(sum(Fg))+sum(sum(Bg)));




