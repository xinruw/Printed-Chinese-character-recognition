function [index]=Classification(char_img,img_index)
%����char_img��Ӧ��������ģ����е������
%img������ϸ����Ķ�ֵͼ��

[ft1,ft2]=ExtractFeature(char_img);

%ȷ�����ĸ�ģ���
if(img_index==1||img_index==2||img_index==3)
    load('library\tezheng\features1.mat');
    load('library\tezheng\features2.mat');
    rough=100; %��430���֣��ַ���ѡǰ100��
else 
    load(['library\tezheng',num2str(img_index),'\features1.mat']);
    load(['library\tezheng',num2str(img_index),'\features2.mat']);
    if(img_index==4||img_index==5) %��11���֣��ַ���ѡǰ5��
        rough=5;
    elseif(img_index==6) %��97���֣��ַ���ѡǰ50��
        rough=50;
    end
end
total=size(features1,1);%ģ����е�������

%�ַ��࣬ѡǰ100��
dist1=zeros(total,1);
for i=1:total
    dist1(i,1)=norm(ft1-features1(i,:),1);
end
[A,res1]=sort(dist1(:,1)); %res1������������ǰ100�ı��
res1=res1(1:rough);

%ϸ����
dist2=zeros(rough,2);
for i=1:rough
    dist2(i,1)=norm(ft2-features2(res1(i),:)); %ǰ100��HoG��������
    dist2(i,2)=res1(i); %��¼���
end

res2=sortrows(dist2,1);
index=res2(1,2);

end