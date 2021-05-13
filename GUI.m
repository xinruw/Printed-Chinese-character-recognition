function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 10-Jun-2018 20:09:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%设置axes初始不可见
set(handles.axes,'visible','off');
%设置各种默认值
set(handles.slider_contrast,'Value',0.0); 
set(handles.slider_binseg,'Value',0.5); 
global contrast level;
contrast=0;level=0.5;


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%--------------------------------------------------------------------------
% 选择图像文件
% --- Executes on button press in pushbutton_selectfile.
function pushbutton_selectfile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_selectfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img img_index;
[ImageFileName,ImagePathName,ImageFilterIndex] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';'*.*','All Files'},'ReadAudio',...
    'MultiSelect','off',...       % 'off'不支持多选， 'on'支持多选
    'test_img'); % 设置默认路径
if isequal(ImageFileName,0) || isequal(ImagePathName,0) || isequal(ImageFilterIndex,0)
    msgbox('导入图像失败，点击“确定”关闭对话框，再重新导入');
else
    % 显示图片
    filepath=[ImagePathName,ImageFileName];
    img=imread(filepath);
    %判断选的是哪一张图片
%     img_index=1;
    for i=1:6
        if(contains(ImageFileName,num2str(i)))
            img_index=i;break;
        end
    end
    axes(handles.axes);
    figure('NumberTitle', 'off', 'Name', '测试图片');imshow(img);
    axes(handles.axes);cla reset;imshow(img);
    %保存灰度图，用于随后的二值化
    [h,w,c]=size(img);
    if(c==3)
        img=rgb2gray(img);
    end
    imwrite(img,'test_img\gray.png');
end


%--------------------------------------------------------------------------
% 透视变换
% --- Executes on button press in pushbutton_perstrans.
function pushbutton_perstrans_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_perstrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
img=PerspectiveTrans(img); %用鼠标取四个点（左上、右上、左下、右下），按回车结束选取
figure('NumberTitle', 'off', 'Name', '透视变换后的图片');imshow(img);
axes(handles.axes);cla reset;imshow(img);
imwrite(img,'test_img\gray.png');


%--------------------------------------------------------------------------
% 框选识别区域
% --- Executes on button press in pushbutton_framesel.
function pushbutton_framesel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_framesel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
img=FrameSelection(img);
figure('NumberTitle', 'off', 'Name', '选中的识别区域');imshow(img);
axes(handles.axes);cla reset;imshow(img);
imwrite(img,'test_img\gray.png');


%--------------------------------------------------------------------------
% 增强对比度
% --- Executes on slider movement.
function slider_contrast_Callback(hObject, eventdata, handles)
% hObject    handle to slider_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global img contrast img_tmp;
contrast=roundn(get(hObject,'value'),-2); % 拖动滑动条设置对比度增强的强度
set(handles.text_contrast,'string',['强度：',num2str(contrast)]);
if(contrast==1) %防止越界的情况
    contrast=0.99;
end
img_tmp=imadjust(img,[contrast/2,1-contrast/2],[],0.8);
cla reset;axes(handles.axes);imshow(img_tmp); %在GUI上显示不同强度下的对比度增强的效果

% --- Executes during object creation, after setting all properties.
function slider_contrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in pushbutton_contrast.
function pushbutton_contrast_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img img_tmp contrast;
if(contrast~=0)%默认
    img=img_tmp;
end
figure('NumberTitle', 'off', 'Name', '增强对比度后的图片');imshow(img);
axes(handles.axes);cla reset;imshow(img);
imwrite(img,'test_img\gray.png');


%--------------------------------------------------------------------------
% 二值化
% --- Executes on slider movement.
function slider_binseg_Callback(hObject, eventdata, handles)
% hObject    handle to slider_binseg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global img level img_tmp;
level=roundn(get(hObject,'value'),-2); % 拖动滑动条设置二值化的阈值
set(handles.text_binseg,'string',['阈值：',num2str(level)]);
img_tmp=imbinarize(img,level);
axes(handles.axes);imshow(img_tmp); %在GUI上显示不同强度下的对比度增强的效果

% --- Executes during object creation, after setting all properties.
function slider_binseg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_binseg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in pushbutton_binseg.
function pushbutton_binseg_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_binseg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img img_tmp level;
if(level==0.5)%默认
    img=imbinarize(img,level);
else
    img=img_tmp;
end
figure('NumberTitle', 'off', 'Name', '二值化后的图片');imshow(img);
axes(handles.axes);cla reset;imshow(img);
imwrite(img,'test_img\bin.png');


%--------------------------------------------------------------------------
% 列分割
% --- Executes on button press in pushbutton_rowseg.
function pushbutton_rowseg_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_rowseg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img rows y1_r y2_r x1_r x2_r;
if(~islogical(img))
    img=imbinarize(img,0.5);
end
if(exist('test_img\rows','dir'))
    rmdir('test_img\rows','s');
