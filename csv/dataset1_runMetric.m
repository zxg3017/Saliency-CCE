function runMetric()
%close all
addpath(genpath('Funs'));
addpath(genpath('RBD_Funcs'));
addpath(genpath('p2016-rss-small-target\MSER\'));
addpath(genpath('Salient-Object-Detection-Via-Deformed-Smoothness-Constraint'));
addpath(genpath('SRIS'));
addpath(genpath('p2019-cns-sod\CNS\'));
addpath(genpath('Saliency-Evaluation-Toolbox\saliency_evaluation\'));


%*****************计算各算法的结果测度值********************%
% ESCSSD1K_imgPath = 'H:\image dataset\saliency_image_datasets\CSSD200\images_CSSD200\images\';
% ESCSSD1K_gtPath = 'H:\image dataset\saliency_image_datasets\CSSD200\ground_truth_mask_CSSD200\ground_truth_mask\';

ESCSSD1K_imgPath = 'H:\image dataset\saliency_image_datasets\CSSD200\images_CSSD200\images\'
ESCSSD1K_gtPath = 'H:\image dataset\saliency_image_datasets\CSSD200\ground_truth_mask_CSSD200\ground_truth_mask\'
%
% PASCAL-S_850_imgPath = 'H:\image dataset\saliency_image_datasets\PASCAL-S_850\PASCAL-S显著性图像库\images\';
% PASCAL-S_850_gtPath = 'H:\image dataset\saliency_image_datasets\PASCAL-S_850\PASCAL-S显著性图像库\ground_truth_mask\';

CNSPath = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\对比算法结果\CSSD200\CNS\';
DGLPath = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\对比算法结果\CSSD200\DGL\';
SRISPath = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\对比算法结果\CSSD200\SRIS\';
HDCTPath = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\对比算法结果\CSSD200\HDCT\';
MSERPath = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\对比算法结果\CSSD200\MSER\';
MRPath = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\对比算法结果\CSSD200\MR_stage2\';
SFPath = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\对比算法结果\CSSD200\SF\';
wCtrPath = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\对比算法结果\CSSD200\wCtr_Optimized\';
FCBPath = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\对比算法结果\CSSD200\FCB\';
GSPath = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\对比算法结果\CSSD200\GS\';
GSPath = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\对比算法结果\CSSD200\our_CSV\';


%% Read Images
imgJPG = dir([ESCSSD1K_imgPath, '*.jpg']);
imgBMP = dir([ESCSSD1K_imgPath, '*.bmp']);
imgs   = [imgJPG; imgBMP];


%% To produce the result of methods and save it into files.
% for imgno = 1:length(imgs)
for imgno = 1:length(imgs)

tic;
    imgname = imgs(imgno).name;
    %     t1 = clock;
    fprintf('%04d/%04d - %s\t', imgno, length(imgs), imgname);
    img = imread([ESCSSD1K_imgPath, imgname]);
    
      %CNS method%
%     salmap = CNS_Main(img);
%     salmap = CNS_Test(img);
%     imwrite(salmap, [CNSPath, imgname(1:end-4), '_CNS.png']);
%     
%     DGL method%
%     [DGL,pixelList,frameRecord] = DGL_Main(img);
%     smapName=fullfile(DGLPath, strcat(imgname(1:end-4), '_DGL.png'));   % save result
%     SaveSaliencyMap(DGL, pixelList, frameRecord, smapName, true);
%     imwrite(Map, [DGLPath, imgname(1:end-4), '_DGL.png']);
    
    %SRIS%
%     SRIS_res = my_SRIS_Main(img);
%     imwrite(SRIS_res, [SRISPath, imgname(1:end-4), '_SRIS.png']);
    
%     %HDCT%
%     HDCT = HDCT_Main(img);
%     imwrite(HDCT, [HDCTPath, imgname(1:end-4), '_HDCT.png']);
    
%     MSER%
%     MSER = MSER_Main(img);
%     imwrite(MSER, [MSERPath, imgname(1:end-4), '_MSER.png']);
toc;
end

% *******************************测量评价测度*************************************%
extra_methods={'our_CSV' 'CNS' 'DGL' 'HDCT' 'SRIS' 'MR_stage2' 'MSER' 'SF' 'wCtr_Optimized' 'FCB' 'GS'}; %算法种类名称
% extra_methods={ 'CNS'}; %算法种类名称
salMapPath = 'H:\科研投稿\KNOWL-BASED SYST 投稿\对比算法论文\对比算法结果\CSSD200\'

gtFiles = dir(ESCSSD1K_gtPath);
imgNUM = length(gtFiles)-2;

%evaluation score initilization.
Fmeasure=zeros(1,imgNUM);
MAE=zeros(1,imgNUM);
precision =zeros(1,imgNUM);
recall = zeros(1,imgNUM);
len = length(extra_methods);
for k = 1:len
     for i = 1:imgNUM
        
        fprintf('Evaluating: %d/%d\n',i,imgNUM);
        name =  gtFiles(i+2).name;
        
        %load gt
        gt = imread([ESCSSD1K_gtPath name]);
        if numel(size(gt))>2
            gt = rgb2gray(gt);
        end
        if ~islogical(gt)
            gt = gt(:,:,1) > 128;
        end
        
        %load salency
        
        if strcmp(extra_methods{k},'our_CSV')
            smapName=fullfile(salMapPath, extra_methods{k});   % save result
            sal  = imread([smapName '\' name(1:end-4)  '.png']);
        else
            smapName=fullfile(salMapPath, extra_methods{k});   % save result
            sal  = imread([smapName '\' name(1:end-4) '_' extra_methods{k} '.png']);
        end
        
        %check size
        if size(sal, 1) ~= size(gt, 1) || size(sal, 2) ~= size(gt, 2)
            sal = imresize(sal,size(gt));
%             imwrite(sal,[smapName name]);
%             fprintf('Error occurs in the path: %s!!!\n', [smapName name]);
        end
        sal = im2double(sal(:,:,1));
        
        %normalize sal to [0, 1]
        sal = reshape(mapminmax(sal(:)',0,1),size(sal));
        temp = Fmeasure_calu(sal,double(gt),size(gt)); % Using the 2 times of average of sal map as the threshold.
        Fmeasure(i) = temp(3);
        MAE(i) = mean2(abs(double(logical(gt)) - sal));
        precision(i) = temp(1);
        recall(i) = temp(2);
    end
   
    Fm = mean2(Fmeasure);
    mae = mean2(MAE); 
    Prec = mean2(precision);
    Recall = mean2(recall);
    all_roc_fmeasure_data_measure=[Fm mae Prec Recall];
    filename =[extra_methods{k} '_CSSD200.mat'];
    save(filename,'all_roc_fmeasure_data_measure','-v7.3','-nocompression')
end
   
    % *******************************************************************************%
 
    
end