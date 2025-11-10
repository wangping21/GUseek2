function sg = MaxLogistic2(X,ID,n,p,beta,I,q)

XX = -ones(n,p)*inf;

ii = 1;
for i=1:p
    if q(i)>0
        XX(:,i) = [X(:,1) X(:,I(ii:ii+q(i)-1)+1)]*beta(1:q(i)+1,i);
        ii = ii + q(i);
    end
end
XX = min(XX,10);
% generate the responses 
Xmax = max(XX,[],2);
Pmax = exp(Xmax)./(1+exp(Xmax));
Pmaxldot5 = (Pmax<=0.5);
Pmaxgdot5 = (Pmax>.5);
sg = sum(Pmaxldot5.*ID) + sum(Pmaxgdot5.*(1-ID));

return
