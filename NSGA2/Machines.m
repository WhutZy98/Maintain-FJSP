
classdef Machines
	properties
        M_index
        Using_time = {}
        maintainTime = {}
        on = []
        End = 0
        Machine_state = 4
        JobList = []
        JobProcessingTime = []
        state = 4
        Z2kK = cell(1,4)
        Z2Kk = cell(1,4)
        Tj_k = {}
        WorkedTime = 0
        ProcessedJobs = 0
        Qi_k = {}
        M = 4
        Lambda = [0.01, 0.04, 0.02, 0.03]
    end
	methods
        %构造函数
        function obj = Machines(index,Z2kK,Z2Kk)
            obj.M_index = index;
            obj.Z2kK = Z2kK;
            obj.Z2Kk = Z2Kk;
            
        end
    end
	methods(Static)
        function J_m = update(J_m,s, pt, on, new_state)
            e = s + pt;
            J_m.Using_time{end + 1} = [s, e];
            J_m.on = [J_m.on,on];
            J_m.End = e;
            J_m.ProcessedJobs = J_m.ProcessedJobs + 1;
            J_m.WorkedTime = J_m.WorkedTime + pt;  
            J_m.Machine_state = new_state;
        end
        
        function J_m = upQi_k(J_m)
            J_m.Qi_k = cell(1,length(J_m.JobList));
            J_m.Qi_k{1} = [0, 0, 0, 1]; 
        end
        
        function [temp,J_m] = Qi(J_m,X_1j, locate_)
            JobNum = J_m.JobList;
            Q = [];
            for k = 1 : J_m.M
                First = [];
                for j = 1 : length(JobNum)
                    Second = [];
                    for k_1 = 1 : J_m.M
                        x1_j = X_1j(j);
                        q1_k_1 = J_m.Qi_k{locate_ - 1}(k_1);
                        if k_1 < k
                            Pk_1k = 0;
                        elseif k_1 == k 
                            Pk_1k = J_m.K_K(J_m,J_m.Tj_k{j}{k_1}, k);
                        elseif k_1 > k
                            Pk_1k = J_m.K_1__k(J_m,J_m.Tj_k{j}{k_1}, k_1 - 1, k);
                        end
                        Pk_1_0 = J_m.K_0(J_m,J_m.Tj_k{j}{k_1}, k_1);
                        T = J_m.JobProcessingTime(j);%t是带着中括号的[]
                        if k == J_m.M
                            Pm_k = J_m.K_K(J_m,T{1}, k); 
                        else
                            Pm_k = J_m.K_1__k(J_m,T{1}, J_m.M - 1, k);
                        end
                        Pm_0 = J_m.K_0(J_m,T{1}, J_m.M);
                        Answer = (Pk_1k + ((Pk_1_0 * Pm_k) / (1 - Pm_0)));
                        Second = [Second,Answer * x1_j * q1_k_1];
                    end
                    First = [First,sum(Second)]; 
                end
                Q = [Q,sum(First)];
            end
            for i = 1:length(Q)
                J_m.Qi_k{locate_} = [J_m.Qi_k{locate_},Q(i)];
            end
            %归一化
            P = Q / sum(Q);
            temp = lunpandu(P);
            if temp > J_m.Machine_state
                temp = J_m.Machine_state;
            end
        end
        
        function Back = K_1__k(J_m,t, K_1, K)
            lambda_ = [];
            for i = K : K_1
                lambda_ = [lambda_,J_m.Lambda(i)];
            end
            temp = 1;
            for i2 = lambda_
                temp = temp * i2;
            end
            Add = [];
            for i3 = K: K_1
                E = exp(-J_m.Lambda(i3) * t);
                B = [];
                for j = K : K_1
                    if j ~= i3
                        B = [B, J_m.Lambda(j) - J_m.Lambda(i3)];
                    end
                end
                product = 1;
                for i4 = B
                    product = i4 * product;
                end
                Add = [Add,E / product];
            end
            Back = temp * sum(Add);
        end
        
        function Back = K_K(J_m,t, K)
            
            Back = exp(J_m.Lambda(K) * t);
        end
        
        function Back = K_0(J_m, t, K)
            A = J_m.K_K(J_m,t, K);
            B = 0;        
            for i = 1:  K
                B = B + J_m.K_1__k(J_m,t, K, i);
            end
            Back = 1 - A - B;
        end
        
        function [state,J_m] = calcStation(J_m)
            locate_ = J_m.ProcessedJobs + 1; %当前工件处于加工机器的位置
            X_1j = zeros(1,length(J_m.JobList));
            X_1j(locate_ - 1) = 1;
            if locate_ == 2
                J_m = J_m.upQi_k(J_m);
            end
            [state,J_m] = J_m.Qi(J_m,X_1j, locate_);
        end
        function [e, All_pay,J_m] = upMT(J_m, num, Need_level, Rmen, op_m)
            M_start = J_m.End;
            if num == 0
                PTime = 4;
                usingMen = [];
                for r = 1 : length(Rmen)
                    for k = Rmen{r}.Work_M
                        if (op_m == k) && (Rmen{r}.level.("M" + op_m) >= Need_level)
                            if isempty(Rmen{r}.unProcessing)
                                usingMen = [usingMen,r];
                            else
                                Len = length(Rmen{r}.unProcessing);
                                temp = 0;
                                for T = 1:Len
                                    tStart = Rmen{r}.unProcessing{T}(1);
                                    tEnd = Rmen{r}.unProcessing{T}(2);
                                    if ~(tStart <= M_start && tEnd >= M_start)
                                        temp = temp + 1;
                                    end
                                end
                                if temp == Len
                                    usingMen = [usingMen,r];  
                                end
                            end
                        end
                    end
                end
                if isempty(usingMen)
                    e = M_start + 9999;
                    J_m.maintainTime{end + 1} = [M_start, e];
                    All_pay = 9999;
                    return;
                end
                choiceMan = usingMen(randi(end,1,1));
                efficiency = Rmen{choiceMan}.efficiency.("M" + op_m);
                costs = Rmen{choiceMan}.costs.("M" + op_m);
                base = Rmen{choiceMan}.base;

                All_pay = base + (PTime / efficiency * costs);
                e = M_start + PTime / efficiency;  % 完成时间
                Rmen{choiceMan}.upUnProcessing(Rmen{choiceMan},M_start, e)
                J_m.maintainTime{end + 1} = [M_start, e];
                J_m.WorkedTime = J_m.WorkedTime - 10;
                
            else
                PTime = 8;
                usingMen = [];
                for r = 1 : length(Rmen)
                    for k = Rmen{r}.Work_M
                        if (op_m == k) && (Rmen{r}.level.("M" + op_m) >= Need_level)
                            if isempty(Rmen{r}.unProcessing)
                                usingMen = [usingMen,r];
                            else
                                Len = length(Rmen{r}.unProcessing);
                                temp = 0;
                                for T = 1:Len
                                    tStart = Rmen{r}.unProcessing{T}(1);
                                    tEnd = Rmen{r}.unProcessing{T}(2);
                                    if ~(tStart <= M_start && tEnd >= M_start)
                                        temp = temp + 1;
                                    end
                                end
                                if temp == Len
                                    usingMen = [usingMen,r];  
                                end
                            end
                        end
                    end
                end
                if isempty(usingMen)
                    e = M_start + 9999;
                    J_m.maintainTime{end + 1} = [M_start, e];
                    All_pay = 9999;
                    return;
                end
                choiceMan = usingMen(randi(end,1,1));
                efficiency = Rmen{choiceMan}.efficiency.("M" + op_m);
                costs = Rmen{choiceMan}.costs.("M" + op_m);
                base = Rmen{choiceMan}.base;
                All_pay = base + (PTime / efficiency * costs);
                e = M_start + PTime / efficiency;  % 完成时间
                Rmen{choiceMan}.upUnProcessing(Rmen{choiceMan},M_start, e)
                J_m.maintainTime{end + 1} = [M_start, e];
                J_m.WorkedTime = 0;
            end
        end
    end
end
