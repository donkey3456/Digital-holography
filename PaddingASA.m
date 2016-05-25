function output = PaddingASA(im,z,px,py,lambda)


    PNum = 512;
    [ny,nx] = size(im);
    k = 2 * pi / lambda;
    NY=ny+PNum;
    NX=nx+PNum;
    phase = angle(im);
    
    im1 = ones(NY,NX)*exp(1i*k*mean(phase(:)));
    im1(PNum/2+1:NY-PNum/2,PNum/2+1:NX-PNum/2)=im;
    im1 = LowpassFilter2(im1,10);
    im1(PNum/2+1:NY-PNum/2,PNum/2+1:NX-PNum/2)=im;
    
    recon = ASA(im1,z,px,py,lambda);

    output = recon(PNum/2+1:NY-PNum/2,PNum/2+1:NX-PNum/2);
end