 function[M,MT,J] = Reader()
% data = load('D:\Code\Matlab代码\Mk01.txt');
%filename = 'Mk01.txt';
filename = 'Mk03.txt';
MK = dlmread(filename);
s = size(MK); %得到MK文件中的行与列
M = cell(1,s(1));
MT = cell(1,s(1));
J = [];
for line = 1:s(1)
	tr1 = MK(line,:);
    sigdex = [];
    mac = [];
    mact = [];
    sdx = [];
    sigal = tr1(1);
    J = [J,sigal];

    M{line} = cell(1,sigal);
    MT{line} = cell(1,sigal);
    tr1 = tr1(2:length(tr1)); % 有0填充，需要去除
    tr1(tr1 == 0) = []; 
    index = 1;
    for j = 1:sigal
        sig = tr1(index);  % 能加工该工序的机器数
        sdx = [sdx,sig];  % 存放能够加工该工序的机器数
        sigdex = [sigdex,index];  % 加工机器在列表中的位置
        index = index + 1 + 2 * sig;  % sig 是能够加工该工件的机器数，同时列表中有包含每个机器加工该工件的时间，所以是乘以2
    end

    for ij = 1 : sigal
       tr1(sigdex(ij) - (ij - 1)) = []; 
    end
	temp = 1;
	M_index = 1;
    for ii = 1 : 2 : length(tr1)
        M{line}{temp}{end + 1} = tr1(ii);
        MT{line}{temp}{end + 1} = tr1(ii + 1);
        M_index = M_index + 1;
        if M_index == sdx(temp) + 1
            M_index = 1;
            temp = temp + 1;
        end
    end

end
