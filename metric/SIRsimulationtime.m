function [result]=SIRsimulationtime(net,nodes,infectionrate,recoverate)
    net(nodes,:)=0; % 将被隔离节点的所有出边置为0
    net(:,nodes)=0; % 将被隔离节点的所有入边置为0
    [row,vol]=size(net); % 获取网络大小
    infection=ones(row,1)*0.01; % 初始化感染者数量
    recover=zeros(row,1); % 初始化康复者数量
    sus=1-infection-recover; % 初始化易感者数量
    T=40; % 总模拟时间
    deltaT=0.1; % 时间步长
    result=[]; % 存储结果的数组
    for i=1:round(T/deltaT) % 开始模拟，循环次数为总时间除以时间步长
        if mod(i,10000)==0 % 每10000步打印一次循环次数
            i
        end
        rate1=recoverate*infection; % 计算康复率
        rate2=infectionrate*(sus.*(net*infection))-recoverate*infection; % 计算感染率
        infection=infection+rate2*deltaT; % 更新感染者数量
        recover=recover+rate1*deltaT; % 更新康复者数量
        infection(nodes)=0; % 将被隔离节点的感染者数量置为0
        recover(nodes)=0; % 将被隔离节点的康复者数量置为0
        sus=1-infection-recover; % 计算易感者数量
        u=(sum(infection)+sum(recover))*1.0/row; % 计算平均感染率
        result=[result;u]; % 将平均感染率存储到结果数组中
    end

end