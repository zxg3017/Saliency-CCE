%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This code implements the proposed salient object detection model in the following paper:
% 
% Jing Lou*, Huan Wang, Longtao Chen, Fenglei Xu, Qingyuan Xia, Wei Zhu, Mingwu Ren*, 
% "Exploiting Color Name Space for Salient Object Detection," Multimedia Tools and Applications, 
% vol. 79, no. 15, pp. 10873-10897, 2020. doi:10.1007/s11042-019-07970-x
% 
% Project page: http://http://www.loujing.com/cns-sod/
%
% References:
%   [46] van de Weijer J, Schmid C, Verbeek J (2007) Learning color names from real-world images. 
%        In: Proceedings of the IEEE conference on computer vision and pattern recognition, pp 1-8
%   [52] Zhang J, Sclaroff S (2013) Saliency detection: a Boolean map approach. 
%        In: Proceedings of the IEEE international conference on computer vision, pp 153-160
%
%
% Copyright (C) 2020 Jing Lou (Â¥¾º)
% 
% The usage of this code is restricted for non-profit research usage only and using of the code is at the user's risk.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clc; clear; close all;

load w2c;


%% Parameter Settings
param.resize_width = 400;
param.delta		   = 8;
param.omega_c	   = 14;
param.omega_r      = 14;
param.theta_r	   = 0.02;
param.theta_g	   = 1.5;


%% Path
if exist('SalMaps', 'dir') ~= 7
    system('md SalMaps');
end

imgPath = '/mnt/ai2019/zxg_FZU/dataset/result/my_att_unet/';
refinedPath = '/mnt/ai2019/zxg_FZU/dataset/result/ours/';

%% Read Images
imgs = dir([imgPath, '*.jpg']);

for imgno = 1:length(imgs)	
    imgname = imgs(imgno).name;
	if exist([refinedPath, imgname(1:end-4), '.png'], 'file') ~= 0
		fprintf('%04d/%04d - %s\n', imgno, length(imgs), imgname);

		img = imread([imgPath, imgname]);
	
        refined_refined = my_img_refined(img);

%         subplot(3, 3, 1); imshow(uint8(img)); title('img');
%         subplot(3, 3, 2); imshow(refined_refined); title('refined_refined');
%         subplot(3, 3, 3); imshow(uint8(csv_refined)); title('csv_refined');
%         subplot(3, 3, 4); imshow(uint8(csv_refined_refined)); title('csv_refined_refined');
%         subplot(3, 3, 5); imshow(uint8(CNS_salmap_refined)); title('CNS_salmap_refined');
%         subplot(3, 3, 6); imshow(uint8(CNS_salmap)); title('CNS_salmap');
%         subplot(3, 3, 7); imshow(uint8(rst_r)); title('rst_r');
%         subplot(3, 3, 8); imshow(uint8(rst_r_refined)); title('rst_r_refined');

        
		imwrite(refined_refined, [refinedPath, imgname(1:end-4), '.png']);
	end
end


