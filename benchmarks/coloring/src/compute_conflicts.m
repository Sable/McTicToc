function conflict_graph = compute_conflicts(core)
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

conflict_graph = {};
for i = core
	conflict_graph{i} = [];
end

for classid = core
	children = get_class_children(classid);

	for oid = core
		% skip same class
		if classid == oid
			continue;
		end

		has_conflict = false;
		ochildren = get_class_children(oid);

		% check for common subclass
		for child = children
			for ochild = ochildren
				if child == ochild
					has_conflict = true;
				end
			end
		end

		if has_conflict
			if ~ ismember([oid], conflict_graph{classid})
				len = length(conflict_graph{classid});
				conflict_graph{classid}(len + 1) = oid;
			end
			if ~ ismember([classid], conflict_graph{oid})
				len = length(conflict_graph{oid});
				conflict_graph{oid}(len + 1) = classid;
			end
		end
	end
end

end

