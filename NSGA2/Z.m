function[Z2kK,Z2Kk] = Z()
Z2kK = cell(1,4);
Z2Kk = cell(1,4);
for i = 1:length(Z2kK)
    for j = 1 : length(Z2kK)
        if j <= i
            Z2kK{i}{end + 1} = 1;
        else
            Z2kK{i}{end + 1} = 0;
        end
    end
end
for i = 1:length(Z2Kk)
    for j = 1 : length(Z2Kk)
        if j > i
            Z2Kk{i}{end + 1} = 1;
        else
            Z2Kk{i}{end + 1} = 0;
        end
    end
end
