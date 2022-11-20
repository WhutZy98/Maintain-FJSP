 function[M,MT,J] = Reader()
% data = load('D:\Code\Matlab����\Mk01.txt');
%filename = 'Mk01.txt';
filename = 'Mk03.txt';
MK = dlmread(filename);
s = size(MK); %�õ�MK�ļ��е�������
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
    tr1 = tr1(2:length(tr1)); % ��0��䣬��Ҫȥ��
    tr1(tr1 == 0) = []; 
    index = 1;
    for j = 1:sigal
        sig = tr1(index);  % �ܼӹ��ù���Ļ�����
        sdx = [sdx,sig];  % ����ܹ��ӹ��ù���Ļ�����
        sigdex = [sigdex,index];  % �ӹ��������б��е�λ��
        index = index + 1 + 2 * sig;  % sig ���ܹ��ӹ��ù����Ļ�������ͬʱ�б����а���ÿ�������ӹ��ù�����ʱ�䣬�����ǳ���2
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
