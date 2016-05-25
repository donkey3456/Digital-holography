function filtered = HighFilter2(input,r)
%This function is a high pass filter. It set the low-frequency spectrum with a radius of r to zero. Here the unit of r is pixel.
    [yn,xn] = size(input);
    [XX,YY] = meshgrid(1:xn,1:yn);
    Filter = (XX - xn/2 -1).^2 + (YY - yn/2 -1).^2 >= r^2;
    Filter = ifftshift(Filter);
    finput = fft2(input);
    finput = finput .* Filter;
    filtered = ifft2(finput);
end
