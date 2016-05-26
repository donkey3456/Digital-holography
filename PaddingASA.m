function output = PaddingASA(im,z,px,py,lambda)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a varient of ASA
% Before the implementation of ASA, the light field is padded with some pixel
% This could reduce noise and an aliasing problem.
% But sometimes it will make things worse....
% Thus you need to try it. Also there are many different padding strategy. You can try different methods.
% Reference: 
% https://www.osapublishing.org/vjbo/viewmedia.cfm?uri=josaa-29-9-1956&seq=0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    PNum = 512;
    [ny,nx] = size(im);
    k = 2 * pi / lambda;
    NY=ny+PNum;
    NX=nx+PNum;
    phase = angle(im);
    
    im1 = ones(NY,NX)*exp(1i*k*mean(phase(:)));
    im1(PNum/2+1:NY-PNum/2,PNum/2+1:NX-PNum/2)=im;      % pad constant pixels
    im1 = LowpassFilter2(im1,10);                       % apply low-pass filter, to eliminate the sharp changes.
    im1(PNum/2+1:NY-PNum/2,PNum/2+1:NX-PNum/2)=im;
    
    recon = ASA(im1,z,px,py,lambda);                    % Angular spectrum approach

    output = recon(PNum/2+1:NY-PNum/2,PNum/2+1:NX-PNum/2);  %
end