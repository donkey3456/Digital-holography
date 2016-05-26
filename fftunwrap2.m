function outputphase = fftunwrap2(im,iteration,subsampling)
    disp('fft based unwrapping')
    disp('************************************************')
    tic
    subim = im(1:2^subsampling:end,1:2^subsampling:end);
    [M,N] = size(subim);
    m = 2*M;
    n = 2*N; 
    unwrappedphase = subim./abs(subim);
    %unwrappedphase = unwrappedphase.* (criteria<0.3);
    finalphase = zeros(m,n);
    [gridx, gridy] = meshgrid(1:n,1:m);
    kernel1 = ((gridx - n/2 - 1)).^2 + ((gridy - m/2 - 1)).^2;
    
    kernel1 = ifftshift(kernel1);
    
    for ii=1:iteration
        testrecons(1:M,1:N) = unwrappedphase;
        testrecons(1:M,N+1:n) = fliplr(unwrappedphase);
        testrecons(M+1:m,1:N) = flipud(unwrappedphase);
        testrecons(M+1:m,N+1:n) = fliplr(flipud(unwrappedphase));
        fbmp1 = fft2(testrecons);                      %calculate fft2 of the bmp
        fbmp1 = 1i*fbmp1.*kernel1;
        test = ifft2(fbmp1);
        f = imag(testrecons).*imag(test)+real(testrecons).*real(test);
        ff = fft2(f);
        ff = -ff./kernel1.*(kernel1>2);
        ff(1,1) = 0;
        phasetest = ifft2(ff);
        phase = real(phasetest);
        finalphase = finalphase + phase;
        phi = -finalphase(1:M,1:N) + angle(subim);
        unwrappedphase = exp(1i*phi);
    end 
    outputphase =  finalphase(1:M,1:N);
    outputphase = interp2(outputphase,subsampling);
    disp('consumed time:')
    toc
    disp('************************************************')
end