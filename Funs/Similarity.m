function [sim1 sim2]=Similarity(picture1,picture2)
% calculate the similarty of two image;
% Code Author: Xiaogen Zhou
% Email: xiaogenzhou@126.com
% Date: 25/07/2019
%%Algorithm steps as following:
% step 1£ºGet the histogram distribution of the two images entered
% step 2£ºThe histogram is divided into 64 zones in turn, that is, each zone has 4 gray levels
% step 3£ºGenerate 64 elements in each of the 64 regions, that is, a vector
% step 4£ºCalculate the cosine similarity of two vectors
% step 5£ºJudgment the similarity
tic
t1=picture1;
[a1,b1]=size(t1);
t2=picture2;
t2=imresize(t2,[a1 b1],'bicubic');%Scale to a consistent size
if max(t1(:))<1
    t1=Normalization_1_255(t1,1);
    t2=Normalization_1_255(t2,1);
end
t1=round(t1);

t2=round(t2);

e1=zeros(1,256);

e2=zeros(1,256);

%Get the histogram distribution

for i=1:a1
    for j=1:b1        
        m1=t1(i,j)+1;     
        m2=t2(i,j)+1;       
        e1(m1)=e1(m1)+1;  
        e2(m2)=e2(m2)+1;      
    end 
end
%Divide the histogram into 64 areas
m1=zeros(1,64);
m2=zeros(1,64);
for i=0:63 
    m1(1,i+1)=e1(4*i+1)+e1(4*i+2)+e1(4*i+3)+e1(4*i+4); 
    m2(1,i+1)=e2(4*i+1)+e2(4*i+2)+e2(4*i+3)+e2(4*i+4);
end
%Calculating cosine similarity
A=sqrt(sum(sum(m1.^2)));
B=sqrt(sum(sum(m2.^2)));
C=sum(sum(m1.*m2));
cos1=C/(A*B);%Calculating the cosine value
cos2=acos(cos1);%radian
v=cos2*180/pi;%Converted to angle
%figure;
%imshow(uint8([t1,t2]));
%title(['ÓàÏÒÖµÎª£º',num2str(cos1),'       ','ÓàÏÒ¼Ð½ÇÎª£º',num2str(v),'¡ã']);
sim1=cos1;

% toc
% disp(['Algorithm runtime: method1: ',num2str(toc)]);
%% The second method: matlab imsimilar
% 
% tic
% 
[count1,I1] = GetRgbHist(t1);
[count2,I2] = GetRgbHist(t2);
value = imsimilar(count1,count2,2);
sim2=value;
% toc
% disp(['Algorithm runtime: method2: ',num2str(toc)]);
end