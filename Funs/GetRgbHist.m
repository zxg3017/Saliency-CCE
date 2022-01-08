function [count,img] = GetRgbHist(img)
%GetRgbHist---��ȡͼ��ֱ��ͼ
%filename-----ͼ���ļ�����ͼ�����·��
%count--------ͼ��ֱ��ͼ

[N1,N2,Chn] = size(img);
%info.BitDepth=24ʱ�������RGBͼ�񣬷����ǻҶ�ͼ��
if Chn== 3 
    [count1,x] = imhist(img(:,:,1));  %����Rͨ����ֱ��ͼ
    [count2,x] = imhist(img(:,:,2));  %����Rͨ����ֱ��ͼ
    [count3,x] = imhist(img(:,:,3));  %����Rͨ����ֱ��ͼ
    %��������תΪһά��ֱ��ͼ
    count = [count1,count2,count3]; 
    count = reshape(count,256*3,1);
else
    count = imhist(img);
end

count = count/(N1*N2);  %��һ��������ͼ���������⡣
end

