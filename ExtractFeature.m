function [feature1,feature2]=ExtractFeature(img)
% 提取单个汉字图片的特征
% 内外轮廓特征32维，用于粗分类；HoG特征144维，用于细分类

img=~img; %黑色背景0，白色笔画1
[h,w]=size(img);

%外轮廓特征+内轮廓特征
%上、下、左、右四个方向，每个方向等分成四份
feature1=zeros(1,32);
%上、下
for cnt=1:4
    p1=0;p2=0;p3=0;p4=0;
    for j=(w/4*(cnt-1)+1):(w/4*cnt)
        %上
        i=1;
        while(img(i,j)==0&&i<h) %外轮廓特征
            p1=p1+1;
            i=i+1;
        end
        while(img(i,j)==1&&i<h) %第一划
            i=i+1;
        end
        while(img(i,j)==0&&i<h)%内轮廓特征
            p2=p2+1;
            i=i+1;
        end
        %下
        i=h;
        while(img(i,j)==0&&i>1) %外轮廓特征
            p3=p3+1;
            i=i-1;
        end
        while(img(i,j)==1&&i>1) %第一划
            i=i-1;
        end
        while(img(i,j)==0&&i>1)%内轮廓特征
            p4=p4+1;
            i=i-1;
        end
    end
    feature1(1,cnt)=p1;feature1(1,cnt+16)=p2;
    feature1(1,cnt+4)=p3;feature1(1,cnt+20)=p4;
end
%左右
for cnt=9:12
    p1=0;p2=0;p3=0;p4=0;
    for i=(h/4*(cnt-9)+1):(h/4*(cnt-8))
        %左
        j=1;
        while(img(i,j)==0&&j<w) %外轮廓特征
            p1=p1+1;
            j=j+1;
        end
        while(img(i,j)==1&&j<w) %第一划
            j=j+1;
        end
        while(img(i,j)==0&&j<w)%内轮廓特征
            p2=p2+1;
            j=j+1;
        end
        %右
        j=w;
        while(img(i,j)==0&&j>1) %外轮廓特征
            p3=p3+1;
            j=j-1;
        end
        while(img(i,j)==1&&j>1) %第一划
            j=j-1;
        end
        while(img(i,j)==0&&j>1)%内轮廓特征
            p4=p4+1;
            j=j-1;
        end
    end
    feature1(1,cnt)=p1;feature1(1,cnt+16)=p2;
    feature1(1,cnt+4)=p3;feature1(1,cnt+20)=p4;
end

%HoG特征
%16*16个像素为一个block，共9个block
%9个梯度方向
%2*2个block为一个cell，共4个cell
%共4*4*9=144维特征
feature2=hogcalculator(img);
feature2=cell2mat(feature2);

end