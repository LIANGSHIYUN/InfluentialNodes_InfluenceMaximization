function [clusternumber,clusterindex,largestclusterindex] = Cluster_Gbl(mat)
% 将输入的矩阵转换为稀疏矩阵
mat=sparse(mat);
% 调用 components 函数计算连通性和社团划分信息
[ci,size]=components(mat);
% 将社团编号转换为行向量
clusterindex=ci';
% 找到最大连通子图的编号
largestclusterindex=find(max(size));
% 计算连通分量的数量
clusternumber=max(components(mat));
% 找到最大连通子图的节点所属社团编号
largestclusterindex=find(clusterindex==largestclusterindex);
end

function [clusterindex, clusternumber] = components(mat)
    g = graph(mat);
    [~, clusterindex] = conncomp(g);
    clusternumber = max(clusterindex);
end

