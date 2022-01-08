function value = imsimilar( count1,count2,type)
%imsimilar---计算相似度
%count1------直方图1
%count2------直方图2
%value-------相似度

N1 = length(count1);
N2 = length(count2);

if N1~=N2
    fprintf('N1<>N2');
    value = 0;
    fprintf('维度出错！');
    return ;
end


result = 0;
% type=1时按公式一计算，否则按公式二计算
if type==2
for x = 1:N1
    den = max(count1(x),count2(x));
    if den == 0 
        den = 1;
    end
    result = result+(1-abs(count1(x)-count2(x))/den);   
end
    value = 100*result/N1;
else
    for x = 1:N1
       result = result+min(count1(x),count2(x)); 
    end
    value = result*100;
end
   % fprintf('相似度为：%s%%\n',num2str(value));
end

