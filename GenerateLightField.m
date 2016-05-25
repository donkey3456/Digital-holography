function generatedField = GenerateLightField(input,fy,fx,LowpassR)
    [yn,xn]=size(input);

    [gridx gridy]= meshgrid(1:xn,1:yn);
    R = exp(1i * 2 * pi * (fx/xn.*gridx+fy/yn.*gridy));
    shiftedinput = input .* R;
    filteredinput = LowpassFilter2(shiftedinput,LowpassR);
    filteredinput = ExtractBackground(filteredinput,8);
    generatedField = filteredinput./R./abs(filteredinput);
end
 