function nodes=CIdynamic(net,l,seedsize)
% 基于复杂网络演化的动态影响力最大化算法

% 输入参数：
% net: 带权邻接矩阵
% l: 用于迭代计算的幂次数
% seedsize: 种子集合大小

% 输出参数：
% nodes: 影响力最大的节点集合

nodes=[];  % 初始化影响力最大的节点集合为空
oldnet=net; % 将输入邻接矩阵赋值给oldnet

% 迭代计算seedsize个节点，并将其添加到nodes集合中
for i=1:seedsize  

    net=oldnet^2; % 将oldnet矩阵平方，用于计算网络演化
    l=l-2;  % 因为平方操作相当于对l的值减2，所以这里需要将l的值减去2
    net2=oldnet;
    while l>0
        net2=net;
        net=net*oldnet; % 迭代计算网络演化        
        l=l-1;  % 幂次减一
    end
    net=sign(net); % 对网络进行符号函数操作
    net2=sign(net2);
    net(logical(eye(size(net))))=0; % 将主对角线元素设为0
    net2(logical(eye(size(net2))))=0;
    net=(1-net2).*net; % 计算动态邻接矩阵
    a=sum(oldnet)-1;
    b=a';
    c=net*b;    % 计算出度
    index=a.*c'; % 计算节点的动态中心性
    index(nodes)=-1; % 将已经选择的节点的动态中心性设为-1
    [C,I]=max(index); % 选择动态中心性最大的节点
    nodes=[nodes I]; % 将选择的节点添加到nodes集合中
    oldnet(:,I)=0; % 将oldnet中的I节点的所有入边置为0
    oldnet(I,:)=0; % 将oldnet中的I节点的所有出边置为0
end
end



