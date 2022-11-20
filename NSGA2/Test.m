Pop_size = 10;
[M,MT,J] = Reader();
[repairman, M_num, J_num, agv_trans,agv_nums] = InstanceMk01();
CHS = Encode(M, MT, Pop_size, J, J_num, M_num);
[C_finish, ~, M_Gantt, A_Gantt] = Decode(M, MT, J,CHS(2,:), J_num, M_num, agv_nums, agv_trans,repairman);

Gantt(C_finish, M_Gantt, A_Gantt,M_num,agv_nums);

