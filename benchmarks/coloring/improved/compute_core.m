function core = compute_core(classids)
%
% Compute the set of classes forming the core of the inheritance hierarchy.
%
% The core is composed by:
%	* classes that have mutiple direct parents
%	* parents of classes that have multiple direct parents
%

global matrix;

core = zeros(1, length(classids));
for classid = classids
    ancestors = matrix(classid, :);
    if length(ancestors(ancestors == 2)) > 1
		core(classid) = 1;
		for ancestor = 1:length(ancestors)
            if ancestors(ancestor) > 1
                core(ancestor) = 1;
            end
        end
    end
end
core = find(core);

end
