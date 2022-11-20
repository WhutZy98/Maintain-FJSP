function[Chromo_GS] = Global_initial(Pop_size, Len_Chromo,J,M_num, J_num, M, MT)
GS_num = 0.6 * Pop_size;
MS = CHS_Matrix(GS_num, Len_Chromo);
os_list = OS_list(J);
OS = CHS_Matrix(GS_num, Len_Chromo);
for i = 1 : GS_num
    M_burden = zeros(1,M_num);  %���ڴ��ÿ�������ĸ���
    os_list = os_list(randperm(length(os_list)));%���ҵĹ�����������䵽OS��
    OS(i,:) = os_list;
    GJ_list = [];
    for gj = 1 : J_num
        GJ_list = [GJ_list,gj];
    end
    GJ_list = GJ_list(randperm(length(GJ_list)));
    for g = GJ_list
        
        allMachine = M{g}; %allMachine�ǹ�����g�����й���ļӹ�����������һ���б����б�
        allMachineT = MT{g};
        for ii = 1 : length(allMachine)
            Machine_Select = [];
            List = allMachine{ii}; % ��Ÿù���Ŀ��û�����
            %�Ƚ�List_Useful_Machine�е�Ԫ�ر������������
            List_Useful_Machine = [];
            for num = 1 : length(List)
                List_Useful_Machine = [List_Useful_Machine,List{num}];
            end
            for Mm = List_Useful_Machine
                index = find(List_Useful_Machine == Mm);
                Machine_Select = [Machine_Select,M_burden(Mm) + allMachineT{ii}{index}]; %��Ӧλ����ӵõ����������ۼƼӹ�ʱ��
            end
            [Min_time,Min_index] = min(Machine_Select);
            I = List_Useful_Machine(Min_index);  %�õ������ڿ��üӹ��������е�˳���
            M_burden(I) = M_burden(I) + Min_time;  %���¼ӹ������ļӹ�ʱ��
            site = Site(g, ii, J);  %���ص��ǹ���λ��
            line = MS(i,:);
            line(site) = Min_index ; 
            MS(i,:) = line;
        end
    end
end
Chromo_GS =[MS,OS];
