function [fraction]=giantcomponent(net,seeds,step)
    % net: 网络的邻接矩阵表示
    % seeds: 需要去除的节点数列表
    % step: 每次去除节点数的步长
    % fraction: 去除相应数量的节点后，最大连通分量的比例列表
     fraction=[];    % 初始化返回结果列表
    for i=1:step:length(seeds)  % 遍历节点数列表
        net(seeds(1:i),:)=0;   % 去除前 i 个节点的出边
        net(:,seeds(1:i))=0;   % 去除前 i 个节点的入边
        [ clusternumber,clusterindex,largestclusterindex] = Cluster_Gbl(net); % 计算连通分量
        fraction=[fraction;length(largestclusterindex)/size(net,1)];  % 将最大连通分量所占比例加入结果列表
    end
end
