function out = medfilt2c(im,size)
    out = medfilt2(real(im),size)+1i*medfilt2(imag(im),size);
end