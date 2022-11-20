function[Chromo_RS] = Random_initial(Pop_size,Len_Chromo,J, J_num, M)
RS_num = 0.2 * Pop_size;
MS = CHS_Matrix(RS_num, Len_Chromo);
os_list = OS_list(J);
OS = CHS_Matrix(RS_num, Len_Chromo);
for i = 1 : RS_num
    os_list = os_list(randperm(length(os_list)));%打乱的工序排序给分配到OS中
    OS(i,:) = os_list;
    temp = 1;
    GJ_list = [];
    for gj = 1 : J_num
        GJ_list = [GJ_list,gj];
    end
    for ii = GJ_list
        allMachine = M{ii};
        for j = 1: length(allMachine)
            List = allMachine{j};
            List_Useful_Machine = [];
            for num = 1 : length(List)
                List_Useful_Machine = [List_Useful_Machine,List{num}];
            end
            Machine = List_Useful_Machine(randi(end,1,1));
            Machine_add = find(List_Useful_Machine == Machine);
            line = MS(i,:);
            line(temp) = Machine_add;
            MS(i,:) = line;
            temp = temp + 1;
        end
    end
end
Chromo_RS = [MS,OS];