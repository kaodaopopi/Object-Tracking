clear all; close all; clc;

%%

%%攝影機參數
vid = videoinput('winvideo', 1, 'RGB24_640x480');
src = getselectedsource(vid);
set(vid,'FramesPerTrigger',inf);
set(vid,'ReturnedColorspace','rgb');
start(vid);

%%

%%影像處理
%%data提取影像的每一幀
%%FramesAcquired後面接的是會攝取幾張圖後停止，如果是inf將永遠不會停
while(vid.FramesAcquired<=300)
    data=getsnapshot(vid);
    
    diff_im=imsubtract(data(:,:,1),rgb2gray(data));
    diff_im=medfilt2(diff_im,[3,3]);
    diff_im=imbinarize(diff_im,0.18);
    diff_im=bwareaopen(diff_im,300);
    
    bw=bwlabel(diff_im);

    stats=regionprops(bw,'BoundingBox','Centroid');
    imshow(data);
    
    hold on
  
    for object=1:length(stats)
        bb=stats(object).BoundingBox;
        bc=stats(object).Centroid;
        
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
        plot(bc(1),bc(2))
    end
    
    hold off
    
end

%%

close;
stop(vid);
flushdata(vid);

        
        
        
        
        
        
