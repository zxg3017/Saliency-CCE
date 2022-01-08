clc;clear;close all;
%set(gcf,'outerposition',get(0,'screensize'));
%自相似测试
imag1 = '1.jpg';
imag2 = '1.jpg';
[count1,I1] = GetRgbHist(imag1);
[count2,I2] = GetRgbHist(imag2);
value = imsimilar(count1,count2,2);
subplot(2,2,1);
imshow(I1);
title('原图');
subplot(2,2,2);
imshow(I2);
title('原图');
h=subplot(2,1,2);
plot(count1);
hold on;
plot(count2,'r');
legend('原图','原图',2);
str = sprintf('图像方直图 自相似测试 相似度为：%s %%',num2str(value));
title(str);

pause;
%原图与缩放80%
clc;clear;close all;
%set(gcf,'outerposition',get(0,'screensize'));
imag1 = '2.jpg';
imag2 = '23.jpg';
[count1,I1] = GetRgbHist(imag1);
[count2,I2] = GetRgbHist(imag2);
value = imsimilar(count1,count2,2);
subplot(2,2,1);
imshow(I1);
title('原图');
subplot(2,2,2);
hold on;
imshow(I2);
title('原图缩放80%');
subplot(2,1,2);
plot(count1);
hold on;
plot(count2,'r');
legend('原图','原图缩放80%',2);
str = sprintf('图像方直图 原图与缩放80%% 相似度为：%s %%',num2str(value));
title(str);

pause;
%原图与缩放50%
clc;clear;close all;
%set(gcf,'outerposition',get(0,'screensize'));
imag1 = '2.jpg';
imag2 = '22.jpg';

[count1,I1] = GetRgbHist(imag1);
[count2,I2] = GetRgbHist(imag2);
value = imsimilar(count1,count2,2);
subplot(2,2,1);
imshow(I1);
title('原图');
subplot(2,2,2);
imshow(I2);
title('原图缩放50');
subplot(2,1,2);
plot(count1);
hold on;
plot(count2,'r');
legend('原图','原图缩放50%',2);
str = sprintf('图像方直图 原图与缩放50%% 相似度为：%s %%',num2str(value));
title(str);

pause;
%原图与原图旋转
clc;clear;close all;
%set(gcf,'outerposition',get(0,'screensize'));hold on;
imag1 = '3.jpg';
imag2 = '31.jpg';
[count1,I1] = GetRgbHist(imag1);
[count2,I2] = GetRgbHist(imag2);
value = imsimilar(count1,count2,2);
subplot(2,2,1);
imshow(I1);
title('原图');
subplot(2,2,2);
imshow(I2);
title('原图旋转');
subplot(2,1,2);
plot(count1);
hold on;
plot(count2,'r');
legend('原图','原图旋转',2);
str = sprintf('图像方直图 原图与原图旋转 相似度为：%s %%',num2str(value));
title(str);

pause;
%近似测试
clc;clear;close all;
%set(gcf,'outerposition',get(0,'screensize'));

imag1 = '1.jpg';
imag2 = '12.jpg';
[count1,I1] = GetRgbHist(imag1);
[count2,I2] = GetRgbHist(imag2);
value = imsimilar(count1,count2,2);
subplot(2,2,1);
imshow(I1);
title('图1');
subplot(2,2,2);
imshow(I2);
title('图2');
subplot(2,1,2);
plot(count1);
hold on;
plot(count2,'r');
legend('图1','图2',2);
str = sprintf('图像方直图 近似测试 相似度为：%s %%',num2str(value));
title(str);

pause;
%相异测试
clc;clear;close all;
%set(gcf,'outerposition',get(0,'screensize'));
imag1 = '2.jpg';
imag2 = '12.jpg';
[count1,I1] = GetRgbHist(imag1);
[count2,I2] = GetRgbHist(imag2);
value = imsimilar(count1,count2,2);
subplot(2,2,1);
imshow(I1);
title('图1');
subplot(2,2,2);
imshow(I2);
title('图2');
subplot(2,1,2);
plot(count1);
hold on;
plot(count2,'r');
legend('图1','图2',2);
str = sprintf('图像方直图 相异测试 相似度为：%s %%',num2str(value));
title(str);
