function free = is_color_free(color, classid, conflicts, colors)
%
% Check if `color` is available for `classid`.
%

if classid <= length(conflicts)
	for oclass = conflicts{classid}
		if colors(oclass) ~= -1 && colors(oclass) == color
			free = false;
			return;
		end
	end
end
for oclass = get_class_ancestors(classid)
	if colors(oclass) == color
		free = false;
		return;
	end
end
free = true;

end

