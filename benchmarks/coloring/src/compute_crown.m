function crown = compute_crown(classids, core)
%
% Compute the set of classes belonging to the crown of the inheritance hierarchy.
%
% The crown is composed by the classes that are not part of the core and are in single inheritance.
%

global matrix;

crown = [];
index = 1;
for classid = classids
	if ismember([classid], core)
		continue;
	end
	parents = get_class_parents(classid);
	if length(parents) <= 1
		if ~ismember([classid], crown)
			crown(index) = classid;
			index = index + 1;
		end
	end
end

end

