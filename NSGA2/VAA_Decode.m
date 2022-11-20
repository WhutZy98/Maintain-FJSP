function[C_max, Pay, Ms, As,Js] = VAA_Decode(i,Js,Ms,As,Rmen,TT,C_finish)
    C_max = C_finish;
    Ji = Js{i};  %�ӹ�������ȡ���üӹ�����
    [J_end, J_site, op_t, op_m] = Ji.get_infor(Ji); %�ϵ�����ӹ�����ʱ�䣬��������λ�ã��ӹ�ʱ�䣬�ӹ�����
    J_m = Ms{op_m};  % J_MΪ�ù����ӹ�����
    best_agv = cell(1,1);
    min_tf = inf;
    best_s = 0;
    best_e = 0;
    t1 = 0;
    t2 = 0;
    for agv = As
        AGV = agv{1};
        A_site = AGV.Cur_Site; %agvĿǰ����λ��
        site1 = TT(A_site,:);
        trans1 = site1(J_site); % ������λ������ʱ��
        site2 = TT(J_site,:);
        trans2 = site2(op_m); % �˵��ӹ�����λ������ʱ��
        [Start, End] = AGV.ST(AGV,J_end, trans1, trans2);  % ���Start��AGV�˶��Ŀ�ʼʱ��
        if End < min_tf
            best_s = Start;
            best_e = End;
            t1 = trans1;
            t2 = trans2;
            min_tf = best_e;
            best_agv = agv;
        end
    end
    Best_agv = best_agv{1}; %Best_agv�������Ķ���
    Best_agv = Best_agv.update(Best_agv,best_s, t1, t2, J_site, op_m,Ji.J_index);
    M_start = max(best_e, J_m.End);  %AGV�͵�ʱ��͸û�����һ������ӹ����ʱ��Ƚ�
    ProcessedJobs = J_m.ProcessedJobs; %�жϸû���֮���Ƿ�ӹ�������
    Pay = 0;
    P_t = 0;
    Start = 0;
	new_state = 4;
    if ProcessedJobs == 0
        P_t = op_t;
        Start = M_start;
    else
        MachineWorkedT = J_m.WorkedTime;
        if MachineWorkedT >= 15
            [state,J_m] = J_m.calcStation(J_m);
            if (MachineWorkedT <= 30) && (state < J_m.M)
                Need_level = 1;
                new_state = state + 1;
                P_t = op_t * (J_m.M / new_state);
                [P_start, All_pay, J_m] = J_m.upMT(J_m, 0, Need_level, Rmen, op_m);
                Pay = Pay + All_pay;
                Start = max(P_start, J_m.End);
            elseif(MachineWorkedT > 30) && (state < J_m.M)
                Need_level = 3;
                new_state = J_m.M;
                P_t = op_t * (J_m.M / new_state);
                [P_start, All_pay, J_m] = J_m.upMT(J_m, 1, Need_level, Rmen, op_m);
                Pay = Pay + All_pay;
                Start = max(P_start, J_m.End);
            else
                P_t = op_t * (J_m.M / state);
                Start = M_start;
                new_state = state;
            end
        else
            [state,J_m] = J_m.calcStation(J_m);
            P_t = op_t * (J_m.M / state);
            Start = M_start;
            new_state = state;
        end
    end
    J_m = J_m.update(J_m,Start, P_t, Ji.J_index,new_state);
    Jend = J_m.End;
    Ji = Ji.update(Ji,Jend);
    if Jend > C_max
        C_max = Jend;
    end
    
    %�ӹ�������agv��������˵��Ǵ���б���δ����
    Ms{op_m} = J_m;
    As{Best_agv.AGV_index} = Best_agv;
    Js{i} = Ji;
end