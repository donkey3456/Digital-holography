clear all
clc
close all

%parameters
d = 1e-3;
lambda = 650e-9;
px = 5.5e-6;
py = 5.5e-6;
k = 2 * pi / lambda;

HighpassR = 330;
LowpassR1 = 330;

%Load pictures
backgroundgray = double(imread('b1.bmp'));
hologray = double(imread('t1.bmp'));
figure, imshow(uint8(Normal2Image(backgroundgray)));
figure, imshow(uint8(Normal2Image(hologray)));


[fy,fx] = FindFirstOrderCenter(backgroundgray,HighpassR);
generatedField = GenerateLightField(backgroundgray,fy,fx,LowpassR1);

%back
backcorrected1 = (backgroundgray ./ generatedField);
backcorrected1 = LowpassFilter2Sub(backcorrected1,LowpassR1);

holocorrected1 = (hologray ./ generatedField);
figure,spectrumshow(fft2(holocorrected1))
holocorrected1 = LowpassFilter2Sub(holocorrected1,LowpassR1);

normalizedHolo = holocorrected1./abs(holocorrected1);
[gradx grady] = gradient(normalizedHolo);
criteria = abs(gradx).^2 + abs(grady).^2;
criteria = LowpassFilter2(criteria,10);
mask3 =  (criteria > 0.5);
mask2 = (criteria <=0.5) .* (criteria > 0.1);
mask1 = criteria<=0.1;

finalback = mask1.*backcorrected1 + mask2.*medfilt2c(backcorrected1,[3,3])+...
mask3.*medfilt2c(backcorrected1,[7,7]);

final = mask1.*holocorrected1 + mask2.*medfilt2c(holocorrected1,[3,3])+...
mask3.*medfilt2c(holocorrected1,[7,7]);

z=0.423
%recons = PaddingASA(final,-1i*z,px*2,py*2,lambda);
%recons = PaddingASA(final./exp(1i*angle(finalback)),-1i*z,px*2,py*2,lambda);
recons = PaddingASA(final./exp(1i*angle(finalback))./ExtractBackground(abs(finalback),100).^0.5,-1i*z,px*2,py*2,lambda);

image = abs(recons);
image = Normal2Image(image);
figure, imshow(uint8(image))
imwrite(uint8(image),'result.bmp');

corre = correction2Dfast(recons);
recons= recons.* corre;
phaseImage = 255 - normphase(recons,120/255*2*pi,5);
figure,imshow(uint8(phaseImage));
imwrite(uint8(phaseImage),'phase.bmp');

