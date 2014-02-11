function [strong, weak] = witnesses(n)
	%The number of possible witnesses for n is n - 3
	
	strong = strong_test(n);
	weak = weak_test(n);
end
