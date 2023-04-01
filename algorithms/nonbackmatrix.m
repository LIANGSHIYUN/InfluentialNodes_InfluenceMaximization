function s=nonbackmatrix(mat)
    [row,vol]=size(mat);
    d=sum(mat);
    D=diag(d);
    M=[sparse(mat) sparse(eye(row)-D);sparse(eye(row)) sparse(zeros(row))];
    [V,D]=eigs(M,1,'lr');
    V=V/sum(V);
    %V=V/norm(V);
    s=V(1:row);
end