function[O_num] = Site(Job, Operation,J)
O_num = 0;
for i = 1:length(J)
    if i == Job
       O_num = O_num + Operation;
       break;
    else
        O_num = O_num + J(i);
    end
end
