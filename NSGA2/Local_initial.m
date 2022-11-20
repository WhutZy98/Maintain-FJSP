function[Chromo_LS] = Local_initial(Pop_size, Len_Chromo,J,M_num, J_num, M, MT)
LS_num = 0.2 * Pop_size;
MS = CHS_Matrix(LS_num, Len_Chromo);
os_list = OS_list(J);
OS = CHS_Matrix(LS_num, Len_Chromo);
for i = 1 : LS_num
    os_list = os_list(randperm(length(os_list)));%打乱的工序排序给分配到OS中
    OS(i,:) = os_list;
    GJ_list = [];
    for gj = 1 : J_num
        GJ_list = [GJ_list,gj];
    end
    for ii = GJ_list
        M_burden = zeros(1,M_num);  %用于存放每个机器的负荷
        allMachine = M{ii}; %allMachine是工件号g的所有工序的加工机器矩阵，是一个列表套列表
        allMachineT = MT{ii};
        for j = 1 : length(allMachine)
            Machine_Select = [];
            List = allMachine{j}; % 存放该工序的可用机器号 
            ListT = allMachineT{j};
            List_Useful_Machine = [];
            for num = 1 : length(List)
                List_Useful_Machine = [List_Useful_Machine,List{num}];
            end
            for Mm = List_Useful_Machine
                index = List_Useful_Machine == Mm;
                M_burden(Mm) = M_burden(Mm) + ListT{index};
                Machine_Select = [Machine_Select,M_burden(Mm)]; %对应位置相加得到各个机器累计加工时间
            end
            [~,Min_index] = min(Machine_Select);
            site = Site(ii, j, J);
            line = MS(i,:);
            line(site) = Min_index ; 
            MS(i,:) = line;
        end
    end
end
Chromo_LS =[MS,OS];