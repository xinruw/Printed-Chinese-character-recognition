function [frame]=FrameSelection(img)
%��ѡʶ�����򣬷���ѡ�е�����
%img�ǻҶ�ͼ
[M N c] = size(img);
% img=imresize(img,[M/4,N/4]);
if(c==3)
    img= rgb2gray(img);
end
figure,imshow(img) %��ʾԭͼ��
h=imrect; %�����ʮ�֣�����ѡȡ����Ȥ����
pos=getPosition(h); %ͼ�г��־��ο�pos���ĸ�ֵ���ֱ��Ǿ��ο�����Ͻ�����y��x���߶ȡ����
frame = imcrop(img, pos);

end
