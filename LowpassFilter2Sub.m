function filtered = LowpassFilter2Sub(input,r)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is a low-pass filter. 
% The size of spectrum of the output image is one fourth of that of the input image.
% Here the unit of r is pixel.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [yn,xn] = size(input);
    [XX,YY] = meshgrid(1:xn,1:yn);
    Filter = (XX - xn/2 -1).^2 + (YY - yn/2 -1).^2 < r^2;
    finput = fft2(input);
    finput = fftshift(finput) .* Filter ;
    foutput = finput(yn/4+1:yn*3/4,xn/4+1:xn*3/4);
    foutput = ifftshift(foutput);
    filtered = ifft2(foutput);
end
