%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% function [x] = powermethod(P,alpha,tol)
%%
%% efficient power method to compute stationary vector
%% the operator is:  
%%    A = alpha * P' + (1-alpha)ve'    
%% (personalization vector v=e/n is hard coded)
%% implicitly applies ve' and zero row corrections
%%
%% adapted from: www.limfinity.com/ir
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x] = powermethod(P,alpha,tol,varargin)
debug = 0;
if (size(varargin) > 0)
    debug = cell2mat(varargin(1));
end

if (debug)
    tic;
end
n = size(P,1);
x = ones(n,1) / n;

iteration = 0;
while (1)
  iteration = iteration + 1;
  x0 = x;
  x = alpha * (x'*P)';
  x = x + (1-sum(x))/n;   

  % tracking convergence is noticably time consuming
  % one norm suggested by golub, norm(,1) is inefficient
  change = sum(abs(x-x0));
  if (debug) 
      change
  end
  if (change < tol)
    break;
  end
end

if (debug)
    fprintf(1,'power method took %d iterations to converge to a tolerance of %e\n',iteration,tol);
    fprintf(1,'  elapsed time = %f\n',toc);
end

