function BC = betweenness_centrality(net)
% 计算邻接矩阵 net 的介数中心性（betweenness centrality）

% 节点数量
n = size(net, 1);

% 计算所有节点对之间的距离矩阵
D = net;
for k = 1:n
    D = min(D, repmat(D(:, k), 1, n) + repmat(D(k, :), n, 1));
end

% 初始化介数中心性
BC = zeros(1, n);

% 计算每个节点的介数中心性
for i = 1:n
    % 获取节点i到所有其他节点的最短路径距离
    dist_i = D(i, :);
    dist_i(dist_i == Inf) = 0;
    
    % 计算节点i的前驱节点
    pred_i = repmat(dist_i, n, 1) == repmat(dist_i', 1, n) - net;
    pred_i(i, :) = false;
    
    % 计算节点i的介数中心性
    for j = 1:n
        if j == i
            continue;
        end
        
        % 统计经过节点i的最短路径数量
        count = 0;
        for k = 1:n
            if pred_i(k, j)
                count = count + 1;
            end
        end
        
        % 更新节点j的介数中心性
        if count > 0
            BC(j) = BC(j) + 1 / count;
        end
    end
end
end
