classdef Jobs < handle
	properties
        J_index ;
        PT 
        MT 
        cur_site
        L_U 
        End = 0
        Cur_Operation = 1
        Cur = 1
    end
	methods
        %¹¹Ôìº¯Êý
        function job = Jobs(index, PT, MT, L_U, M_num )
            job.J_index = index;
            job.PT = PT;
            job.MT = MT;
            job.L_U = L_U;
            job.cur_site = M_num + 1;
        end
    end
    methods(Static)
        function obj = Update_C(obj)
            obj.Cur = obj.Cur + 1;
        end
        function [J_end, J_site, op_t, op_m] = get_infor(obj)
            J_end = obj.End;
            J_site = obj.cur_site;
            op_t = obj.PT{obj.Cur_Operation};
            op_m = obj.MT{obj.Cur_Operation};
            
        end
        function Ji = update(Ji,Jend)
            Ji.End = Jend;
            Ji.Cur_Operation = Ji.Cur_Operation + 1;
            Ji.cur_site = Ji.MT{Ji.Cur_Operation -1};
        end
    end

end