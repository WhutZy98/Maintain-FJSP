function[CHS1,CHS2] = Crossover_Operation(CHS1, CHS2,J_num)
T0 = length(CHS1) / 2;
OS_1 = CHS1(T0 + 1 : 2 * T0);
OS_2 = CHS2(T0 + 1 : 2 * T0);
MS_1 = CHS1(1 : T0);
MS_2 = CHS2(1 : T0);
Job_list = [];
for i = 1 : J_num
    Job_list = [Job_list,i];
end
Job_list = Job_list(randperm(length(Job_list))); % ´òÂÒJoblist 
r = randi([2,J_num - 1]);
Set1 = Job_list(1 : r);
Set2 = Job_list(r + 1 : J_num);
new_os = zeros(1,T0);
for k = 1 : length(OS_1)
    v = OS_1(k);
    if ismember(v,Set1)
        new_os(k) = v + 1;
    end
end
for i = OS_2
    if ~ismember(i,Set1)
        Site = find(new_os == 0);
        if length(Site) > 0
            site = Site(1);
            new_os(site) = i + 1;
        end
    end
end
index = 1;
for j = new_os
    new_os(index) = j - 1;
    index = index + 1;
end
CHS1 = [MS_1,new_os];
CHS2 = [MS_2,new_os];