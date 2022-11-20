function[C_finish, Cost, M_Gantt, A_Gantt] = Decode(M, MT, J,CHS, J_num, M_num, agv_nums, agv_trans,repairman)
Len_Chromo = sum(J);
MS = CHS(1:Len_Chromo);
[JM, T] = Order_Matrix(MS, J, M, MT);
% for i = 1 : length(JM)
%     JM{i}{end + 1} = M_num + 1;
%     T{i}{end + 1} = 0;
% end
O_Chromo = CHS(Len_Chromo + 1:length(CHS));
[C_finish, Cost, M_Gantt, A_Gantt] = Build_Job_Machine_AGV(O_Chromo,J_num, M_num, agv_nums, T, JM, agv_trans,M_num, repairman);





