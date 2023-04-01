function s=PageRank(mat,alpha)
    a=full(sum(mat));
    a(find(a==0))=size(mat,1);
    a=a.^(-1);
    P=mat*diag(a);
    v=ones(size(mat,1),1);
    s=ones(size(mat,1),1);
    for i=1:40
        s=alpha*P*s+(1-alpha)*v;
    end
end