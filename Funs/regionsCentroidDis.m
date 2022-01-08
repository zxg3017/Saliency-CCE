function centDisW=regionsCentroidDis(labels)
%% Centroid distance weights computing
% Code Author: Xiaogen Zhou
% Email: xiaogenzhou@126.com
% Date: 25/07/2019

numlabels=length(unique(labels));
[wid,hei,Z]=size(labels);
c_y=(wid/2);%Y
c_x=(hei/2);%X
centDisW=zeros(numlabels,1);
L=(sqrt(wid^2+hei^2)/2);
for i=1:numlabels
    label_region=zeros(size(labels,1),size(labels,2));
    label_region(find(labels==i))=1;% the bw region of the ith label
    stats_centroid = regionprops(label_region,'Centroid');%the centroid of this region 
    x=(stats_centroid(1).Centroid(1));
    y=(stats_centroid(1).Centroid(2));
    dis=((x-c_x)^2)+((y-c_y)^2 + eps);
    centDisW(i)=sqrt(dis)/L;
end
end