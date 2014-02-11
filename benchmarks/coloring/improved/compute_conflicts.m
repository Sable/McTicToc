function conflict_graph = compute_conflicts(classids, core)
%
% Check for conflict in the core of the inheritance hierarchy.
%
% Classes X and Y are in conflict if either:
%  * X and Y have common subclasses
%  * X and Y are the same class
%  * Y is a subclass of X
%

global classes;
global matrix;

conflict_graph = zeros(length(classids), length(classids));

for classid = core
	children = matrix(:, classid);
	for oid = core
		% skip same class
		if classid == oid
			continue;
		end

		has_conflict = false;
		ochildren = matrix(:, oid);

		% check for common subclass
		for child = 1:length(children(:, 1))
           if children(child) > 1
               for ochild = 1:length(ochildren(:, 1))
                   if ochildren(ochild) > 1
                       if child == ochild
                           has_conflict = true;
                       end
                   end
               end
           end
		end
		if has_conflict
            conflict_graph(classid, oid) = 1;
			conflict_graph(oid, classid) = 1;
		end
	end
end

end

