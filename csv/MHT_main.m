function seg_result=MHT_main(IMG)
%% find the peaks and thresholds (valleys) of histogram from a grayscale image
% Code Author: Xiaogen Zhou
% Email: xiaogenzhou@126.com
% Date: 25/07/2019
%IMG=double(IMG);
I=uint8(IMG);
imh=imhist(I); % IMHIST Display histogram of N-D image data.
imh_ind=find(imh>-1);% find the index of each gray level
meImh=mean(imh);% get mean value of the imhist

% figure(1);imshow(IMG);title('img');
% figure(2);bar(imh);title('imh');

%% adaptively determine the minpeakheight and minDis
n=4;
m=5;
if meImh>50
    minpeakheight=floor(meImh/(n+1));
else
    minpeakheight=floor(meImh/(n));
end
L1=find(imh>minpeakheight,1);% find the first location L1 on the left that is greater than the mean minpeakheight
L2=find(imh>minpeakheight,1,'last');%  find the first location L2 on the right that is greater than the mean minpeakheight
L=abs(L2-L1);
if L>=150
    minDis=ceil(L/(m));
else
    minDis=ceil(L/(m-1));
end
%% find the peaks of histogram via the matlab function findpeaks
[CNT,PEAKS] = findpeaks(imh,'minpeakdistance',minDis,'minpeakheight',minpeakheight);

%% find the thresholds (valleys) by the peaks
len=length(PEAKS);
if len<1
    PEAKS(1)=minpeakheight/m;
end
len=length(PEAKS);
if len>=4
    %-------------------¡¾find the first valley¡¿------------------------
    freq_map=imh(PEAKS(1):PEAKS(2)); % the frequency between PEAKS(1) and PEAKS(2)
    ind_map=imh_ind(PEAKS(1):PEAKS(2)); % the grayscale value between PEAKS(1) and PEAKS(2)
    V_first=min(imh(PEAKS(1):PEAKS(2))); % the lowest frequency between PEAKS(1) and PEAKS(2)
    V_first_grayscale=ind_map(find(freq_map==V_first,1))-1;% the grayscale value of the first valley
    
    %-------------------¡¾find the second valley¡¿------------------------
    freq_map=imh(PEAKS(2):PEAKS(3)); % the frequency between PEAKS(1) and PEAKS(2)
    ind_map=imh_ind(PEAKS(2):PEAKS(3)); % the grayscale value between PEAKS(1) and PEAKS(2)
    V_second=min(imh(PEAKS(2):PEAKS(3))); % the lowest frequency between PEAKS(1) and PEAKS(2)
    V_second_grayscale=ind_map(find(freq_map==V_second,1))-1;% the grayscale value of the first valley
    
    %-------------------¡¾find the last valley¡¿------------------------
    freq_map=imh(PEAKS(len-1):PEAKS(len)); % the frequency between PEAKS(1) and PEAKS(2)
    ind_map=imh_ind(PEAKS(len-1):PEAKS(len)); % the grayscale value between PEAKS(2) and PEAKS(3)
    V_last=min(imh(PEAKS(len-1):PEAKS(len))); % the lowest frequency between PEAKS(2) and PEAKS(3)
    V_last_grayscale=ind_map(find(freq_map==V_last,1))-1;% the grayscale value of the last valley
    
elseif len==3
    
    %-------------------¡¾find the first valley¡¿------------------------
    freq_map=imh(PEAKS(1):PEAKS(2)); % the frequency between PEAKS(1) and PEAKS(2)
    ind_map=imh_ind(PEAKS(1):PEAKS(2)); % the grayscale value between PEAKS(1) and PEAKS(2)
    V_first=min(imh(PEAKS(1):PEAKS(2))); % the lowest frequency between PEAKS(1) and PEAKS(2)
    V_first_grayscale=ind_map(find(freq_map==V_first,1))-1;% the grayscale value of the first valley
    %-------------------¡¾find the last valley¡¿------------------------
    freq_map=imh(PEAKS(2):PEAKS(3)); % the frequency between PEAKS(1) and PEAKS(2)
    ind_map=imh_ind(PEAKS(2):PEAKS(3)); % the grayscale value between PEAKS(2) and PEAKS(3)
    V_last=min(imh(PEAKS(2):PEAKS(3))); % the lowest frequency between PEAKS(2) and PEAKS(3)
    V_last_grayscale=ind_map(find(freq_map==V_last,1))-1;% the grayscale value of the last valley
elseif len==2
    %-------------------¡¾find the first or last valley¡¿------------------------
    freq_map=imh(PEAKS(1):PEAKS(2)); % the frequency between PEAKS(1) and PEAKS(2)
    ind_map=imh_ind(PEAKS(1):PEAKS(2)); % the grayscale value between PEAKS(1) and PEAKS(2)
    V_freq=min(imh(PEAKS(1):PEAKS(2))); % the lowest frequency between PEAKS(1) and PEAKS(2)
    V_first_grayscale=ind_map(find(freq_map==V_freq,1))-1;% the grayscale value of the first valley
    V_last_grayscale=ind_map(find(freq_map==V_freq,1))-1;% the grayscale value of the first valley
elseif len==1
    V_last_grayscale=PEAKS(1);
else
    warning([' Results may not be accurate.' 'Please recfication you code : ' ]);
end

seg_result=Binarization(IMG,V_last_grayscale,2);   % obtain the binary image by the threshod V_last_grayscale

end