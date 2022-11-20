function [Ms,Js] = FirstDecode(O_Chromo, T, JM, Ms, Js)  
for i = O_Chromo
    Job = i;
	O_num = Js{Job}.Cur;
    Machine = JM{Job}{O_num};
    Ms{Machine}.JobList = [Ms{Machine}.JobList,Job];
    Ms{Machine}.JobProcessingTime = [Ms{Machine}.JobProcessingTime,T{Job}(O_num)];
	Js{Job}.Update_C(Js{Job});
end
for i = 1 : length(Ms)
    Tj_k = cell(1,length(Ms{i}.JobList));
	for j = 1 : length(Ms{i}.JobList)
        for k = 1 : Ms{i}.M
            Tj_k{j}{end + 1} = ((Ms{i}.M / (k)) * Ms{i}.JobProcessingTime{j});
        end
	end
    Ms{i}.Tj_k = Tj_k;
end
end