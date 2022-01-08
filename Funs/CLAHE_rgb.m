function result=CLAHE_rgb(img)
[row,wid,chn]=size(img);
if chn>1
    figure;
    subplot(1, 3, 1); imhist(img(:,:,1)); title('ԭʼͼ��Rֱ��ͼ');
    subplot(1, 3, 2); imhist(img(:,:,2)); title('ԭʼͼ��Gֱ��ͼ');
    subplot(1, 3, 3); imhist(img(:,:,3)); title('ԭʼͼ��Bֱ��ͼ');
    
    img_r=img(:,:,1);
    img_g=img(:,:,2);
    img_b=img(:,:,3);
    adapthisteq_r=adapthisteq(img_r);
    adapthisteq_g=adapthisteq(img_g);
    adapthisteq_b=adapthisteq(img_b);
    result=cat(3,adapthisteq_r,adapthisteq_g,adapthisteq_b);
    
    figure;
    subplot(1,2,1),imshow(img),title('ԭʼͼ��');
    subplot(1,2,2),imshow(adapthisteq_img),title('����CLAHE����ǿͼ��');
    
    figure;
    subplot(1, 3, 1); imhist(adapthisteq_img(:, :, 1)); title('��ǿͼ��Rֱ��ͼ');
    subplot(1, 3, 2); imhist(adapthisteq_img(:, :, 2)); title('��ǿͼ��Gֱ��ͼ');
    subplot(1, 3, 3); imhist(adapthisteq_img(:, :, 3)); title('��ǿͼ��Bֱ��ͼ');
else
    result=adapthisteq(img);

end