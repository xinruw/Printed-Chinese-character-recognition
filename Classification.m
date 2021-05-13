function [index]=Classification(char_img,img_index)
%返回char_img对应的文字在模板库中的类别标号
%img必须是细化后的二值图像

[ft1,ft2]=ExtractFeature(char_img);

%确定用哪个模板库
if(img_index==1||img_index==2||img_index==3)
    load('library\tezheng\features1.mat');
    load('library\tezheng\features2.mat');
    rough=100; %共430个字，粗分类选前100个
else 
    load(['library\tezheng',num2str(img_index),'\features1.mat']);
    load(['library\tezheng',num2str(img_index),'\features2.mat']);
    if(img_index==4||img_index==5) %共11个字，粗分类选前5个
        rough=5;
    elseif(img_index==6) %共97个字，粗分类选前50个
        rough=50;
    end
end
total=size(features1,1);%模板库中的总字数

%粗分类，选前100个
dist1=zeros(total,1);
for i=1:total
    dist1(i,1)=norm(ft1-features1(i,:),1);
end
[A,res1]=sort(dist1(:,1)); %res1是网格特征最前100的标号
res1=res1(1:rough);

%细分类
dist2=zeros(rough,2);
for i=1:rough
    dist2(i,1)=norm(ft2-features2(res1(i),:)); %前100的HoG特征距离
    dist2(i,2)=res1(i); %记录标号
end

res2=sortrows(dist2,1);
index=res2(1,2);

end