for i = 0:9
    info = dicominfo("00000" + i + ".dcm");
    disp("Slice " + i);
    info.SliceThickness
end

for i = 10:55
    info = dicominfo("0000" + i + ".dcm");
    disp("Slice " + i);
    info.SliceThickness
end