function SaliencyDetection_Main()
clear, clc,
close all
addpath(genpath('Funs'));
addpath(genpath('RBD_Funcs'));
addpath(genpath('run measure'));

% ori_src = 'F:\zxg_文件备份20190802\image datasets\saliency_image_datasets\CSSD200\images_CSSD200\images';       %Path of input images
% gt_src = 'F:\zxg_文件备份20190802\image datasets\saliency_image_datasets\CSSD200\ground_truth_mask';        %Path for saving bdCon feature image
% %

% 
% ori_src = 'H:\image dataset\saliency_image_datasets\CSSD200\images_CSSD200\images';       %Path of input images
% gt_src = 'H:\image dataset\saliency_image_datasets\CSSD200\ground_truth_mask_CSSD200\ground_truth_mask';


% ori_src = 'F:\zxg_文件备份20190802\image datasets\saliency_image_datasets\PASCAL-S_850\PASCAL-S显著性图像库\images';       %Path of input images
% gt_src = 'F:\zxg_文件备份20190802\image datasets\saliency_image_datasets\PASCAL-S_850\PASCAL-S显著性图像库\ground_truth_mask';        %Path for saving bdCon feature image

%  ori_src = 'C:\Users\zxg\Documents\MATLAB\saliencyDetection_3_final\test images';       %Path of input images
%  gt_src = 'C:\Users\zxg\Documents\MATLAB\saliencyDetection_3_final\test images';        %Path for saving bdCon feature image


 ori_src = 'H:\source_code\saliency_detection\saliencyDetection_3_final\test images';       %Path of input images
 gt_src = 'H:\source_code\saliency_detection\saliencyDetection_3_final\test images';        %Path for saving bdCon feature image

CSV_file = 'F:\seg_result_PASCAL-S_850\CSV';       %Path for saving color space volume
optSalW_img_file = 'F:\seg_result_PASCAL-S_850\optSalW_img';       %Path for saving optSalW_img
imfConImg_file = 'F:\seg_result_PASCAL-S_850\imfConImg';       %Path for saving imfConImg
refinedSalMap_file = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\参数讨论\result';       %Path for saving refinedSalMap

input_src_Suffix = '.jpg';     %suffix for your input image
gt_src_Suffix = '.jpg';    % .png    %suffix for your input ground truth image
ori_img_files = dir(fullfile(ori_src, strcat('*', input_src_Suffix)));
gt_img_files = dir(fullfile(gt_src, strcat('*', gt_src_Suffix)));

%% 1. Parameter Settings
len=length(ori_img_files);
all_roc_fmeasure_data_measure=zeros(len,4);
for ite=1:10    %50 100 150 200 250
    % ite=2;
    roc_fmeasure_data_measure=zeros(len,4);
    for K=1:len
        K = 1;
        fprintf('Evaluating: %d:%d/%d\n',ite,K,len);
        ori_srcName = ori_img_files(K).name;
        ori_noSuffixName = ori_srcName(1:end-length(input_src_Suffix));
        img = imread(fullfile(ori_src, ori_srcName));
        
        gt_srcName = gt_img_files(K).name;
        gt_noSuffixName = gt_srcName(1:end-length(gt_src_Suffix));
        gt_img = double(imread(fullfile(gt_src, gt_srcName)));
        %% Pre-Processing: Remove Image Frames
        [noFrameImg, frameRecord] = removeframe(img, 'sobel');
        [hei, wid, chn] = size(noFrameImg);
