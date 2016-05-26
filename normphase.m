function im = normphase(image,norm2,loop)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function process the phase image so that you can easily display it using
% figure, imshow(uint8(normphase(image, pi, 3)))
% Here the input image is the complex light field not the phase of the light field.
% Usually, 2 loops are enough
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    normim = abs(image).*exp(1i*angle(image));
    [FX,FY] = gradient(normim);
    diffim = abs(FX).^2+abs(FY).^2;
    mask = abs(diffim)<0.3;
    
    for i = 1:loop
        myangle = angle(image)+pi;
        masedanlge = myangle.*mask;
        dphase = norm2 - sum(masedanlge(:))/sum(mask(:));
        image = image* exp(1i*dphase);
    end
    myangle = angle(image);
    im = (myangle + pi)/2/pi*255;
end
