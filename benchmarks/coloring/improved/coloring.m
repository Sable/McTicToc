function colors = coloring()
%
% Colorize `classes` using a subtyping `matrix`.
% Linearization is done using the `sortc` function.
%

global sortc; % the sort algorithm
global classes;

% compute backward linear extension of all classes
linext = zeros(1, length(classes));
for classid = 1:length(classes)
	linext(classid) = classid;
end
linext = sortc(linext, @compare_classes);

% compute core, border and crown
core = compute_core(linext);
core = sortc(core, @compare_classes);
[border, core] = compute_border(linext, core);
border = sortc(border, @compare_classes);
crown = compute_crown(linext, core);
crown = sortc(crown, @compare_classes);

% compute conflict graph on core classes
conflicts = compute_conflicts(linext, core);

% colorize classes from core, border then crown
colors = ones(1, length(classes)) * -1;
colors = colorize_classes(core, conflicts, colors);
colors = colorize_classes(border, conflicts, colors);
colors = colorize_classes(crown, conflicts, colors);

end

