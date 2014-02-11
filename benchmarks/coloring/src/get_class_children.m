function children = get_class_children(classid)
%
% Retrieve class children (direct and indirect) from the subtyping matrix
%

global matrix;

values = matrix(:, classid);
children = zeros(1, length(nonzeros(values)) - 1);
index = 1;
for i = 1 : length(values)
	if values(i) > 1
		children(index) = i;
		index = index + 1;
	end
end

end

