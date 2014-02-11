function [border, core] = compute_border(core)
%
% Compute the set of classes composing the border of the core
%
% We are looking for minimal classes of the core:
%	* that have multiple direct parents
%	* but whose sublcasses are all in single inheritance
%
% Classes belonging to the border are removed from the `core`
%

global matrix;

border = [];
index = 1;
for classid = core
	children = get_class_children(classid);
	children_all_si = true;
	for cid = children
		cparents = get_class_parents(cid);
		if length(cparents) > 1
			children_all_si = false;
		end
	end
	if children_all_si && ~ismember([classid], border)
		border(index) = classid;
		core = core(core ~= classid);
		index = index + 1;
	end
end

end

