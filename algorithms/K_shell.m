function [shell]=K_shell(mat)
% K-shell 算法
% 输入参数:
% mat: 矩阵表示的图形，mat(i,j)=1表示i,j节点相连，否则为0
% 输出参数:
% shell: 各个节点的壳数，壳数越大表示节点越中心
% 算法过程:
% 1. 计算节点的度（与其相连的节点数）并记录下来
% 2. 对度为1的节点进行操作，将其从图中删除，并把与之相连的节点的度数减1
% 3. 如果图中还存在度为1的节点，返回第2步；否则将当前节点的壳数设为k+1，继续进行操作
% 4. 重复步骤2-3，直到所有节点的壳数计算完毕
% 备注:
% 此代码中的矩阵表示方法是邻接矩阵

% K_shell: 计算图中节点的K-Shell值
% 输入参数:
%   - mat: 图的邻接矩阵，大小为N*N，其中N为节点数量
% 输出参数:
%   - shell: 节点的K-Shell值，大小为N*1

    degree=sum(mat); % 计算每个节点的度数
    olddegree=degree;
    vector=zeros(1,size(mat,1)); % 用于存储每个节点的K-Shell值
    k=1; % 初始值K为1
    index=find(degree<=k); % 找到度数小于等于K的节点的下标
    [row,vol]=size(mat);
    oldtag=1:row; % 初始化节点标签
    while length(find(vector==0))>0 % 只要还有节点没有计算出K-Shell值，就继续迭代
        vector(oldtag(index))=k; % 将K-Shell值为K的节点标记
        mat(:,index)=[]; % 删除与这些节点相连的边
        mat(index,:)=[]; % 删除与这些节点相连的边
        oldtag(index)=[]; % 删除这些节点的标签
        degree=sum(mat); % 重新计算每个节点的度数
        index=find(degree<=k); % 找到度数小于等于K的节点的下标
        if length(index)<1 % 如果没有度数小于等于K的节点，则K加1
            k=k+1;
        end        
    end
    shell=vector;
    shell=[full(olddegree);full(shell)]';
    shell(:,1)=[]; % 将每个节点的K-Shell值和其度数合并成一个矩阵返回
end
% CIdynamic 函数的作用是基于网络的结构演化，利用网络的邻接矩阵计算节点的重要性指标，
% 并依此选择种子节点，从而实现社区挖掘的目的。
%
% 输入参数：
% net：无向图的邻接矩阵
% l：网络扩展的步数
% seedsize：所选取种子节点的个数
%
% 输出参数：
% nodes：选择的种子节点向量
%
% 算法流程：
% 1. 初始化：用输入参数net赋值给oldnet，nodes为空向量。
% 2. 外层循环：重复seedsize次以下过程，每次选择一个节点。
% 3. 网络扩展：对oldnet矩阵进行l步幂操作，生成新矩阵net。
% 4. 节点重要性指标计算：计算每个节点的指标值。
% 5. 种子节点选择：选择指标值最大的节点，将其加入到nodes向量中。
% 6. 网络更新：将选择的节点及其相关的边从oldnet中删除。
% 7. 返回结果：所有选择的节点向量nodes。
%
% 节点重要性指标计算的具体方法如下：
% 1. 计算节点度的向量a，去掉选择的节点后生成向量b。
% 2. 计算新矩阵net和向量b的乘积，生成向量c。
% 3. 计算节点重要性指标，index=a.*c'，即每个节点的度和其邻居节点度的乘积。
% 4. 将已选择的节点在index中对应的位置赋值为-1，避免重复选择。
% 5. 选择指标值最大的节点，将其加入到nodes向量中。