end
[y1_r,y2_r,x1_r,x2_r,rows,count_y]=RowSegmentation(img);%img必须是二值图
axes(handles.axes);cla reset;imshow(img);hold on
for i=1:rows
    rectangle( 'Position', [x1_r(i),y1_r(i),x2_r(i)-x1_r(i)+1,y2_r(i)-y1_r(i)+1],'LineWidth',1,'EdgeColor','b');
end
%大图显示
figure('NumberTitle', 'off', 'Name', '行分割结果');imshow(img);
for i=1:rows
    rectangle( 'Position', [x1_r(i),y1_r(i),x2_r(i)-x1_r(i)+1,y2_r(i)-y1_r(i)+1],'LineWidth',1,'EdgeColor','b');
end
figure('NumberTitle', 'off', 'Name', '水平投影图');
h=size(img,1);
bar(1:h,count_y);%画水平投影图
%坐标轴的一些设置，按图片的x、y轴习惯显示
set(gca,'XLim',[1 h]);set(gca,'xdir','reverse');view(90,-90);


%--------------------------------------------------------------------------
% 字分割
% --- Executes on button press in pushbutton_charseg.
function pushbutton_charseg_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_charseg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img rows y1_r y2_r x1_r x2_r char_num is_char;
if(exist('test_img\chars','dir'))
    rmdir('test_img\chars','s');
end
[is_char,row_no,y1_c,y2_c,x1_c,x2_c,char_num]=CharSegmentation(rows);
axes(handles.axes);cla reset;imshow(img);hold on
for i=1:char_num
    if(~is_char(i)) %标点符号不框出来
        continue;
    end
    rectangle( 'Position', [x1_r(row_no(i))+x1_c(i)-1,...
        y1_r(row_no(i))+y1_c(i)-1,x2_c(i)-x1_c(i)+1,y2_c(i)-y1_c(i)+1],...
        'LineWidth',1,'EdgeColor','b');
end
%大图显示
figure('NumberTitle', 'off', 'Name', '字分割结果');imshow(img);
imshow(img);hold on
for i=1:char_num
    if(~is_char(i)) %标点符号不框出来
        continue;
    end
    rectangle( 'Position', [x1_r(row_no(i))+x1_c(i)-1,...
        y1_r(row_no(i))+y1_c(i)-1,x2_c(i)-x1_c(i)+1,y2_c(i)-y1_c(i)+1],...
        'LineWidth',1,'EdgeColor','b');
end
%画每一行的字分割结果和垂直投影图
for i=1:rows
    figure('NumberTitle', 'off', 'Name', ['第',num2str(i),'行字分割结果和垂直投影图']);
    row_img=imread(['test_img\rows\row',num2str(i),'.png']);
    subplot(2,1,1);imshow(row_img);
    for j=1:char_num
        if(row_no(j)==i)
            rectangle( 'Position', [x1_c(j),y1_c(j),x2_c(j)-x1_c(j)+1,y2_c(j)-y1_c(j)+1],...
                'LineWidth',1,'EdgeColor','b');
        end
    end
    subplot(2,1,2);
    [h,w]=size(row_img);
    row_img=~row_img;
    bar(1:w,sum(row_img,1));%画水平投影图
%     %坐标轴的一些设置，按图片的x、y轴习惯显示
    set(gca,'XLim',[1 w]);
end


%--------------------------------------------------------------------------
% 显示识别结果
% --- Executes on button press in pushbutton_showres.
function pushbutton_showres_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_showres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_index char_num is_char res;
%选择字库
if(img_index==1||img_index==2||img_index==3)
    chars=load('library\characters.mat');
else 
    chars=load(['library\characters',num2str(img_index),'.mat']);
end
chars=cell2mat(struct2cell(chars));
%分类
% global res_index;
res_index=zeros(1,char_num);
res=char(zeros(1,char_num));
for i=1:char_num
    if(~is_char(i))
        res_index(i)=-1;
        res(i)=' ';
        continue;
    end
    char_img=imread(['test_img\chars\thin',num2str(i),'.png']);
    res_index(i)=Classification(char_img,img_index);
    res(i)=chars(res_index(i));
end
%在edit中换行显示
disp_rows=ceil(size(res,2)/35);
disp_str=[];
for i=1:disp_rows
    b=35*(i-1)+1;
    if(i==disp_rows)
        e=size(res,2);
    else
        e=35*i;
    end
   disp_str=[disp_str,res(b:e),10];
end
%计算识别正确率（只有测试图像才能计算！）
standard=importdata(['test_img\standards\standard',num2str(img_index),'.txt']);
standard=cell2mat(standard);
if(length(res)==length(standard))
    accuracy=0;
    for i=1:length(res)
        if(res(i)==standard(i))
            accuracy=accuracy+1;
        end
    end
    accuracy=accuracy/length(res);
    accuracy=roundn(accuracy,-4);
    disp_str=[disp_str,10,'正确率：',num2str(accuracy*100),'%'];
end
set(handles.edit_result,'string',disp_str);


%--------------------------------------------------------------------------
% 保存到.txt
% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global res;
fp = fopen('test_img\result.txt','wt');
fprintf(fp,'%s',res);
fclose(fp);
