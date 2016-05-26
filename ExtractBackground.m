function OutBmp = ExtractBackground(InputBmp,Radius)
%input must be a grayscale image
%output is an image in which light intensity is homogenous 
%distributed.
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