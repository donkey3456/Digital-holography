function IM = Normal2Image(im)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function maps input image to [0,255], so that you can easily display it using 
% figure, imshow(uint8(Normal2Image(im)))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IM = (im - min(im(:)))/(max(im(:))-min(im(:)))*255;
end