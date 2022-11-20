function[pareto_CHS] = Variation_Operation(CHS,J_num,M, MT, J, M_num, agv_nums, agv_trans,repairman)
T0 = length(CHS) / 2;
MS = CHS(1 : T0);
OS = CHS(T0 + 1 :2 * T0);
%r = randi([2,J_num - 1]);
r = 4;
Tr = [];
for i = 1 : J_num
    Tr = [Tr,i];
end
Tr = Tr(randperm(length(Tr)));
Tr = Tr(1 : r);
% [os,index] = sort(OS, 'ascend');
% J_os = {};%每个cell中存了序号和对应的位置
% for i = 1:length(index)
%     J_os{end + 1} = [index(i),os(i)];
% end
Site = [];
for i = 1 : r
    temp = find(OS == Tr(i));
    Site = [Site,temp(1)];
end
A = perms(Tr);
A_CHS = {};
for i = 1:length(A)
    for j = 1:length(A(i,:))
        OS(Site(j)) = A(i,j);
    end
    C_I = [MS,OS];
    A_CHS{end + 1} = C_I;
end
answer = {};
for i = 1 : length(A_CHS)
    [C_finish, Cost, M_Gantt, A_Gantt] = Decode(M, MT, J,A_CHS{i}, J_num, M_num, agv_nums, agv_trans,repairman);
    answer{end + 1} = [C_finish, Cost, M_Gantt, A_Gantt];
end
[front, ~, ~] = mul_op(answer);
signal = front{1};
index = signal(randi(numel(signal),1,1));
pareto_CHS = A_CHS{index};
