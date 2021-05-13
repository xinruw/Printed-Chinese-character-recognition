function [frame]=FrameSelection(img)
%框选识别区域，返回选中的区域
%img是灰度图
[M N c] = size(img);
% img=imresize(img,[M/4,N/4]);
if(c==3)
    img= rgb2gray(img);
end
figure,imshow(img) %显示原图像
h=imrect; %鼠标变成十字，用来选取感兴趣区域
pos=getPosition(h); %图中出现矩形框，pos有四个值，分别是矩形框的左上角坐标y、x、高度、宽度
frame = imcrop(img, pos);

end
