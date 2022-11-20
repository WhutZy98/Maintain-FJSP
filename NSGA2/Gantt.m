function Gantt(C_finish, M_Gantt, A_Gantt,M_num,agv_nums)

axis([0,round(C_finish +10),0,M_num + agv_nums + 1]);%x轴 y轴的范围
set(gca,'xtick',0:round(0.05 * (C_finish +10)):round(C_finish +10)) ;%x轴的增长幅度
set(gca,'ytick',0:M_num + agv_nums) ;%y轴的增长幅度

yticklabels({'','AGV1','AGV2','M1','M2','M3','M4','M5','M6'})
xlabel('加工时间','FontName','微软雅黑','Color','black','FontSize',16)
ylabel('机器号','FontName','微软雅黑','Color','black','FontSize',16,'Rotation',90)
title('Gantt','fontname','微软雅黑','Color','black','FontSize',16);%图形的标题
color = [246/256,86/256,20/256;255/256,187/256,0/256;0/256,161/256,241/256;
    124/256,187/256,0;252/256,170/256,103/256;219/256,249/256,244/256;
    0,70/256,222/256;54/256,195/256,201/256;48/256,151/256,164/256;
    0.00,0.45,0.74;0.85,0.33,0.10;
    0.93,0.69,0.13;240/256,100/256,73/256;48/256,151/256,164/256;
    239/256,111/256,108/256;92/256,158/256,173/256;
    206/256,190/256,190/256;255/256,170/256,50/256];
for i = 1:length(A_Gantt)
    agv = A_Gantt{i};
    UsingTime = agv.Using_time;
    agv_on = agv.on;
    for m = 1 : length(UsingTime)
        T = cell2mat(UsingTime(m));
        if T(2) - T(1) ~= 0
            if agv_on(m) ~= -1
                rec(1) = T(1);%矩形的横坐标,即工序的开始时间
                rec(2) = i - 0.2;%矩形左下角的纵坐标，即机器号
                rec(3) = T(2) - T(1);  %矩形的长度，即加工时间
                rec(4) = 0.4; %矩形的高度
                rectangle('Position',rec,'LineWidth',0.5,'LineStyle','-','FaceColor',color(agv_on(m),:));
            else
                rec(1) = T(1);%矩形的横坐标,即工序的开始时间
                rec(2) = i - 0.2;%矩形左下角的纵坐标，即机器号
                rec(3) = T(2) - T(1);  %矩形的长度，即加工时间
                rec(4) = 0.4; %矩形的高度
                rectangle('Position',rec,'LineWidth',0.5,'LineStyle','-','FaceColor','white');
            end
        end
    end
end
line([0 round(C_finish +10)],[2.5 2.5],'linestyle','-', 'Color','black', 'LineWidth', 1);
for i = 1 : length(M_Gantt)
    Machine = M_Gantt{i};
    UsingTime = Machine.Using_time;
    mainTainTime = Machine.maintainTime;
    rec = [0,0,0,0];
    for j = 1:length(UsingTime)
        start = UsingTime{j}(1);
        end_ = UsingTime{j}(2); 
        rec(1) = start;%矩形的横坐标,即工序的开始时间
        rec(2) = i + agv_nums - 0.2;%矩形左下角的纵坐标，即机器号
        rec(3) = end_ - start;  %矩形的长度，即加工时间
        rec(4) = 0.4; %矩形的高度
        J = Machine.on(j);
        txt=sprintf('%d',J);%工序号
        rectangle('Position',rec,'LineWidth',0.5,'LineStyle','-','FaceColor',color(J,:));
        text(rec(1),rec(2) + 0.2,txt,'FontSize',6);
    end
    for k = 1:length(mainTainTime)
        start = mainTainTime{k}(1);
        end_ = mainTainTime{k}(2); 
        rec(1) = start;%矩形的横坐标,即工序的开始时间
        rec(2) = i + agv_nums - 0.2;%矩形左下角的纵坐标，即机器号
        rec(3) = end_ - start;  %矩形的长度，即加工时间
        rec(4) = 0.4; %矩形的高度
        %J = Machine.on(j);
        %txt=sprintf('%d',J);%工序号
        rectangle('Position',rec,'LineWidth',0.5,'LineStyle','-','FaceColor','black');
        %text(rec(1),rec(2) - 0.5,txt,'FontSize',6);
    end
end