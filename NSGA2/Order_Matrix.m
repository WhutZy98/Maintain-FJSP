function[JM, T] = Order_Matrix(MS, J, M, MT)
	JM = cell(1,length(J));
	T = cell(1,length(J));
    Ms_decompose = cell(1,length(J));
	Site = 1;
    for g = 1 : length(J) %需要遍历字典的所有值
        S_i = J(g);
        Ms_decompose{g} = MS(Site:Site + S_i - 1);
        Site = Site + S_i;
    end
    for i = 1 : length(Ms_decompose)
        JM_i = [];
        T_i = [];
        for j = 1:length(Ms_decompose{i})
            M_ij = M{i}{j};
            T_ij = MT{i}{j};
            JM_i = [JM_i,M_ij(Ms_decompose{i}(j))];
            T_i = [T_i,T_ij(Ms_decompose{i}(j))];
        end
        JM{i} = JM_i;
        T{i} = T_i;
    end

    