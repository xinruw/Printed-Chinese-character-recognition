function [is_char,row_no,y1,y2,x1,x2,total_cnt]=CharSegmentation(rows)
%返回字分割的结果，是否是汉字、每个字在第几行、每个字的坐标、总字数

mkdir('test_img\chars');
total_cnt=1;%图片内总共的字数
for k=1:rows %行数
    img=imread(['test_img\rows\row',num2str(k),'.png']);
    img=~img;%便于黑色像素点的加和
    [h,w]=size(img);

    %先记录像素直方图每一个黑色块的起点和终点，再根据汉字的宽度进行筛选
    x1_tmp=1;x2_tmp=2;
    cnt=0;%黑色块的个数
    while(x2_tmp<w-2)
        while(sum(img(:,x1_tmp))==0&&x1_tmp<w)
            x1_tmp=x1_tmp+1;
        end
        x2_tmp=x1_tmp+1;
        while(sum(img(:,x2_tmp))~=0&&x2_tmp<w)%第一个黑色终止的地方
            x2_tmp=x2_tmp+1;
        end
        cnt=cnt+1;
        s(1,cnt)=x1_tmp;
        e(1,cnt)=x2_tmp;  
        x1_tmp=x2_tmp+1;  
    end

    %根据汉字的宽度进行划分
    total=cnt;
    cnt=0;i=1;j=1;%cnt对汉字进行计数
    while(i<=total)
        if((i<total&&(s(i+1)-s(i)>0.8*h)&&e(i)-s(i)<0.4*h)||(i==total&&e(i)-s(i)<0.4*h)) %舍弃标点符号，只识别汉字
            i=i+1;
            cnt=cnt+1;s(cnt)=-1;e(cnt)=-1;
            continue;
        end
        j=i;
        while(e(j)-s(i)<1.05*h&&j<=total-1) %注意边界的处理
            j=j+1;
        end
        if(e(j)-s(i)>=1.05*h)
            j=j-1;
        end
        cnt=cnt+1;
        s(cnt)=s(i);
        e(cnt)=e(j);
        i=j+1;
    end

    total=cnt;%该行总共的字数
    for i=1:total
        row_no(total_cnt)=k;
        if(s(i)==-1&&e(i)==-1)
            is_char(total_cnt)=0; %标点符号
            x1(total_cnt)=-1;x2(total_cnt)=-1;
            y1(total_cnt)=-1;y2(total_cnt)=-1;
            slice= true(48,48);
            slicepath=['test_img\chars\',num2str(total_cnt),'.png'];
            imwrite(slice,slicepath);
            total_cnt=total_cnt+1;
            continue;
        end
        is_char(total_cnt)=1;%汉字
        x1_tmp=s(i);x2_tmp=e(i)-1;
        %上下边框
        y1_tmp=1;
        while(sum(img(y1_tmp,x1_tmp:x2_tmp))==0&&y1_tmp<h)
            y1_tmp=y1_tmp+1;
        end
        y2_tmp=h;
        while(sum(img(y2_tmp,x1_tmp:x2_tmp))==0&&y2_tmp>y1_tmp)
            y2_tmp=y2_tmp-1;
        end
        %如果汉字不是正方形的，即上下过窄
        if(x2_tmp-x1_tmp>y2_tmp-y1_tmp)
            y0=(y2_tmp+y1_tmp)/2;
            y1_tmp=round(y0-(x2_tmp-x1_tmp)/2);
            y2_tmp=round(y0+(x2_tmp-x1_tmp)/2);
        else
            x0=(x2_tmp+x1_tmp)/2;
            x1_tmp=round(x0-(y2_tmp-y1_tmp)/2);
            x2_tmp=round(x0+(y2_tmp-y1_tmp)/2);
        end
        if(y1_tmp<1)
            y1_tmp=1;
        end
        if(y2_tmp>h)
            y2_tmp=h;
        end
        if(x1_tmp<1)
            x1_tmp=1;
        end
        if(x2_tmp>w)
            x2_tmp=w;
        end
        %切割并保存
    %     slice=imcrop(img,[x1_tmp,y1_tmp,x2_tmp-x1_tmp+1,y2_tmp-y1_tmp+1]);
        x1(total_cnt)=x1_tmp;x2(total_cnt)=x2_tmp;
        y1(total_cnt)=y1_tmp;y2(total_cnt)=y2_tmp;
        slice=img(y1_tmp:y2_tmp,x1_tmp:x2_tmp);
        slice=imresize(slice,[48,48]);
        slice=~slice;
        slice=imopen(slice,strel('square',2));
        slicepath=['test_img\chars\',num2str(total_cnt),'.png'];
        imwrite(slice,slicepath);
        slice=~slice;
        slice=Thin_zs(slice);
    %     slice = bwmorph(slice,'skel',Inf);
        slice=~slice;
        slicepath2=['test_img\chars\thin',num2str(total_cnt),'.png'];
        imwrite(slice,slicepath2); 
        total_cnt=total_cnt+1;
    end
end

total_cnt=total_cnt-1;

end