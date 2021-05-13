function [feature1,feature2]=ExtractFeature(img)
% ��ȡ��������ͼƬ������
% ������������32ά�����ڴַ��ࣻHoG����144ά������ϸ����

img=~img; %��ɫ����0����ɫ�ʻ�1
[h,w]=size(img);

%����������+����������
%�ϡ��¡������ĸ�����ÿ������ȷֳ��ķ�
feature1=zeros(1,32);
%�ϡ���
for cnt=1:4
    p1=0;p2=0;p3=0;p4=0;
    for j=(w/4*(cnt-1)+1):(w/4*cnt)
        %��
        i=1;
        while(img(i,j)==0&&i<h) %����������
            p1=p1+1;
            i=i+1;
        end
        while(img(i,j)==1&&i<h) %��һ��
            i=i+1;
        end
        while(img(i,j)==0&&i<h)%����������
            p2=p2+1;
            i=i+1;
        end
        %��
        i=h;
        while(img(i,j)==0&&i>1) %����������
            p3=p3+1;
            i=i-1;
        end
        while(img(i,j)==1&&i>1) %��һ��
            i=i-1;
        end
        while(img(i,j)==0&&i>1)%����������
            p4=p4+1;
            i=i-1;
        end
    end
    feature1(1,cnt)=p1;feature1(1,cnt+16)=p2;
    feature1(1,cnt+4)=p3;feature1(1,cnt+20)=p4;
end
%����
for cnt=9:12
    p1=0;p2=0;p3=0;p4=0;
    for i=(h/4*(cnt-9)+1):(h/4*(cnt-8))
        %��
        j=1;
        while(img(i,j)==0&&j<w) %����������
            p1=p1+1;
            j=j+1;
        end
        while(img(i,j)==1&&j<w) %��һ��
            j=j+1;
        end
        while(img(i,j)==0&&j<w)%����������
            p2=p2+1;
            j=j+1;
        end
        %��
        j=w;
        while(img(i,j)==0&&j>1) %����������
            p3=p3+1;
            j=j-1;
        end
        while(img(i,j)==1&&j>1) %��һ��
            j=j-1;
        end
        while(img(i,j)==0&&j>1)%����������
            p4=p4+1;
            j=j-1;
        end
    end
    feature1(1,cnt)=p1;feature1(1,cnt+16)=p2;
    feature1(1,cnt+4)=p3;feature1(1,cnt+20)=p4;
end

%HoG����
%16*16������Ϊһ��block����9��block
%9���ݶȷ���
%2*2��blockΪһ��cell����4��cell
%��4*4*9=144ά����
feature2=hogcalculator(img);
feature2=cell2mat(feature2);

end