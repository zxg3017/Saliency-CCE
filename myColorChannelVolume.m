function [csv,csv_refined] = myColorChannelVolume(img)

bak_img = img;
img = imresize(img, [224 224]);

%% Parameter Settings
param.resize_width = 224;
param.delta		   = 8;
param.omega_c	   = 14;
param.omega_r      = 14;
param.theta_r	   = 0.02;
param.theta_g	   = 1.5;


img = double(img);
R=img(:,:,1);%R
G=img(:,:,2);%G
B=img(:,:,3);%B

%% the formula of our color channel volume in Eq.(1)-(2)
[L,a,b] = RGB2Lab(R,G,B);
N_a=Normalization_1_255(a,1);
L_a=(L).*a;
csv_Lab=(2.0/3.0)*pi*L_a;
csv_Lab=csv_Lab.*(b+N_a);

N_csv_Lab=Normalization_1_255(csv_Lab,1);% normalized for the csv_Lab to with a range of [0 255],

csv= adjust(uint8(N_csv_Lab), 0.05, 1.00);

csv_Lab = mat2gray(csv_Lab);
csv_Lab_ = reconstruct(csv_Lab, param);
csv_Lab = im2uint8(mat2gray(csv_Lab_));
csv_Lab = adjust(csv_Lab, param.theta_r, param.theta_g);
csv_refined = imfill(csv_Lab, 'holes');	% S_w
csv_refined = imresize(csv_refined, [size(bak_img,1), size(bak_img,2)]);

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
imcr	= imcomplement(imcr);
X  = imcr;
end

function rst = activateFun(img,flag)
if flag ==1
    rst = max(0,img);
else
    rst = img;
end
end