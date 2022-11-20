classdef Agvs
	properties
        AGV_index
        Cur_Site
        Using_time = {}
        on = []
        to = {}
        End = 0
    end
	methods
        %¹¹Ôìº¯Êý
        function agv = Agvs(index,L_U)
            agv.AGV_index = index;
            agv.Cur_Site = L_U + 1;
            
        end
    end
	methods(Static)  
        function  [S,E] = ST(agv,s,t1,t2)  
            start = max(s, agv.End + t1);
            S = start - t1;
            E = start + t2;
            
        end
        function Best_agv = update(Best_agv,s, trans1, trans2, J_site, J_m,J_index)
            Best_agv.Using_time{end + 1} = [s, s + trans1];
            Best_agv.Using_time{end + 1} = [s + trans1, s + trans1 + trans2];
            Best_agv.on = [Best_agv.on,-1];
            Best_agv.on = [Best_agv.on,J_index];
            Best_agv.to{end + 1} = [J_site, J_m];   
            Best_agv.End = s + trans1 + trans2;
            Best_agv.Cur_Site = J_m;
        end

    end
end