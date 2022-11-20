function[CHS] = Encode(M, MT, Pop_size, J, J_num, M_num)
Len_Chromo = sum(J);
[Chromo_GS] = Global_initial(Pop_size,Len_Chromo,J,M_num, J_num, M, MT);
[Chromo_LS] = Local_initial(Pop_size,Len_Chromo,J,M_num, J_num, M, MT);
[Chromo_RS] = Random_initial(Pop_size,Len_Chromo,J, J_num, M);

CHS = [Chromo_GS;Chromo_LS;Chromo_RS];



