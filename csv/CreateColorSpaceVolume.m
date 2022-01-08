function main()
% Build the color space volume based on Lab color space.

% Code Author: Xiaogen Zhou
% Email: xiaogenzhou@126.com
% Date: 25/07/2019

addpath '/media/zxg/基督得胜1/source_code/saliency_detection/saliencyDetection_latest/Funs'



img_path = '/mnt/ai2019/zxg_FZU/dataset/skin_lesion_data/train/Images/';

src_Suffix = '.jpg';    % .png    %suffix for your input ground truth image
img_files = dir(fullfile(img_path, strcat('*', src_Suffix)));

%% 1. Parameter Settings
len=length(img_files);
for K=1:len

    fprintf('Evaluating: %d/%d\n',K,len);
    ori_srcName = img_files(K).name;
%     ori_srcName='0098.png'
    ori_noSuffixName = ori_srcName(1:end-length(src_Suffix));
    img = imread(fullfile(img_path, ori_srcName));
    
    
    %%% 构造color space volume
    
    res_img = imresize(img,[1024 NaN]);
    
    csv = getColorSpaceVolume(res_img);  
    
%     csv(find(csv<25))=0;
    
    
    w = size(img,1);
    h = size(img,2);
    csv = imresize(csv,[w h]);

    %%% 保存结果图片
    csv_=fullfile(rest_path, strcat(ori_noSuffixName, '.png'));%
    imwrite(csv, csv_);
    
    

end
end


function csv = getColorSpaceVolume(img)

img = double(img);
R=img(:,:,1);%R
G=img(:,:,2);%G
B=img(:,:,3);%B

% rgb_img = cat(3,R,G,B);



% JDark = darkChannel(img);

%% the formula of our color space volume in Eq.(1)-(2)
[L,a,b] = RGB2Lab(R,G,B);
% cat_res = cat(3,B,B,B);
% cat_lab = cat(3,L,a,b);

res = (1/2*(B-L)-a).*a;




N_a_1=Normalization_1_255(a,1);% normalized for the a* component to with a range of [0 255],

% N_L=Normalization_1_255(L,2);% normalized for the a* component to with a range of [0 255],
% N_B=Normalization_1_255(B,2);% normalized for the a* component to with a range of [0 255],

L_a=(L).*a;
csv_Lab=(1.0/4.0)*pi*L_a;
csv_Lab=csv_Lab.*(b+N_a_1);% the formula of our color space volume in Eq.(1)
csv_Lab=csv_Lab.*(b+a);% the formula of our color space volume in Eq.(1)

N_csv_Lab=Normalization_1_255(csv_Lab,1);% normalized for the csv_Lab to with a range of [0 255],

csv= adjust(uint8(N_csv_Lab), 0.02, 1.0);

subplot(3, 2, 1); imshow(uint8(img)); title('img');
subplot(3, 2, 2); imshow(uint8(L)); title('L');
subplot(3, 2, 3); imshow(uint8(res)); title('res');
subplot(3, 2, 4); imshow(N_csv_Lab); title('N_csv_Lab');
% subplot(3, 2, 5); imshow(maxConImg); title('maxConImg');
% subplot(3, 2, 6); imshow(imfConImg); title('imfConImg');
% subplot(3, 5, 9); imshow(uint8(final_rst)); title('final_rst');
% subplot(3, 5, 10); imshow(uint8(adj_B)); title('adj_B');
% subplot(3, 5, 11); imshow(uint8(final_res)); title('final_res');
% subplot(3, 5, 12); imshow(uint8(N_csv_L_B)); title('N_csv_L_B');
% % subplot(3, 5, 13); imshow(uint8(N_csv_rst_B)); title('N_csv_rst_B');
% subplot(3, 5, 13); imshow(uint8(N_csv_B_a)); title('N_csv_B_a');
% subplot(3, 5, 14); imshow(uint8(adj_final_res)); title('adj_final_res');
% subplot(3, 5, 15); imshow(uint8(new_csv)); title('new_csv');
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

function rst = activateFun(img,flag)
if flag ==1 
    rst = max(0,img);
else 
    rst = img;
end
end
