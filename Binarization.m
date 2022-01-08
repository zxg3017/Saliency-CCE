function binaryImg=Binarization(I,Th,flag)
%% the code is used for image binalization
%I--->input 2-D image
%Th---> a threshold
%bImg---> output the result by binalization
%flag==1: get the region whose grayscale value is lese than the Th;flag=2: get the region whose grayscale value is more than the Th
I=double(I);
[M,N,Z]=size(I);
if Z>1
    I=rgb2gray(I);
end
binaryImg=I;
if flag==1
    
    for i=1:M
        for j=1:N
            if I(i,j)<=Th && I(i,j)~=0
                binaryImg(i,j)=1; %object region
            else
                binaryImg(i,j)=0;%
            end
        end
    end
    
elseif flag==2
    for i=1:M
        for j=1:N
            if I(i,j)>=Th && I(i,j)~=0
                binaryImg(i,j)=1; % object region
            else
                binaryImg(i,j)=0;%
            end
        end
    end
    
end
end