%         noFrameImg = img;
        %% Use SLIC Super-pixel to segment input rgb image into patches
        %tic;
        t1=clock;
        [idxImg, adjcMatrix, pixelList] = SLIC_Main(noFrameImg, hei,wid);
        
        %% Create the Color Space Volume for Highlighting the Saliency Regions
        [csv_img,L,N_a,N_b]=CreateColorSpaceVolume(noFrameImg);
        %csv_img=adjustContrast(csv_img);
        %% Get super-pixel properties
        spNum = size(adjcMatrix, 1);
        [meanRgbCol, brightnessW,contrastW]= GetMeanColor(csv_img,L,N_a,N_b,noFrameImg,pixelList,idxImg);
        meanLabCol = colorspace('Lab<-', double(meanRgbCol)/255);
        meanPos = GetNormedMeanPos(pixelList, hei, wid);
        bdIds = GetBndPatchIds(idxImg);
        colDistM = GetDistanceMatrix(meanLabCol);
        posDistM = GetDistanceMatrix(meanPos);
        [clipVal, geoSigma, neiSigma] = EstimateDynamicParas(adjcMatrix, colDistM);
        
        %% Saliency Optimization
        [bgProb, mybdCon, bdCon,bgWeight,fgProb]  = EstimateBgLikelihoodWeights(noFrameImg,idxImg,csv_img,colDistM, adjcMatrix, bdIds, clipVal, geoSigma,ite);
        %[bgProb, mybdCon, bdCon,bgWeight,fgProb2] = EstimateBgLikelihoodWeights_bak(noFrameImg,csv_img,idxImg,colDistM, adjcMatrix, bdIds, clipVal, geoSigma,pixelList,brightnessW)
        %[optSalW_img,csv_img,adjCtr,imfConImg,refinedSalMap,refinedSalMap_adj]=SaliencyOptimizationW2(csv_img,noFrameImg,idxImg,posDistM,colDistM,bgProb, mybdCon, bdCon,pixelList,brightnessW)
        [optSalW_img,csv_img,imfConImg,refinedSalMap]=SaliencyOptimizationW(mybdCon,bdCon,noFrameImg,csv_img,idxImg, pixelList,brightnessW,bgWeight,posDistM,colDistM,gt_img,bgProb,fgProb,ite);
        %finalSalMap=Normalization_1_255(refinedSalMap,1);
        finalSalMap=refinedSalMap;
        %% the optimal Saliency Maps Extraction
        %----------------------【run segmentation measure】--------------------
        %run the metrics
        seg_img=padarrayMap(finalSalMap, frameRecord,noFrameImg);% Restoring the original image size
        [precision, recall, Fmeasure, MAE]=run_sal_Measure(seg_img,gt_img,ite);
        roc_fmeasure_data_measure(K,:)=[precision, recall, Fmeasure, MAE];
        
        
        
        result_path = strcat(refinedSalMap_file, num2str(ite));
        refinedSalMap_=fullfile(result_path, strcat(ori_noSuffixName, '.png'));%
        imwrite(refinedSalMap, refinedSalMap_);
        
    end
    all_roc_fmeasure_data_measure(ite,:)=[roundn(mean(roc_fmeasure_data_measure),-5)];
    save('my_measure_PASCAL-S_850_new.mat','all_roc_fmeasure_data_measure','-v7.3','-nocompression')
end

%%%%  draw PR curve %%%%%%%%%%%

addpath('classifier evaluation\classifier evaluation\Functions\');%加载文件夹Functions中的函数
addpath('classifier evaluation\classifier evaluation\');%加载文件夹Functions中的函数

%% 三种方法得到的结果路径，以及真值图路径
result1 = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\参数讨论\result1\';
result2 = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\参数讨论\result2\';
result3 = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\参数讨论\result3\';
result4 = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\参数讨论\result4\';
result5 = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\参数讨论\result5\';
result6 = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\参数讨论\result6\';
result7 = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\参数讨论\result7\';
result8 = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\参数讨论\result8\';
result9 = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\参数讨论\result9\';
result10 = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\参数讨论\result10\';

mask = 'H:\image dataset\saliency_image_datasets\CSSD200\ground_truth_mask_CSSD200\ground_truth_mask\';

gt_file = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\参数讨论\mask\';
rst_file = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\参数讨论\new_result1\';
%% 创建文件夹evaluation index，目的是保存PR曲线图
newFolder = 'evaluation index';
if ~exist(newFolder)
    mkdir(newFolder);
end
%% Evaluation index 1: evaluating MAE
resultSuffix = '.png';
gtSuffix = '.png';


%% Evaluation index 2: ploting PR curve
[rec1, prec1] = DrawPRCurve(result1, resultSuffix, mask, gtSuffix, true, true, 'r');
hold on
[rec2, prec2] = DrawPRCurve(result2, resultSuffix, mask, gtSuffix, true, true, 'g');
hold on
[rec3, prec3] = DrawPRCurve(result3, resultSuffix, mask, gtSuffix, true, true, 'b');
hold on
[rec4, prec4] = DrawPRCurve(result4, resultSuffix, mask, gtSuffix, true, true, 'c');
hold on
[rec5, prec5] = DrawPRCurve(result5, resultSuffix, mask, gtSuffix, true, true, 'y');
hold on
[rec6, prec6] = DrawPRCurve(result6, resultSuffix, mask, gtSuffix, true, true, 'w');
hold on
[rec7, prec7] = DrawPRCurve(result7, resultSuffix, mask, gtSuffix, true, true, 'k');
hold on
[rec8, prec8] = DrawPRCurve(result8, resultSuffix, mask, gtSuffix, true, true, 'm');
hold on
[rec9, prec9] = DrawPRCurve(result9, resultSuffix, mask, gtSuffix, true, true, 'b');
hold on
[rec10, prec10] = DrawPRCurve(result10, resultSuffix, mask, gtSuffix, true, true, 'b');
hold off;
grid on;
box on;
xlabel('Recall');
ylabel('Precision');
% title(strcat('PR-curve','  ( ',sprintf(' MAE = %1.6f ',maeDSR),' )'));
title('PR-curve');
lg = legend({'k=0.1','k=0.2','k=0.3', 'k=0.4','k=0.5','k=0.6','k=0.7','k=0.8','k=0.9','k=1.0'});
set(lg, 'location', 'southwest');
k=1.2;
set(gcf,'units',get(gcf,'paperunits'));
set(gcf,'paperposition',get(gcf,'position')*k);
saveas(gcf,strcat(newFolder,'\PR-curve','.bmp'));

end