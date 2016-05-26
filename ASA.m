function bmp = ASA(bmp1,z,px,py,lambda)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Angular Spectrum Approach
% Angular Spectrum Approach is a technique for modeling the propagation of a wave field.
% It could be used to calculate the light field at the focus plane.
% bmp1 is input light field
% z is propagation distance
% px, py is the size of each pixel, if the image has been re-sampled, px & py should be adjusted accordingly.
% lambda is the wavelength
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [n m] = size(bmp1);

    k = 2 * pi / lambda;

    pfx = 1/(n*px);                          %frequency domain pitches
    pfy = 1/(m*py);

    fbmp1 = fft2(bmp1);                      %calculate fft2 of the bmp
    fbmp1 = fftshift(fbmp1);                 %shift the (0,0) to the center of the pic   
    
    [gridx, gridy] = meshgrid(1:m,1:n);
    kernel = exp(1i*z*(k^2-4*pi*pi*(((gridx - m/2 - 1)*pfx).^2+((gridy - n/2 - 1)*pfy).^2)).^0.5);
    fbmp1 = fbmp1.*kernel;                   %multiply the spectrum by the fresnel kernel
    
    fbmp1 = ifftshift(fbmp1);                %shift to prepare IFFT
    bmp = ifft2(fbmp1);                      %inverse FFT
end