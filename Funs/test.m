clc;clear;close all;
%set(gcf,'outerposition',get(0,'screensize'));
%�����Ʋ���
imag1 = '1.jpg';
imag2 = '1.jpg';
[count1,I1] = GetRgbHist(imag1);
[count2,I2] = GetRgbHist(imag2);
value = imsimilar(count1,count2,2);
subplot(2,2,1);
imshow(I1);
title('ԭͼ');
subplot(2,2,2);
imshow(I2);
title('ԭͼ');
h=subplot(2,1,2);
plot(count1);
hold on;
plot(count2,'r');
legend('ԭͼ','ԭͼ',2);
str = sprintf('ͼ��ֱͼ �����Ʋ��� ���ƶ�Ϊ��%s %%',num2str(value));
title(str);

pause;
%ԭͼ������80%
clc;clear;close all;
%set(gcf,'outerposition',get(0,'screensize'));
imag1 = '2.jpg';
imag2 = '23.jpg';
[count1,I1] = GetRgbHist(imag1);
[count2,I2] = GetRgbHist(imag2);
value = imsimilar(count1,count2,2);
subplot(2,2,1);
imshow(I1);
title('ԭͼ');
subplot(2,2,2);
hold on;
imshow(I2);
title('ԭͼ����80%');
subplot(2,1,2);
plot(count1);
hold on;
plot(count2,'r');
legend('ԭͼ','ԭͼ����80%',2);
str = sprintf('ͼ��ֱͼ ԭͼ������80%% ���ƶ�Ϊ��%s %%',num2str(value));
title(str);

pause;
%ԭͼ������50%
clc;clear;close all;
%set(gcf,'outerposition',get(0,'screensize'));
imag1 = '2.jpg';
imag2 = '22.jpg';

[count1,I1] = GetRgbHist(imag1);
[count2,I2] = GetRgbHist(imag2);
value = imsimilar(count1,count2,2);
subplot(2,2,1);
imshow(I1);
title('ԭͼ');
subplot(2,2,2);
imshow(I2);
title('ԭͼ����50');
subplot(2,1,2);
plot(count1);
hold on;
plot(count2,'r');
legend('ԭͼ','ԭͼ����50%',2);
str = sprintf('ͼ��ֱͼ ԭͼ������50%% ���ƶ�Ϊ��%s %%',num2str(value));
title(str);

pause;
%ԭͼ��ԭͼ��ת
clc;clear;close all;
%set(gcf,'outerposition',get(0,'screensize'));hold on;
imag1 = '3.jpg';
imag2 = '31.jpg';
[count1,I1] = GetRgbHist(imag1);
[count2,I2] = GetRgbHist(imag2);
value = imsimilar(count1,count2,2);
subplot(2,2,1);
imshow(I1);
title('ԭͼ');
subplot(2,2,2);
imshow(I2);
title('ԭͼ��ת');
subplot(2,1,2);
plot(count1);
hold on;
plot(count2,'r');
legend('ԭͼ','ԭͼ��ת',2);
str = sprintf('ͼ��ֱͼ ԭͼ��ԭͼ��ת ���ƶ�Ϊ��%s %%',num2str(value));
title(str);

pause;
%���Ʋ���
clc;clear;close all;
%set(gcf,'outerposition',get(0,'screensize'));

imag1 = '1.jpg';
imag2 = '12.jpg';
[count1,I1] = GetRgbHist(imag1);
[count2,I2] = GetRgbHist(imag2);
value = imsimilar(count1,count2,2);
subplot(2,2,1);
imshow(I1);
title('ͼ1');
subplot(2,2,2);
imshow(I2);
title('ͼ2');
subplot(2,1,2);
plot(count1);
hold on;
plot(count2,'r');
legend('ͼ1','ͼ2',2);
str = sprintf('ͼ��ֱͼ ���Ʋ��� ���ƶ�Ϊ��%s %%',num2str(value));
title(str);

pause;
%�������
clc;clear;close all;
%set(gcf,'outerposition',get(0,'screensize'));
imag1 = '2.jpg';
imag2 = '12.jpg';
[count1,I1] = GetRgbHist(imag1);
[count2,I2] = GetRgbHist(imag2);
value = imsimilar(count1,count2,2);
subplot(2,2,1);
imshow(I1);
title('ͼ1');
subplot(2,2,2);
imshow(I2);
title('ͼ2');
subplot(2,1,2);
plot(count1);
hold on;
plot(count2,'r');
legend('ͼ1','ͼ2',2);
str = sprintf('ͼ��ֱͼ ������� ���ƶ�Ϊ��%s %%',num2str(value));
title(str);
