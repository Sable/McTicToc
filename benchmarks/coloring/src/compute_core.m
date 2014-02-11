function core = compute_core(classids)
%
% Compute the set of classes forming the core of the inheritance hierarchy.
%
% The core is composed by:
%	* classes that have mutiple direct parents
%	* parents of classes that have multiple direct parents
%

global matrix;

core = [];
index = 1;
for classid = classids
	if length(get_class_parents(classid)) > 1
		ancestors = get_class_ancestors(classid);
		if ~ismember([classid], core)
			core(index) = classid;
			index = index + 1;
		end
		for ancestor = ancestors
			if ~ismember([ancestor], core)
				core(index) = ancestor;
				index = index + 1;
			end
		end
	end
end

end

