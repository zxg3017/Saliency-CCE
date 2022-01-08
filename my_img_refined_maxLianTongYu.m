function img_refined = my_img_refined_maxLianTongYu(img)

%% Parameter Settings
param.resize_width = 224;
param.delta		   = 8;
param.omega_c	   = 14;
param.omega_r      = 14;
param.theta_r	   = 0.02;
param.theta_g	   = 1.5;


img_refined = mat2gray(img);
img_refined = reconstruct(img_refined, param);
img_refined = im2uint8(mat2gray(img_refined));
img_refined = adjust(img_refined, param.theta_r, param.theta_g);
img_refined = imfill(img_refined, 'holes');	% S_w
img_refined = maxLianTongYu(img_refined,1);
end


function img_refined = my_img_refined_graythresh(img)

%% Parameter Settings
param.resize_width = 224;
param.delta		   = 8;
param.omega_c	   = 14;
param.omega_r      = 14;
param.theta_r	   = 0.02;
param.theta_g	   = 1.5;


img_refined = mat2gray(img);
img_refined = reconstruct(img_refined, param);
img_refined = im2uint8(mat2gray(img_refined));
img_refined = adjust(img_refined, param.theta_r, param.theta_g);
img_refined = imfill(img_refined, 'holes');	% S_w
level=graythresh(img_refined);     %determine the threshold
img_refined = maxLianTongYu(img_refined,2);
end

function img_refined = my_img_refined_MHT_main(img)

%% Parameter Settings
param.resize_width = 224;
param.delta		   = 8;
param.omega_c	   = 14;
param.omega_r      = 14;
param.theta_r	   = 0.02;
param.theta_g	   = 1.5;


img_refined = mat2gray(img);
img_refined = reconstruct(img_refined, param);
img_refined = im2uint8(mat2gray(img_refined));
img_refined = adjust(img_refined, param.theta_r, param.theta_g);
img_refined = imfill(img_refined, 'holes');	% S_w
img_refined = MHT_main(IMG);
img_refined = maxLianTongYu(img_refined,2);
end

%% Adjust Image Intensity Values
function X = adjust(I, ratio, gamma)
C = unique(I(:));
tmpsum = 0;
for k = 1:length(C)
    tmpsum = tmpsum + length(find(I==C(k)));
    if tmpsum >= numel(I) * (1-ratio)
        break;
    end
end
if C(k) > 0
    X = imadjust(I, [0,double(C(k))/255], [0,1], gamma);
else
    X = I;
end
end


%% Weights
function [W, w] = calcWeight(img, param)
w2c = evalin('base','w2c');
cnimg = im2c(img, w2c, 0);

color_count = zeros(11,1);
C = unique(cnimg(:));
for k = 1:length(C)
    color_count(C(k)) = length(find(cnimg(:)==C(k)));
end

W = cell(11,1);
for k = 1:11
    tmp = zeros(size(img,1), size(img,2));
    ind = cnimg(:)==k;
    tmp(ind) = color_count(k)/size(img,1)/size(img,2);
    W{k} = tmp;
end

w = zeros(11,1);
for m = 1:11
    if color_count(m) ~= 0
        for n = 1:11
            w(m) = w(m) + color_count(n)/size(img,1)/size(img,2)*norm(param.ColorName{m,3}-param.ColorName{n,3})^2;
        end
    end
end
end

%% Morphological Reconstruction
function X = reconstruct(I, param)
se		= strel('disk', param.omega_r);
im		= imerode(I, se);
imr		= imreconstruct(im, I);
% invert
imc		= imdilate(imr, se);
imcr	= imreconstruct(imcomplement(imc), imcomplement(imr));
imcr	= imcomplement(imcr); % 对图像数据进行取反运算（实现底片效果）。
X  = imcr;
end

