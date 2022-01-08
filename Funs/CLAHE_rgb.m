function result=CLAHE_rgb(img)
[row,wid,chn]=size(img);
if chn>1
    figure;
    subplot(1, 3, 1); imhist(img(:,:,1)); title('原始图像R直方图');
    subplot(1, 3, 2); imhist(img(:,:,2)); title('原始图像G直方图');
    subplot(1, 3, 3); imhist(img(:,:,3)); title('原始图像B直方图');
    
    img_r=img(:,:,1);
    img_g=img(:,:,2);
    img_b=img(:,:,3);
    adapthisteq_r=adapthisteq(img_r);
    adapthisteq_g=adapthisteq(img_g);
    adapthisteq_b=adapthisteq(img_b);
    result=cat(3,adapthisteq_r,adapthisteq_g,adapthisteq_b);
    
    figure;
    subplot(1,2,1),imshow(img),title('原始图像');
    subplot(1,2,2),imshow(adapthisteq_img),title('经过CLAHE的增强图像');
    
    figure;
    subplot(1, 3, 1); imhist(adapthisteq_img(:, :, 1)); title('增强图像R直方图');
    subplot(1, 3, 2); imhist(adapthisteq_img(:, :, 2)); title('增强图像G直方图');
    subplot(1, 3, 3); imhist(adapthisteq_img(:, :, 3)); title('增强图像B直方图');
else
    result=adapthisteq(img);

end