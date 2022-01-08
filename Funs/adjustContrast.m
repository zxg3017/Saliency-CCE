function result=adjustContrast(img)

% [wid,hei,Z]=size(img);
% center_X=wid/2;
% center_Y=hei/2;
% wid_len=30;
% center_X_Y=img(center_X-wid_len:center_X+wid_len,center_Y-wid_len:center_Y+wid_len);
% center_gray_level=mean(center_X_Y(:));
% if center_gray_level<110
%     adj_sigma=0.2;
% elseif center_gray_level<130
%     adj_sigma=0.3;
% elseif center_gray_level<140
%     adj_sigma=0.4;
% else
%     adj_sigma=0.5;
% end
level=graythresh(img);     %确定灰度阈值

if level>=0.45 %|| level<=0.25
    adj_sigma=0.3;
else
    adj_sigma=0.21;
end


N_img=Normalization_1_255(img,1);% normmlization of the cv_lab

result=adjcontrast(uint8(N_img), 10, adj_sigma);
%result=Normalization_1_255(adjcontrast_Img,1);% normmlization of the cv_lab
end