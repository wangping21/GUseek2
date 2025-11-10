function sg = MaxLogisticObjectivefn(beta)

% X predictors
% I final predictor indexes
% ID response
% n sampel size
% p the number of max groups
% q coefficients dimensions

X = evalin('base','X');
I = evalin('base','I');
ID = evalin('base','ID');
n = evalin('base','n');
p = evalin('base','p');
q = evalin('base','q');

XX = -ones(n,p)*inf;

ii = 1; i1 = 1;
for i=1:p
    if q(i)>0
        XX(:,i) = [X(:,1) X(:,I(i1:i1+q(i)-1)+1)]*beta(ii:ii+q(i))';
        ii = ii + q(i)+1;
        i1 = i1 + q(i);
    end
end
XX = min(XX,10); % avoid overflow
% generate the responses 
Xmax = max(XX,[],2);
Pmax = exp(Xmax)./(1+exp(Xmax));
Pmaxldot5 = (Pmax<=0.5);
Pmaxgdot5 = (Pmax>.5);
sg = sum(Pmaxldot5.*ID) + sum(Pmaxgdot5.*(1-ID));
return