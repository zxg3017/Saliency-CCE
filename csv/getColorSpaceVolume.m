% function  csv= getCSV(img)
% 
% 
% [N_csv_Lab,L,N_a,N_b]=CreateColorSpaceVolume(img);
% salmap = adjust(salmap, 0.02, 1.5);
% 
% 
% end




function [N_csv_Lab,L,N_a,N_b]=CreateColorSpaceVolume(img)
% Build the color space volume based on Lab color space.

% Code Author: Xiaogen Zhou
% Email: xiaogenzhou@126.com
% Date: 25/07/2019

img = double(img);
R=img(:,:,1);%R
G=img(:,:,2);%G
B=img(:,:,3);%B

%% the formula of our color space volume in Eq.(1)-(2)
[L,a,b] = RGB2Lab(R,G,B);
act_a = activateFun(a,1);
act_b = activateFun(b,1);
N_a=Normalization_1_255(act_a,2);% normalized for the a* component to with a range of [0 255],
N_b=Normalization_1_255(act_b,2);% normalized for the a* component to with a range of [0 255],
N_L=Normalization_1_255(L,2);% normalized for the a* component to with a range of [0 255],
N_B=Normalization_1_255(B,2);% normalized for the a* component to with a range of [0 255],

L_a=L.*act_a;
csv_Lab=(1.0/4.0)*pi*L_a;
csv_Lab=csv_Lab.*(act_a+act_b);% the formula of our color space volume in Eq.(1)

csv_1 = (1.0/4.0)*pi*N_L.*(N_B+N_b);
csv_2 = (1.0/4.0)*pi*N_L.*(N_B+N_a);

sigma = 0.3;
exp_csv_1 = exp(-csv_1/(2*sigma^2));
exp_csv_2 = exp(-csv_2/(2*sigma^2));

N_csv_1 = Normalization_1_255(csv_1,1);
N_csv_2 = Normalization_1_255(csv_2,1);

exp_N_csv_1 = Normalization_1_255(exp_csv_1,1);
exp_N_csv_2 = Normalization_1_255(1-exp_csv_2,1);

N_csv_Lab=Normalization_1_255(csv_Lab,1);% normalized for the csv_Lab to with a range of [0 255],

rst = ((exp_N_csv_1 + exp_N_csv_2)*0.5);

rst1 = ((N_csv_1 + N_csv_2)*0.5);


salmap = adjust(uint8(N_csv_1), 0.02, 1.5);
N_salmap = adjust(uint8(N_csv_2), 0.02, 1.5);
rst= adjust(uint8(rst), 0.02, 1.5);
rst1= adjust(uint8(rst1), 0.01, 1.0);

% 
% if mean(a(:))>mean(b(:))
%     csv_Lab=csv_Lab.*(N_b);% the formula of our color space volume in Eq.(1)
% else
%     csv_Lab=csv_Lab.*(N_a);% the formula of our color space volume in Eq.(1)    
% end
subplot(3, 5, 1); imshow(uint8(img)); title('img');
subplot(3, 5, 2); imshow(uint8(L)); title('L');
subplot(3, 5, 3); imshow(uint8(G)); title('G');
subplot(3, 5, 4); imshow(uint8(B)); title('B');
subplot(3, 5, 5); imshow(N_L); title('N_L');
subplot(3, 5, 6); imshow(uint8((exp_N_csv_1 + exp_N_csv_2)*0.5)); title('exp_N_csv_1 + exp_N_csv_2');
subplot(3, 5, 7); imshow(uint8(rst1)); title('rst1');
subplot(3, 5, 8); imshow(uint8(exp_N_csv_1)); title('exp_N_csv_1 B+b');
subplot(3, 5, 9); imshow(uint8(exp_N_csv_2)); title('exp_N_csv_2 B+a');
subplot(3, 5, 10); imshow(uint8(N_csv_1)); title('N_csv_1');
subplot(3, 5, 11); imshow(uint8(N_csv_2)); title('N_csv_2');
subplot(3, 5, 12); imshow(uint8(csv_Lab)); title('csv_Lab');
subplot(3, 5, 13); imshow(salmap); title('salmap');
subplot(3, 5, 14); imshow(uint8(rst)); title('rst');
subplot(3, 5, 15); imshow(uint8(N_salmap)); title('N_salmap');


flag = 1;
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
