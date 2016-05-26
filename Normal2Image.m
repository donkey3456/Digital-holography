function IM = Normal2Image(im)
IM = (im - min(im(:)))/(max(im(:))-min(im(:)))*255;
end