function spectrumshow(spectrum)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function process the spectrum so that you can easily display it using
% figure, spectrumshow(fft2(image))
% Here the input is the spectrum of the image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    spectrum = fftshift(spectrum);
    absIm = abs(spectrum);
    logIm = log(absIm + 1);
    outputIm = Normal2Image(logIm);
    imshow(uint8(outputIm))
end    