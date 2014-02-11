function [border, core] = compute_border(classids, core)
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

border = zeros(1, length(classids));
for classid = core
	children = matrix(:, classid);
	children_all_si = true;
	for cid = 1:length(children)
        if(children(cid) > 1)
            cparents = matrix(cid, :);
            if length(cparents(cparents == 2)) > 1
                children_all_si = false;
            end
        end
	end
	if children_all_si
		border(classid) = 1;
		core = core(core ~= classid);
	end
end
border = find(border);

end
