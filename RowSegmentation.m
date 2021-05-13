function [y1,y2,x1,x2,rows,count_y]=RowSegmentation(img)
%�����зָ�Ľ������ÿһ�����ϡ����¡����ϡ��������ꡢ������ˮƽͶӰֱ��ͼ
%img�����Ƕ�ֵͼ
if(~islogical(img))
    img=imbinarize(img,0.5);
end

[h,w]=size(img);

% ����ɨ�裬ȷ��y�����ϵ���������
count_y=w-sum(img,2);
k=1;%����
y1(k)=1;y2(k)=2;
while(y1(k)<h-20)
    while(count_y(y1(k),1)==0&&y1(k)<h-1) %�÷����ϴ��ڵ���3����ɫ���ص㣬����Ϊ�Ǳ߽�
        y1(k)=y1(k)+1;
    end
    y2(k)=y1(k)+1;
    while(count_y(y2(k),1)>=1&&y2(k)<h)
        y2(k)=y2(k)+1;
    end
    if(y2(k)==y1(k)+1) %˵��û������
        break;
    end
    y1(k+1)=y2(k)+1;
    k=k+1;   
end
k=k-1;
rows=k;

% ���м��У�����洢��test_img\rows\�ļ�����
mkdir('test_img\rows');
x1=zeros(1,k);x2=zeros(1,k);
for i=1:k
    img1=img(y1(i):y2(i),:);
    % ����ɨ�裬ȷ��x�����ϵ���������
    [h,w]=size(img1); % Ҫ����ȷ��h��
    count_x=h-sum(img1,1);
    x1(i)=1;
    x2(i)=w;
    while(count_x(1,x1(i))==0&&x1(i)<w)
        x1(i)=x1(i)+1;
    end
    while(count_x(1,x2(i))==0&&x2(i)>1)
        x2(i)=x2(i)-1;
    end
    img_row=img1(:,x1(i):x2(i));
    
    img_row=~img_row;
    img_row=bwareaopen(img_row,3);%ɾ�����ʵ�
    img_row=~img_row;

%     imshow(img1);
    imwrite(img_row,['test_img\rows\row',num2str(i),'.png']);
end

end