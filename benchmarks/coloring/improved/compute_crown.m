function crown = compute_crown(classids, core)
%
% Compute the set of classes belonging to the crown of the inheritance hierarchy.
%
% The crown is composed by the classes that are not part of the core and are in single inheritance.
%

global matrix;

crown = zeros(1, length(classids));
for classid = classids
	if ismember([classid], core)
		continue;
	end
	parents = matrix(classid, :);
	if length(parents(parents == 2)) <= 1
		crown(classid) = classid;
	end
end
crown = find(crown);

end

