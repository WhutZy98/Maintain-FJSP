function[Chromo_GS] = Global_initial(Pop_size, Len_Chromo,J,M_num, J_num, M, MT)
GS_num = 0.6 * Pop_size;
MS = CHS_Matrix(GS_num, Len_Chromo);
os_list = OS_list(J);
OS = CHS_Matrix(GS_num, Len_Chromo);
for i = 1 : GS_num
    M_burden = zeros(1,M_num);  %用于存放每个机器的负荷
    os_list = os_list(randperm(length(os_list)));%打乱的工序排序给分配到OS中
    OS(i,:) = os_list;
    GJ_list = [];
    for gj = 1 : J_num
        GJ_list = [GJ_list,gj];
    end
    GJ_list = GJ_list(randperm(length(GJ_list)));
    for g = GJ_list
        
        allMachine = M{g}; %allMachine是工件号g的所有工序的加工机器矩阵，是一个列表套列表
        allMachineT = MT{g};
        for ii = 1 : length(allMachine)
            Machine_Select = [];
            List = allMachine{ii}; % 存放该工序的可用机器号
            %先将List_Useful_Machine中的元素遍历存放数组中
            List_Useful_Machine = [];
            for num = 1 : length(List)
                List_Useful_Machine = [List_Useful_Machine,List{num}];
            end
            for Mm = List_Useful_Machine
                index = find(List_Useful_Machine == Mm);
                Machine_Select = [Machine_Select,M_burden(Mm) + allMachineT{ii}{index}]; %对应位置相加得到各个机器累计加工时间
            end
            [Min_time,Min_index] = min(Machine_Select);
            I = List_Useful_Machine(Min_index);  %得到的是在可用加工机器集中的顺序号
            M_burden(I) = M_burden(I) + Min_time;  %更新加工机器的加工时间
            site = Site(g, ii, J);  %返回的是工序位置
            line = MS(i,:);
            line(site) = Min_index ; 
            MS(i,:) = line;
        end
    end
end
Chromo_GS =[MS,OS];
