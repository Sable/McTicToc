

load('pagerank_hollins.dat');
P = spconvert(pagerank_hollins);

[n, n] = size(P);
P = P';        % much faster if working with columns

for i=1:n
  s = sum(P(:,i));
  if (s ~= 0)
    P(:,i) =  P(:,i) / s;
  end
end

P = P';        % much faster if working with columns

[n,n] = size(P);
[i,j,s] = find(P);

nb_repetitions = 2^4;
offsets = reshape(repmat(0:1:nb_repetitions-1, length(i),1).*n, nb_repetitions*length(i), 1);
row_indices = repmat(i,nb_repetitions,1) + offsets;
column_indices = repmat(j,nb_repetitions,1) + offsets;
values = repmat(s, nb_repetitions,1);
P2 = sparse(row_indices, column_indices, values, nb_repetitions*n, nb_repetitions*n, length(values));

alpha = 0.99;

tic;
profile on;
[n2,n2] = size(P2);
x = powermethod(P2,alpha,10e-8,0);
profile off;
fprintf('took %fs for powermethod\n', toc);

stats = profile('info');

tic;
profile on;
[n2,n2] = size(P2);
x2 = powermethod2(P2,alpha,10e-8,0);
profile off;
fprintf('took %fs for powermethod2\n', toc);

stats2 = profile('info');
