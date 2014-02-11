function colors = colorize_classes(classset, conflicts, colors)
%
% Colorize the set of classes `classset` using
% the conflict graph `conflicts`.
% Resulting colors are stored in the array `colors`.
%

min_color = 1;
for class = classset
	color = min_color;
	while ~ is_color_free(color, class, conflicts, colors)
		color = color + 1;
	end
	colors(class) = color;
	color = min_color;
end

end

