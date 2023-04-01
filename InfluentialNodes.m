function [result,fraction,sim]=InfluentialNodes(net,drivernumber)
% 功能：提取网络中的影响节点
% 输入参数：
%   net: 网络邻接矩阵
%   drivernumber: 影响节点数目
% 输出参数：
%   result: 每个中心性度量方法下，选出的影响节点编号
%   fraction: 每个中心性度量方法下，选出的影响节点对应的网络分裂比例
%   sim: 每个中心性度量方法下，选出的影响节点对应的SIR模型传播效果

%%1:degree,2:Betweenness,3:PageRank,4:Eigenvector centrality,
% 5:K-core,6:Collective influence,7:Nonbacktracking matrix
%%8:IMM

% 对网络邻接矩阵进行处理，包括转置、去掉对角线、设置阈值等
net=net+net'; % 双向边% 将网络变成无向图
net(find(net>0.5))=1; % 大于 0.5 的边权重设为 1
net=full(net); % 将稀疏矩阵转换为密集矩阵% 将网络存储成完整矩阵
for i=1:size(net,1)
    net(i,i)=0; % 对角线元素为0% 将自环边设为0
end
oldnet=net; % 备份网络
oldtag=1:size(net,1); % 对每个节点做标记


% 以下代码是计算网络节点的中心性指标，包括度中心性、介数中心性、PageRank、特征向量中心性、K-shell中心性、
% Collective Influence、 Nonbacktracking Matrix 和 IMM
% 对于每个中心性指标，计算前 drivernumber 个重要的节点作为种子节点
% 对每个中心性度量方法选出的影响节点，进行编号，并存储

% 计算度中心性
a=sum(net);
[B,IX]=sort(a,'descend');
seeds1=IX(1:drivernumber);

% 计算介数中心性
a=betweenness_centrality(sparse(net));
[B,IX]=sort(a,'descend');
seeds2=IX(1:drivernumber);

% 计算 PageRank
a=PageRank(net,0.85);
[B,IX]=sort(a,'descend');
seeds3=IX(1:drivernumber)';

% 计算特征向量中心性
[a,D]=eigs(net,1,'la');
a=sum(a)*a;
[B,IX]=sort(a,'descend');
seeds4=IX(1:drivernumber)';

% 计算 K-shell 中心性
[shell]=K_shell(net);
[B,IX]=sort(a,'descend');
seeds5=IX(1:drivernumber)';

% Collective Influence
seeds7=CIdynamic(net,2,drivernumber);

% Nonbacktracking Matrix
a=nonbackmatrix(net);
[B,IX]=sort(a,'descend');
seeds8=IX(1:drivernumber)';

% IMM 算法
IX=RIS_m(net,drivernumber);
seeds9=IX';

% 恢复网络邻接矩阵% 将计算出来的节点集合与之前的节点做对应
net=oldnet;
seeds1=oldtag(seeds1);
seeds2=oldtag(seeds2);
seeds3=oldtag(seeds3);
seeds4=oldtag(seeds4);
seeds5=oldtag(seeds5);
seeds7=oldtag(seeds7);
seeds8=oldtag(seeds8);
seeds9=oldtag(seeds9);
seedsall=[seeds1;seeds2;seeds3;seeds4;seeds5;seeds7;seeds8;seeds9];
% 对不同中心性算法得到的种子节点进行SIR模拟，计算传播结果

infectrate=0.1; %感染率
recoverate=0.5; %恢复率
step=floor(length(seeds1)/16); %传播步长，将节点分为16组

% 对不同的中心性算法得到的种子节点进行SIR模拟，并计算传播结果
%eigadjacent: 对于一个邻接矩阵和一组种子节点，计算出每个节点的中心性，
% 并返回按照中心性从高到低排序的节点索引。
%giantcomponent: 对于一个邻接矩阵和一组种子节点，计算出每次去除一部分种子节点后
% 最大连通子图节点数占总节点数的比例，并返回所有比例值。
% SIRsimulationtime: 对于一个邻接矩阵和一组种子节点，使用SIR模型进行传染病模拟，
% 并返回每个时间步中易感者、感染者和恢复者的数量

% 1. degree centrality
[result1]=eigadjacent(net,seeds1,step); % 使用eigadjacent函数
fraction1=giantcomponent(net,seeds1,step); %计算最大连通子图的节点占比
[sim1]=SIRsimulationtime(net,seeds1,infectrate,recoverate); %计算传播结果

% 2. betweenness centrality
[result2]=eigadjacent(net,seeds2,step);
fraction2=giantcomponent(net,seeds2,step);
[sim2]=SIRsimulationtime(net,seeds2,infectrate,recoverate);

% 3. PageRank centrality
[result3]=eigadjacent(net,seeds3,step);
fraction3=giantcomponent(net,seeds3,step);
[sim3]=SIRsimulationtime(net,seeds3,infectrate,recoverate);

% 4. Eigenvector centrality
[result4]=eigadjacent(net,seeds4,step);
fraction4=giantcomponent(net,seeds4,step);
[sim4]=SIRsimulationtime(net,seeds4,infectrate,recoverate);

% 5. K-core centrality
[result5]=eigadjacent(net,seeds5,step);
fraction5=giantcomponent(net,seeds5,step);
[sim5]=SIRsimulationtime(net,seeds5,infectrate,recoverate);

% 7. Collective influence
[result7]=eigadjacent(net,seeds7,step);
fraction7=giantcomponent(net,seeds7,step);
[sim7]=SIRsimulationtime(net,seeds7,infectrate,recoverate);

% 8. Nonback tracking matrix
[result8]=eigadjacent(net,seeds8,step);
fraction8=giantcomponent(net,seeds8,step);
[sim8]=SIRsimulationtime(net,seeds8,infectrate,recoverate);

% 9. IMM algorithm 
 [result9]=eigadjacent(net,seeds9,step);
 fraction9=giantcomponent(net,seeds9,step);
 [sim9]=SIRsimulationtime(net,seeds9,infectrate,recoverate);

% 将所有结果合并到结果数组
result=[result1 result2 result3 result4 result5 result7 result8 result9];
fraction=[fraction1 fraction2 fraction3 fraction4 fraction5 fraction7 fraction8 fraction9];
sim=[sim1 sim2 sim3 sim4 sim5 sim7 sim8 sim9];


% 绘图
% 绘制三张图表格，分别是算法结果，网络中的巨型组件占比和SIR模型的模拟结果
figure
% subplot(1,3,1);
title("特征值最小化");
plot(result,'-*');
legend({'HD','BC','pagerank','EC','K-Shell','CI','NBM','IMM'},'Location','northoutside','Orientation','horizontal');
figure
% subplot(1,3,2);
title("网络拆解");
plot(fraction,'-*');
legend({'HD','BC','pagerank','EC','K-Shell','CI','NBM','IMM'},'Location','northoutside','Orientation','horizontal');
figure
% subplot(1,3,3);
title("SIR");
plot(sim,'-*','MarkerIndices',1:25:400);
legend({'HD','BC','pagerank','EC','K-Shell','CI','NBM','IMM'},'Location','northoutside','Orientation','horizontal');
end











