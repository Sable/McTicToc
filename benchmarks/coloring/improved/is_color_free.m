function free = is_color_free(color, classid, conflicts, colors)
%
% Check if `color` is available for `classid`.
%
global matrix;

oconflicts = conflicts(classid, :);
for oclass = 1:length(oconflicts)
    if oconflicts(oclass) == 1
        if colors(oclass) ~= -1 && colors(oclass) == color
            free = false;
            return;
        end
    end
end
ancestors = matrix(classid, :);
for oclass = 1:length(ancestors)
    if ancestors(oclass) > 1
        if colors(oclass) == color
            free = false;
            return;
        end
    end
end
free = true;

end

