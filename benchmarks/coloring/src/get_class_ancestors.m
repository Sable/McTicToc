function ancestors = get_class_ancestors(classid)
%
% Retrieve class ancestors (direct and indirect) from the subtyping matrix
%

global matrix;

values = matrix(classid, :);
ancestors = zeros(1, length(nonzeros(values)) - 1);
index = 1;
for i = 1 : length(values)
	if values(i) > 1
		ancestors(index) = i;
		index = index + 1;
	end
end

end

