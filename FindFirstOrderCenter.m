function [fy,fx] = FindFirstOrderCenter(im,HighpassR)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function find the position of the first order center
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [yn,xn] = size(im);
    [XX,YY] = meshgrid(1:xn,1:yn);
    Filter = (XX - xn/2 -1).^2 + (YY - yn/2 -1).^2 > HighpassR^2;
    fim = fft2(im);
    fim = fftshift(fim);
    fim = fim .* Filter;
    absfim = abs(fim);
    [v,u] = find(absfim == max(absfim(:)),1,'first');
    fy = v - yn/2 - 1;
    fx = u - xn/2 - 1;
end