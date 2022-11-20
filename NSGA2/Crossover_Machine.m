function[CHS1,CHS2] = Crossover_Machine(CHS1,CHS2)
T0 = length(CHS1) / 2;
T_r = [];
for j = 1 : T0
    T_r = [T_r,j];
end
r = randperm(T0,1);
T_r = T_r(randperm(length(T_r))); %´òÂÒT_r
R = T_r(1:r);
OS_1 = CHS1(T0 + 1 : 2 * T0);
OS_2 = CHS2(T0 + 1 : 2 * T0);
C_1 = CHS2(1:T0);
C_2 = CHS1(1:T0);
for i = R
    K = C_1(i);
    K_2 = C_2(i);
    C_1(i) = K_2;
    C_2(i) = K;
end
CHS1 = [C_1,OS_1];
CHS2 = [C_2,OS_2];