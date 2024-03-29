function [count,img] = GetRgbHist(img)
%GetRgbHist---获取图像直方图
%filename-----图像文件名或图像绝对路径
%count--------图像直方图

[N1,N2,Chn] = size(img);
%info.BitDepth=24时计算的是RGB图像，否则是灰度图。
if Chn== 3 
    [count1,x] = imhist(img(:,:,1));  %计算R通道的直方图
    [count2,x] = imhist(img(:,:,2));  %计算R通道的直方图
    [count3,x] = imhist(img(:,:,3));  %计算R通道的直方图
    %下面两行转为一维的直方图
    count = [count1,count2,count3]; 
    count = reshape(count,256*3,1);
else
    count = imhist(img);
end

count = count/(N1*N2);  %归一化处理解决图像缩放问题。
end

