classdef Repairmen
	properties
       	index
        base
        infor
        unProcessing
        End = 0
        level
        efficiency 
        costs
        Work_M = []
    
    end
	methods
        %¹¹Ôìº¯Êý
        function re = Repairmen(r, BaseSalary, Infor, unprocessing)
            re.index = r;
            re.base = BaseSalary;
            re.infor = Infor;
            re.unProcessing = unprocessing;
            for i = 1 : length(re.infor)
                if re.infor{i}(1) ~= 0
                    re.Work_M = [re.Work_M, i];
                    re.level.("M" + i) = re.infor{i}(1);
                    re.efficiency.("M" + i) = re.infor{i}(2);
                    re.costs.("M" + i) = re.infor{i}(3);
                end
            end
        end
    end
    methods(Static)
        function upUnProcessing(Rman,M_start, e)
            Rman.unProcessing{end + 1} = [M_start, e];
        end
    end
end
