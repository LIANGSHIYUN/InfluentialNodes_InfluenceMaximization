
% CI函数接受邻接矩阵net和整数l作为输入参数，输出一个向量index，表示每个节点的CI指数值
function index=CI(net,l)
oldnet=net; % 将原始邻接矩阵存储在oldnet中
net=oldnet^l; % 计算l次幂的邻接矩阵
net2=oldnet^(l-1); % 计算l-1次幂的邻接矩阵
%net(find(net)>1)=1;
net=sign(net); % 对l次幂的邻接矩阵进行符号函数运算，保留大于等于0的元素
%net2(find(net2)>1)=1;
net2=sign(net2); % 对l-1次幂的邻接矩阵进行符号函数运算，保留大于等于0的元素
%net=net-net2;
%net(find(net)<0)=0;
a=sum(net); % 计算每个节点的度
b=diag(a-1); % 构建对角元素为每个节点度数减1的对角矩阵
c=netb; % 计算netb，得到的是每个节点的CI值
c=c'; % 转置矩阵c
c=sum(c); % 对每个节点的CI值进行求和
index=a.*c; % 计算每个节点的CI指数值
end

