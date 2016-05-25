function bmp = ASA(bmp1,z,px,py,lambda)

    [n m] = size(bmp1);

    k = 2 * pi / lambda;

    pfx = 1/(n*px);                             %frequency domain pitches
    pfy = 1/(m*py);

    fbmp1 = fft2(bmp1);                      %calculate fft2 of the bmp
    fbmp1 = fftshift(fbmp1);                 %shift the (0,0) to the center of the pic   
    
    [gridx, gridy] = meshgrid(1:m,1:n);
    kernel = exp(z*(k^2-4*pi*pi*(((gridx - m/2 - 1)*pfx).^2+((gridy - n/2 - 1)*pfy).^2)).^0.5);
    fbmp1 = fbmp1.*kernel;
    
    fbmp1 = ifftshift(fbmp1);                    %shift to prepare IFFT
    bmp = ifft2(fbmp1);                           %inverse FFT
end