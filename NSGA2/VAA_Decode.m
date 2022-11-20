function[C_max, Pay, Ms, As,Js] = VAA_Decode(i,Js,Ms,As,Rmen,TT,C_finish)
    C_max = C_finish;
    Ji = Js{i};  %从工件集中取出该加工工件
    [J_end, J_site, op_t, op_m] = Ji.get_infor(Ji); %上道工序加工结束时间，工件所在位置，加工时间，加工机器
    J_m = Ms{op_m};  % J_M为该工件加工机器
    best_agv = cell(1,1);
    min_tf = inf;
    best_s = 0;
    best_e = 0;
    t1 = 0;
    t2 = 0;
    for agv = As
        AGV = agv{1};
        A_site = AGV.Cur_Site; %agv目前所在位置
        site1 = TT(A_site,:);
        trans1 = site1(J_site); % 到工件位置所花时间
        site2 = TT(J_site,:);
        trans2 = site2(op_m); % 运到加工机器位置所花时间
        [Start, End] = AGV.ST(AGV,J_end, trans1, trans2);  % 这个Start是AGV运动的开始时间
        if End < min_tf
            best_s = Start;
            best_e = End;
            t1 = trans1;
            t2 = trans2;
            min_tf = best_e;
            best_agv = agv;
        end
    end
    Best_agv = best_agv{1}; %Best_agv是真正的对象
    Best_agv = Best_agv.update(Best_agv,best_s, t1, t2, J_site, op_m,Ji.J_index);
    M_start = max(best_e, J_m.End);  %AGV送到时间和该机器上一个工序加工完成时间比较
    ProcessedJobs = J_m.ProcessedJobs; %判断该机器之间是否加工过工序
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
    
    %加工机器和agv本身更新了但是存的列表中未更新
    Ms{op_m} = J_m;
    As{Best_agv.AGV_index} = Best_agv;
    Js{i} = Ji;
end