Pop_size = 10;
P_c = 0.8; %交叉概率
P_m = 0.3; %变异概率
P_v = 0.5; %选择何种方式进行交叉
P_w = 0.9; %采用何种方式进行变异
Max_Itertions = 2; %最大迭代次数

%导入数据
[M,MT,J] = Reader();
%[repairman, M_num, J_num, agv_trans,agv_nums] = InstanceMk01();
[repairman, M_num, J_num, agv_trans,agv_nums] = InstanceMk03();
%编码
CHS = Encode(M, MT, Pop_size, J, J_num, M_num);

answer = {};

for gen = 1:Max_Itertions
	answer2 = {}; 
	if gen == 1
        for i = 1 : size(CHS,1)
            [C_finish, Cost, M_Gantt, A_Gantt] = Decode(M, MT, J,CHS(i,:), J_num, M_num, agv_nums, agv_trans,repairman) ;
            answer{end + 1} = [C_finish, Cost, M_Gantt, A_Gantt];
        end
        [front, crowd, crowder] = mul_op(answer);
        %front是前沿面，前沿面中是种群个体下标
        %crowd 是拥挤度
        %corwder 是拥挤度从大到小排列的下标
	end
    index_sort = crowder;
    index_sort = cell2mat(index_sort);
    index_sort = index_sort(1,1:Pop_size);
    CHS = CHS(index_sort,:);
%  交叉变异
	for j = 1 : size(CHS,1)
        offspring = [];
        if rand(1) < P_c
            N_i = randperm(size(CHS,1),1);
            if rand(1) < P_v
                [CHS1,CHS2] = Crossover_Machine(CHS(j,:), CHS(N_i,:));
            else
                [CHS1,CHS2] = Crossover_Operation(CHS(j,:), CHS(N_i,:),J_num);
            end
            offspring = [offspring;CHS1];
            offspring = [offspring;CHS2];
        end
        if rand(1) < P_m
            if rand(1) < P_w
                Mutation = Variation_Machine(CHS(j,:), MT, J);
            else
                Mutation = Variation_Operation(CHS(j,:),J_num,M, MT, J, M_num, agv_nums, agv_trans,repairman);
            end
            offspring = [offspring;Mutation];
        end
        if ~isempty(offspring)
            CHS = [CHS;offspring];
        end
	end
    for i = 1 : size(CHS,1)
        [C_finish, Cost, M_Gantt, A_Gantt] = Decode(M, MT, J,CHS(i,:), J_num, M_num, agv_nums, agv_trans,repairman);
        answer2{end + 1} = [C_finish, Cost, M_Gantt, A_Gantt];
    end
    answer = answer2;
    [front, crowd, crowder] = mul_op(answer);
    signal = front{1};
	pareto = {};
    for i = signal
        pareto{end + 1} = answer{i};
    end
    x = [];
    y = [];
    for i = 1 : length(pareto)
        x = [x,pareto{i}(1)];
        y = [y,pareto{i}(2)];
    end
    x = cell2mat(x);
    y = cell2mat(y);
    fprintf('gen = %d\n',gen)
    if gen == Max_Itertions
        high = max(y);
        low = min(y);
        if high ~= low
            figure(1)
            xlabel('最小完工时间');
            ylabel('工资');
            scatter(x, y);
            figure(2)
            fit_ = pareto{1}(1);
            Mg = pareto{1}(3:8);
            Ag = pareto{1}(9:10);
            Gantt(fit_, Mg, Ag,M_num,agv_nums)
        else
            figure(1)
            [fit_,index] = min(x);
            Mg = pareto{index}(3:8);
            Ag = pareto{index}(9:10);
            Gantt(fit_, Mg, Ag,M_num,agv_nums)
        end
    end
    
end