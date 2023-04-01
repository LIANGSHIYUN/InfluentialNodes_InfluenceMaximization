function [result]=eigadjacent(net,seeds,step)
%分step从seeds中计算去除seeds后剩余网络的最大特征值结果
result=[];
for i=1:step:length(seeds)
    [lambdamax]=eigadjacent1time(net,seeds(1:i));
    result=[result;lambdamax];
    
end


end

function lambda=eigadjacent1time(net,seeds)
[row,vol]=size(seeds);
if row>vol
    seeds=seeds';
end
net(seeds,:)=0;
net(:,seeds)=0;

[V,D]=eigs(sparse(net),1,'la');
% lambda=D;
lambda=1/D;
% lambda=log(D);
end
function lambda=eigadjacent2time(net,seeds)
[row,vol]=size(seeds);
if row>vol
    seeds=seeds';
end
net(seeds,:)=0;
net(:,seeds)=0;



mat=sparse(net);
[row,vol]=size(mat);
M=sparse(2*row,2*row);
M(1:row,1:row)=mat;
M(1:row,(row+1):(2*row))=sparse(1-diag(sum(mat)));
M((row+1):(2*row),1:row)=sparse(eye(row));
[V,D]=eigs(mat,1,'lr');
%%[V,D]=eigs(M,1,'lr'); %%%%%%%M matrix of the Cascading model
lambda=D;
end
