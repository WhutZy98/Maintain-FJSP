function[C_finish, Cost, M_gg, A_gg] = Build_Job_Machine_AGV(O_Chromo,J_num, M_num, agv_nums, T, JM, agv_trans, L_U, repairman)

Js = cell(1,J_num);
Ms = cell(1,M_num);
As = cell(1,agv_nums);
Rmen = cell(1,length(repairman));

for i = 1:J_num
    Ji = Jobs(i, T{i}, JM{i}, agv_trans, L_U);
    Js{i} = Ji;
end

[Z2kK,Z2Kk] = Z();
for j = 1:M_num
    Ms{j} = Machines(j,Z2kK,Z2Kk);
end

for k = 1:agv_nums
    As{k} = Agvs(k,L_U);
end

for r = 1 : length(repairman)
    BaseSalary = repairman{r}{1};
    Infor = repairman{r}{2};
    unprocessing = repairman{r}{3};
    man = Repairmen(r, BaseSalary, Infor, unprocessing);
    Rmen{r} = man; 
end
[Ms,Js] = FirstDecode(O_Chromo, T, JM,Ms,Js);
C_finish = 0;
Cost = 0;
% M_gg = cell(1,1);%为了让机器类放入一个元胞数组中
% A_gg = cell(1,1);
M_gg = {};
A_gg = {};
for i = O_Chromo
    [C_max, Pay, M_s, A_s, J_s] = VAA_Decode(i,Js,Ms,As,Rmen,agv_trans,C_finish);
    C_finish = C_max;
    Cost = Pay;
%     M_gg{1} = M_s;
%     A_gg{1} = A_s;
    M_gg = M_s;
	A_gg = A_s;
    Ms = M_s;
    Js = J_s;
    As = A_s;
    
end
end













