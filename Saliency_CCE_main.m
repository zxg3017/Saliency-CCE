%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This code implements the proposed method: Saliency-CCE: Exploiting Colour
% Contextual Extractor and Saliency-based Biomedical Image Segmentation
%
% Project page: https://github.com/zxg2017/Saliency-CCE
% 
%
% Copyright (C) 2022 Xiaogen Zhou 
%
% The usage of this code is restricted for non-profit research usage only and using of the code is at the user's risk.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath '/mnt/ai2019/zxg_FZU/matlab_project/Saliency-CCE/hair-removal'

clc; clear; close all;
addpath(genpath('Funcs'));
load w2c;


%% Parameter Settings
param.resize_width = 224;
param.delta		   = 8;
param.omega_c	   = 14;
param.omega_r      = 14;
param.theta_r	   = 0.02;
param.theta_g	   = 1.5;

%imgPath = '/mnt/ai2021/zxg/dataset/ISIB_2016/test/image/';
imgPath = '/mnt/ai2021/zxg/dataset/ISIB_2016/with_hair/img/';
rstPath = '/mnt/ai2021/zxg/dataset/ISIB_2016/test/seg_result_with_hair_remove/';
salMap_rstPath = '/mnt/ai2021/zxg/dataset/ISIB_2016/test/seg_result_with_hair_remove_sal/';
hair_remove_path='/mnt/ai2021/zxg/dataset/ISIB_2016/test/ISIB2017/without_hair_remove/';
CAM_path='/mnt/ai2021/zxg/dataset/ISIB_2016/with_hair/matt/';

%% Read Images
imgJPG = dir([imgPath, '*.jpg']);
imgs   = [imgJPG,];

N = 224;% N is a parameter, which is can adapt for [112, 224, 448 ...]
%% Saliency-CCE
for imgno = 1:length(imgs)
    imgname = imgs(imgno).name;
    if exist([rstPath, imgname(1:end-4), '.png'], 'file') == 0
        %t1 = clock;
        fprintf('%04d/%04d - %s\n', imgno, length(imgs), imgname);
        img = imread([imgPath, imgname]);
        if length(size(img)) == 2
            img= cat(3,img,img,img);
        end
        img = imresize(img,[N N]);
        
        %% hair remove
        [hair_remov_result,M,K]=hair_remover_main(img);
        %imwrite(hair_remov_result, [hair_remove_path, imgname, '.png']);

        %% Step1： construct the Colour Contextual Extractor (CCE) Module
        [ccv,ccv_refined] = myColorChannelVolume(hair_remov_result); %% build the Colour Channel Volume (CCV)
%         imwrite(ccv, [CCV_path, imgname, '.png']);

        [CAM_result,salmap,ccv_w,Sw,S] = CAM(hair_remov_result,ccv, param); %% build the Colour Activation Mapping (CAM)
        
        
        %% proudce the final saliency map
        salMap = (double(ccv_refined) +double(salmap))/2 + double(CAM_result);
        salMap = my_img_refined(salMap); 
        imwrite(salMap, [CAM_path, imgname, '.png']);

        %% Step2: build the Adaptive Threshold (AT) Strategy for Image Segmentation
%         AT_rest = my_img_refined_graythresh(salMap);
        AT_rest = AT_main(salMap);
        
%         imwrite(salMap, [salMap_rstPath, imgname, '_sal.png']);
% 
%         imwrite(AT_rest, [hair_remove_path, imgname, '.png']);
        
        % 		t2 = clock;
        % 		fprintf('(Time: %fs)\n', etime(t2,t1));
    end
end


