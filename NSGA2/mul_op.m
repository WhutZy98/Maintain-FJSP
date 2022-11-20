function[front, crowd, crowder] = mul_op(answer)
    crowder = {};
    crowd = {};
    front = divide(answer); 
    for i = 1:length(front)
        x = [];
        y = [];
        for j = 1:length(front{i})
            x = [x,answer{front{i}(j)}(1)];
            y = [y,answer{front{i}(j)}(2)];
        end
        sig =  front{i};
        clo = cell(1,length(front{i}));
        %将x,y转为数组
        x = cell2mat(x);
        y = cell2mat(y);
        if length(sig) > 1
            [x, x_index] = sort(x, 'ascend');
            [y, y_index] = sort(y, 'ascend');
            dis1 = [];
            dis2 = [];
            dis1 = [dis1,100000];
            dis2 = [dis2,100000];
            if length(sig) > 2
                for k = 2: length(sig) - 1
                    distance1 = (x(k + 1) - x(k - 1));
                    distance2 = (y(k + 1) - y(k - 1));
                    dis1 = [dis1,distance1];
                    dis2 = [dis2,distance2];
                end
            end
            dis1 = [dis1,100001];
            dis2 = [dis1,100001];
            crow = [];
            for m = 1 : length(sig)
                index1 = find(x_index == m);
                index2 = find(y_index == m);
                cro = dis1(index1) + dis2(index2);
                crow = [crow,cro];
            end
            crowd{end + 1} = crow;
            [~,index] = sort(crow, 'ascend');
            for n = 1 : length(index)
                clo{n} = sig(index(n));
            end
            for o = length(clo):-1:1
                crowder{end + 1} = clo{o};
            end
        else
            crowder{end + 1} = front{i}(1);
            crowd{end + 1} = 1;
        end
    end
end

function[front] = divide(answer)
    S = cell(1,length(answer));
    front = {[]};
    n = zeros(1,length(answer));
    rank = zeros(1,length(answer));
    for p = 1 : length(answer)
        for q = 1 :length(answer)
            if answer{p}{1} < answer{q}{1} && answer{p}{2} < answer{q}{2}
                if ~(ismember(q,S{p}))
                    S{p} = [S{p},q];
                end
            elseif answer{p}{1} > answer{q}{1} && answer{p}{2} > answer{q}{2}
                n(p) = n(p) + 1;
            end
        end
        if n(p) == 0
            rank(p) = 0;
            if ~(ismember(p,front{1}))
                front{1} = [front{1},p];
            end
        end
    end
    i = 1;
    while ~isempty(front{i})
        Q = [];
        for p = front{i}
            for q = S{p}
                n(q) = n(q) - 1;
                if n(q) == 0
                    rank(q) = i + 1;
                    if ~(ismember(q,Q))
                        Q = [Q,q];
                    end
                end
            end
        end
        i = i + 1;
        front{end + 1} = Q;
    end
    front(cellfun(@isempty,front)) = [];
end
