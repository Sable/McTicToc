function A = bubble_sort(A, compare)
%
% Sort the array `A` using bubble sort algorithm.
% Comparison is done using the provided `compare` function.
%
n = length(A);
swapped = true;
while swapped
	swapped = false;
	for i = 2 : n
		if compare(A(i - 1), A(i)) > 0
			tmp = A(i - 1);
			A(i - 1) = A(i);
			A(i) = tmp;
			swapped = true;
		end
	end
	n = n - 1;
end

end

