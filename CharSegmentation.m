function [is_char,row_no,y1,y2,x1,x2,total_cnt]=CharSegmentation(rows)
%�����ַָ�Ľ�����Ƿ��Ǻ��֡�ÿ�����ڵڼ��С�ÿ���ֵ����ꡢ������

mkdir('test_img\chars');
total_cnt=1;%ͼƬ���ܹ�������
for k=1:rows %����
    img=imread(['test_img\rows\row',num2str(k),'.png']);
    img=~img;%���ں�ɫ���ص�ļӺ�
    [h,w]=size(img);

    %�ȼ�¼����ֱ��ͼÿһ����ɫ��������յ㣬�ٸ��ݺ��ֵĿ�Ƚ���ɸѡ
    x1_tmp=1;x2_tmp=2;
    cnt=0;%��ɫ��ĸ���
    while(x2_tmp<w-2)
        while(sum(img(:,x1_tmp))==0&&x1_tmp<w)
            x1_tmp=x1_tmp+1;
        end
        x2_tmp=x1_tmp+1;
        while(sum(img(:,x2_tmp))~=0&&x2_tmp<w)%��һ����ɫ��ֹ�ĵط�
            x2_tmp=x2_tmp+1;
        end
        cnt=cnt+1;
        s(1,cnt)=x1_tmp;
        e(1,cnt)=x2_tmp;  
        x1_tmp=x2_tmp+1;  
    end

    %���ݺ��ֵĿ�Ƚ��л���
    total=cnt;
    cnt=0;i=1;j=1;%cnt�Ժ��ֽ��м���
    while(i<=total)
        if((i<total&&(s(i+1)-s(i)>0.8*h)&&e(i)-s(i)<0.4*h)||(i==total&&e(i)-s(i)<0.4*h)) %���������ţ�ֻʶ����
            i=i+1;
            cnt=cnt+1;s(cnt)=-1;e(cnt)=-1;
            continue;
        end
        j=i;
        while(e(j)-s(i)<1.05*h&&j<=total-1) %ע��߽�Ĵ���
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

    total=cnt;%�����ܹ�������
    for i=1:total
        row_no(total_cnt)=k;
        if(s(i)==-1&&e(i)==-1)
            is_char(total_cnt)=0; %������
            x1(total_cnt)=-1;x2(total_cnt)=-1;
            y1(total_cnt)=-1;y2(total_cnt)=-1;
            slice= true(48,48);
            slicepath=['test_img\chars\',num2str(total_cnt),'.png'];
            imwrite(slice,slicepath);
            total_cnt=total_cnt+1;
            continue;
        end
        is_char(total_cnt)=1;%����
        x1_tmp=s(i);x2_tmp=e(i)-1;
        %���±߿�
        y1_tmp=1;
        while(sum(img(y1_tmp,x1_tmp:x2_tmp))==0&&y1_tmp<h)
            y1_tmp=y1_tmp+1;
        end
        y2_tmp=h;
        while(sum(img(y2_tmp,x1_tmp:x2_tmp))==0&&y2_tmp>y1_tmp)
            y2_tmp=y2_tmp-1;
        end
        %������ֲ��������εģ������¹�խ
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
        %�и����
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