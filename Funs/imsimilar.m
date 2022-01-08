function value = imsimilar( count1,count2,type)
%imsimilar---�������ƶ�
%count1------ֱ��ͼ1
%count2------ֱ��ͼ2
%value-------���ƶ�

N1 = length(count1);
N2 = length(count2);

if N1~=N2
    fprintf('N1<>N2');
    value = 0;
    fprintf('ά�ȳ���');
    return ;
end


result = 0;
% type=1ʱ����ʽһ���㣬���򰴹�ʽ������
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
   % fprintf('���ƶ�Ϊ��%s%%\n',num2str(value));
end

