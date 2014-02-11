function parents = get_class_parents(classid)
%
% Retrieve class direct ancestors from the subtyping matrix
%

global matrix;

values = matrix(classid, :);
parents = zeros(1, length(values(values == 2)) - 1);
index = 1;
for i = 1 : length(values)
	if values(i) == 2
		parents(index) = i;
		index = index + 1;
	end
end

end

