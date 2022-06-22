%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This code implements the proposed method: Saliency-CCE: Exploiting Colour
% Contextual Extractor and Saliency-based Skin Lesion Segmentation
%
% Project page: https://github.com/zxg2017/Saliency-CCE
%
%
% Copyright (C) 2022 Xiaogen Zhou 
%
% The usage of this code is restricted for non-profit research usage only and using of the code is at the user's risk.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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

imgPath = '/mnt/ai2019/zxg_FZU/dataset/skin_lesion_data/seg/train/Images/';

rstPath = '/mnt/ai2019/zxg_FZU/dataset/skin_lesion_data/cce-net/train/my_graythresh/';

%% Read Images
imgJPG = dir([imgPath, '*.jpg']);
imgs   = [imgJPG,];


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
        img = imresize(img,[224 224]);

        %% Step1£º construct the Colour Contextual Extractor (CCE) Module
        [ccv,ccv_refined] = myColorChannelVolume(img); %% build the Colour Channel Volume (CCV)
        [ccv_salmap,salmap,ccv_w,Sw,S] = CAM(img,ccv, param); %% build the Colour Activation Mapping (CAM)
        %% proudce the final saliency map
        salMap = (double(ccv_refined) + double(ccv_salmap)+double(salmap))/3;
        %salMap = my_img_refined(salMap); 
        salMap =AT_main(salMap); 
        %% Step2: build the Adaptive Threshold (AT) Strategy for Image Segmentation
        AT_rest = my_img_refined_graythresh(salMap);
        
        imwrite(AT_rest, [rstPath, imgname, '.png']);
        
        % 		t2 = clock;
        % 		fprintf('(Time: %fs)\n', etime(t2,t1));
    end
end


