function [strong, weak] = witnesses(n)
	%profile on
	strong = strong_test(n);
	weak = weak_test(n);
	%p = profile('info');
    %profsave(p,'profile_results')
end
