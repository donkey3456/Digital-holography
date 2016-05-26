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
hologray = double(imread('t1.bmp'));
figure, imshow(uint8(Normal2Image(hologray)));


[fy,fx] = FindFirstOrderCenter(hologray,HighpassR);
[yn,xn]=size(hologray);
[gridx gridy]= meshgrid(1:xn,1:yn);
R = exp(1i * 2 * pi * (fx/xn.*gridx+fy/yn.*gridy));


holocorrected1 = (hologray .* R);
figure,spectrumshow(fft2(holocorrected1))
holocorrected1 = LowpassFilter2Sub(holocorrected1,LowpassR1);

corre = correction2Dfast(holocorrected1);
holocorrected1= holocorrected1.* corre;

normalizedHolo = holocorrected1./abs(holocorrected1);
[gradx grady] = gradient(normalizedHolo);
criteria = abs(gradx).^2 + abs(grady).^2;
criteria = LowpassFilter2(criteria,10);
mask3 =  (criteria > 0.5);
mask2 = (criteria <=0.5) .* (criteria > 0.1);
mask1 = criteria<=0.1;


final = mask1.*holocorrected1 + mask2.*medfilt2c(holocorrected1,[3,3])+...
mask3.*medfilt2c(holocorrected1,[7,7]);

z=0.423;
recons = PaddingASA(final./ExtractBackground(abs(final),100).^0.5,-z,px*2,py*2,lambda);

image = abs(recons);
image = Normal2Image(image);
figure, imshow(uint8(image))
imwrite(uint8(image),'result.bmp');


phaseImage = 255 - normphase(recons,120/255*2*pi,5);
figure,imshow(uint8(phaseImage));
imwrite(uint8(phaseImage),'phase.bmp');

