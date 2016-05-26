function spectrumshow(spectrum)
    spectrum = fftshift(spectrum);
    absIm = abs(spectrum);
    logIm = log(absIm + 1);
    outputIm = Normal2Image(logIm);
    imshow(uint8(outputIm))
end    