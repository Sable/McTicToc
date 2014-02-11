function run_pagerank(scale, varargin)
    debug = 0;

    % Change alpha parameter to control the number of iterations

    if(scale >= 1 && scale < 10) 
        k = 2;
    elseif(scale >= 10 && scale < 50)
        k = 4;
    elseif(scale >= 50 && scale < 100)
        k = 6;
    elseif(scale == 100)
        k = 10;
    end

    if (debug)
        tic;
    end
    load('pagerank_hollins.dat');
    P = spconvert(pagerank_hollins);

    % Set initial probabilities according to the number of outgoing links
    % on each page

    [n, n] = size(P);
    P = P';        % much faster if working with columns

    for i=1:n
      s = sum(P(:,i));
      if (s ~= 0)
        P(:,i) =  P(:,i) / s;
      end
    end

    P = P';        % much faster if working with columns

    % We scale the problem by replicating the website dataset multiple times,
    % to increase the number of operations while preserving the original distribution
    % of links between pages. The resulting scaled input therefore contains multiple clusters
    % where pages inside a cluster link between each other, while clusters do not link
    % between each other.
    % Visually, the original matrix P is therefore copied diagonally inside the scaled input:
    % [P 0 ... 0;
    %  0 P ... 0;
    %  0 0 ... P]
    %
    % Initializing the scaled matrix was really slow (many hours for k=10) originally because it was done
    % by assigning to the sparse matrix element-wise, which is one of the slowest operation on a sparse matrix
    % with the current representation in matlab. The following sub-routine is much faster (~3s for k=10): it replicates 
    % the original P indices and values using vector operations and directly constructs the sparse matrix from these vectors,
    % which are close to the internal representation used by MATLAB and Octave.

    
    [n,n] = size(P);
    [i,j,s] = find(P);

    nb_repetitions = 2^k;
    offsets = reshape(repmat(0:1:nb_repetitions-1, length(i),1).*n, nb_repetitions*length(i), 1);
    row_indices = repmat(i,nb_repetitions,1) + offsets;
    column_indices = repmat(j,nb_repetitions,1) + offsets;
    values = repmat(s, nb_repetitions,1);
    P2 = sparse(row_indices, column_indices, values, nb_repetitions*n, nb_repetitions*n, length(values));

    alpha = 0.99;

    [n2,n2] = size(P2);
    tic;
    x = powermethod(P2,alpha,10e-8,0);
    time = toc*1000;
    
    load('x_correct.mat', 'x_correct');
    x_correct = repmat(x_correct,nb_repetitions,1);

    if (isequal(x,x_correct))
        correct_answer = 'true';
    else
        correct_answer = 'false';
    end
end

