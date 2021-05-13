function [y1,y2,x1,x2,rows,count_y]=RowSegmentation(img)
%返回行分割的结果，即每一行左上、左下、右上、右下坐标、行数、水平投影直方图
%img必须是二值图
if(~islogical(img))
    img=imbinarize(img,0.5);
end

[h,w]=size(img);

% 纵向扫描，确定y方向上的文字区域
count_y=w-sum(img,2);
k=1;%行数
y1(k)=1;y2(k)=2;
while(y1(k)<h-20)
    while(count_y(y1(k),1)==0&&y1(k)<h-1) %该方向上大于等于3个黑色像素点，则认为是边界
        y1(k)=y1(k)+1;
    end
    y2(k)=y1(k)+1;
    while(count_y(y2(k),1)>=1&&y2(k)<h)
        y2(k)=y2(k)+1;
    end
    if(y2(k)==y1(k)+1) %说明没有字了
        break;
    end
    y1(k+1)=y2(k)+1;
    k=k+1;   
end
k=k-1;
rows=k;

% 逐行剪切，结果存储在test_img\rows\文件夹下
mkdir('test_img\rows');
x1=zeros(1,k);x2=zeros(1,k);
for i=1:k
    img1=img(y1(i):y2(i),:);
    % 横向扫描，确定x方向上的文字区域
    [h,w]=size(img1); % 要重新确定h！
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
    img_row=bwareaopen(img_row,3);%删除杂质点
    img_row=~img_row;

%     imshow(img1);
    imwrite(img_row,['test_img\rows\row',num2str(i),'.png']);
end

end