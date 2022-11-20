function[CHS] = Variation_Machine(CHS, MT, J)
T0 = length(CHS) / 2;
Tr = [];
for i_num = 1 : T0
    Tr = [Tr,i_num];
end
MS = CHS(1 : T0);
OS = CHS(T0 + 1 :2 * T0);
r = randi([2,T0 - 1]);
Tr = Tr(randperm(length(Tr)));
for i = Tr
    [Job,O_num] = reduction(i, J, T0);
    O_i = Job;
    O_j = O_num;
    Machine_time = MT{O_i}{O_j};
    Machine_time = cell2mat(Machine_time);
    [~,Min_index] = min(Machine_time);
    MS(i) = Min_index;
end
CHS = [MS,OS];


function[Job,O_num] = reduction(num, J, T0)
T1 = [];
for j = 1 :T0
    T1 = [T1,j];
end
K = {};
Site = 1;
for k = 1:length(J)
    v = J(k);
    K{end + 1} = T1(Site : Site + v - 1);
    Site = Site + v;
end
for i = 1 : length(K)
    if ismember(num,K{i})
        Job = i;
        O_num = find(K{i} == num);
        break;
    end
end


