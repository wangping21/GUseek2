clear;


A = xlsread('SubmissionTable.xlsx', 'finaltable', 'C2:G235');

%A = A'; % make the data row and column corresponding to samples and genes respectively

[n,m] = size(A); % sample size and number of predictors
Ig = 1:m; % repalce it by IP after the first run, the second run, and so on
nIg = length(Ig);


m1 = 93; % Covid-19 patients
m0 = 141;  % Covid-19 free

ID = [ones(m1,1)
      zeros(m0,1)];

  rand('seed',10032020);  
 
 
p = 3;  % # of competing factors, or groups
q=[3 3 3]; % numbers of genes in each group
qmax= max(q); %the maximum number of parameters in each group
I = 1:q(1);
q0 = q(1);
for i=2:p
    I0 = 1:q(i);
    I = [I I0+q0];
    q0 = q0 + q(i);
end

opfunc = @MaxLogisticObjectivefn;

ng = 24;  % replace it by a smaller number after the first run , the second run, and so on
IP = [];
for j=1:10000
    IP0 = [];
    X = ones(m1+m0,1);
    for i=1:p
        IDm = randperm(nIg,q(i))'; 
        X = [X A(:,Ig(IDm))];
        IP0 = [IP0 Ig(IDm)'];
    end
    beta0 = zeros(q0+p,1);
    lb = beta0 - 10;
    ub = beta0 + 10;
    
    beta1 = simulannealbnd(opfunc,beta0',lb',ub');
    ii = 1;
    for i=1:p
        if q(i)>0
            betasa(1:(q(i)+1),i)= beta1(ii:ii+q(i));
            ii = ii + q(i) +1;
        end
    end
    sg = MaxLogistic2(X,ID,n,p,betasa,I,q);
    
    if sg<=ng
        disp([j sg])
        disp(IP0)
        IP = [IP IP0];
        disp(betasa)
        ng = sg;
        pause
    end
end

