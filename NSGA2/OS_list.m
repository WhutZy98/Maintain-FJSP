function[os_list] = OS_list(J)
os_list = [];
num = 1;
for j = J
    for op = 1:j
        os_list = [os_list,num];
    end
    num = num + 1;
end
