function correction2 = correction2Dfast(Holo,iterations,preSubSampling,postSubSampling,threshold)

tic
    %1.1 check parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin < 5
        threshold = 0.8;
        if nargin < 4
            postSubSampling = 2;
            if nargin < 3
                preSubSampling = 1;
                if nargin < 2
                    iterations = 5;
                    if nargin < 1
                        error('You must at least input an image!!')
                    end
                end
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %2.1 pre-sub sample
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [yn,xn] = size(Holo);
    preSubTimes = 2^preSubSampling;
    preSubHolo = Holo(1:preSubTimes:end,1:preSubTimes:end);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %2.2 get weighted mask
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    normalizedHolo = exp(1i*angle(preSubHolo));
    [GX,GY] = gradient(normalizedHolo);
    weight = abs(GX).^2+abs(GY).^2;
    averagedWeight = LowpassFilter2(weight,10);
    mask = averagedWeight < threshold;
    %%figure,imshow(mask)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %3.1 post sub sample
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    postSubTimes = 2^postSubSampling;
    averagedHolo = ExtractBackground(normalizedHolo,postSubTimes);
    inputIm = averagedHolo(1:postSubTimes:end,1:postSubTimes:end);
    mask = mask(1:postSubTimes:end,1:postSubTimes:end);
    unitIm = inputIm./abs(inputIm).*mask+ LowpassFilter2(inputIm./abs(inputIm),5).*(1-mask);
    mask = mask(:);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %4.1 init for least square fitting and unwrapping
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    o = 14;
    P = zeros(o+1,1);
    [yn_s,xn_s] = size(inputIm);
    xn_u = xn_s * 2;
    yn_u = yn_s * 2;
    [gridX gridY] = meshgrid(1:xn_s,1:yn_s);
    %init indexes used in least square fitting
    subTimes = preSubTimes.*postSubTimes;
    yVector = reshape(gridY,[yn_s * xn_s,1]);
    xVector = reshape(gridX,[yn_s * xn_s,1]);

    z0 = ones(xn_s * yn_s,1);
    z1 = xVector;
    z2 = yVector;
    z3 = xVector.^2;
    z4 = xVector .* yVector;
    z5 = yVector.^2;
    z6 = xVector.^3;
    z7 = xVector.^2 .* yVector;
    z8 = yVector.^2 .* xVector;
    z9 = yVector.^3;

    z10 = xVector.^4;
    z11 = xVector.^3 .* yVector;
    z12 = yVector.^2 .* xVector.^2;
    z13 = yVector.* xVector.^3;
    z14 = yVector.^4;

    M = [z0.*mask,z1.*mask,z2.*mask,z3.*mask,z4.*mask,...
        z5.*mask,z6.*mask,z7.*mask,z8.*mask,z9.*mask...
        ,z10.*mask,z11.*mask,z12.*mask,z13.*mask,z14.*mask];
    
    %init kernel used in unwraping
    [gridX gridY] = meshgrid(1:xn_u,1:yn_u);
    kernel = ((gridX - xn_u/2 - 1)).^2 + ((gridY - yn_u/2 - 1)).^2;
    kernel = ifftshift(kernel);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %4.2 iterations
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ii = 1:iterations
        synthesizedPhase(1:yn_s,1:xn_s) = unitIm;
        synthesizedPhase(1:yn_s,xn_s+1:xn_u) = fliplr(unitIm);
        synthesizedPhase(yn_s+1:yn_u,1:xn_s) = flipud(unitIm);
        synthesizedPhase(yn_s+1:yn_u,xn_s+1:xn_u) = fliplr(flipud(unitIm));
        fphase = fft2(synthesizedPhase);                      %calculate fft2 of the bmp
        fphase = 1i*fphase.*kernel;
        test = ifft2(fphase);
        f = imag(synthesizedPhase).*imag(test)+real(synthesizedPhase).*real(test);
        ff = fft2(f);
        ff = -ff./kernel;
        ff(1,1) = 0;
        phase = real(ifft2(ff));
        
        [FX,FY] = gradient(phase(1:yn_s,1:xn_s));
        grad = FX.^2 + FY.^2;
        [pointx,pointy] = find(grad == min(grad(:)))
        unwrappedPhase =  angle(unitIm) + 2*pi*round((phase(1:yn_s,1:xn_s)- phase(pointx,pointy)-angle(unitIm)+angle(unitIm(pointx,pointy)))/2/pi);
        %figure,imshow(uint8(Normal2Image(unwrappedPhase)))
        chosenVector = reshape(unwrappedPhase,[xn_s * yn_s ,1]);
        correctedVector = chosenVector.*mask;
        
        A = M \ correctedVector;
        P = P + A;
        correction = reshape(exp(-1i*M*A),[yn_s,xn_s]);
        unitIm = correction.*unitIm;
    end
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    toc
    [gridX gridY] = meshgrid(1:xn,1:yn);
    gridX = (gridX - 1)/subTimes+1;
    gridY = (gridY - 1)/subTimes+1;
    yVector = reshape(gridY,[yn * xn,1]);
    xVector = reshape(gridX,[yn * xn,1]);

    z0 = ones(xn * yn,1);
    z1 = xVector;
    z2 = yVector;
    z3 = xVector.^2;
    z4 = xVector .* yVector;
    z5 = yVector.^2;
    z6 = xVector.^3;
    z7 = xVector.^2 .* yVector;
    z8 = yVector.^2 .* xVector;
    z9 = yVector.^3;

    z10 = xVector.^4;
    z11 = xVector.^3 .* yVector;
    z12 = yVector.^2 .* xVector.^2;
    z13 = yVector.* xVector.^3;
    z14 = yVector.^4;

    M = [z0,z1,z2,z3,z4,z5,z6,z7,z8,z9,z10,z11,z12,z13,z14];
    correction2 = reshape(exp(-1i*M*P),[yn,xn]);
    %figure,phaseshow(conj(correction2));
    %figure,phaseshow(ExtractBackground(Holo./abs(Holo),20))
end
