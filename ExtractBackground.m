function OutBmp = ExtractBackground(InputBmp,Radius)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is just a average image filter.
% input must be a greyscale image
% output is an image in which light intensity is homogeneously distributed.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[yn,xn] = size(InputBmp);

h = ones(2 * Radius + 1,2 * Radius + 1);
for ii = 1:2 * Radius + 1
    for jj = 1:2*Radius +1
        if  (ii - 1 - Radius)^2 + (jj -1 -Radius)^2 > Radius^2
            h(jj,ii) = 0;
        end
    end
end
refer = ones(yn,xn);
myrefer = filter2(h,refer);
mymean = filter2(h,InputBmp);
OutBmp = mymean./myrefer;
end