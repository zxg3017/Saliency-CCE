function [cont,brigt] = contrastAndBrightness(img)
% compute the brightness and contrast
% Code Author: Xiaogen Zhou
% Email: xiaogenzhou@126.com
% Date: 25/07/2019
[m,n,chn]=size(img);
if chn==3
    img=rgb2gray(img);
end
img=double(img);
k=0;
brigt=mean2(img);  %compute the brightness
for i=1:m
    for j=1:n
        k=k+(img(i,j)-brigt).^2;
    end
end
cont=sqrt(k/(m*n));%compute the contrast

end